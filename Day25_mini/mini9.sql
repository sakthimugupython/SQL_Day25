-- 9. User Registration and Role Manager
CREATE DATABASE IdentityAccessSystem;
USE IdentityAccessSystem;

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY,
    login_name VARCHAR(100),
    access_level VARCHAR(50)
);

CREATE TABLE AccountPreferences (
    pref_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    pref_key VARCHAR(100),
    pref_value VARCHAR(100)
);

CREATE TABLE AccessAudit (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT,
    prev_role VARCHAR(50),
    curr_role VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Accounts VALUES
(101, 'admin_kumar', 'admin'),
(102, 'mgr_pooja', 'manager'),
(103, 'emp_vivek', 'employee');

CREATE OR REPLACE VIEW AdminAccess AS
SELECT account_id, login_name, access_level FROM Accounts WHERE access_level = 'admin';

CREATE OR REPLACE VIEW ManagerAccess AS
SELECT account_id, login_name FROM Accounts WHERE access_level = 'manager';

CREATE OR REPLACE VIEW EmployeeAccess AS
SELECT account_id, login_name FROM Accounts WHERE access_level = 'employee';

DELIMITER //
CREATE PROCEDURE ChangeUserRole(IN aid INT, IN new_role VARCHAR(50))
BEGIN
    DECLARE previous_role VARCHAR(50);
    SELECT access_level INTO previous_role FROM Accounts WHERE account_id = aid;

    UPDATE Accounts SET access_level = new_role WHERE account_id = aid;

    INSERT INTO AccessAudit(account_id, prev_role, curr_role)
    VALUES (aid, previous_role, new_role);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION CheckAdminStatus(acc_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE level VARCHAR(50);
    SELECT access_level INTO level FROM Accounts WHERE account_id = acc_id;
    RETURN level = 'admin';
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER InsertDefaultPrefs
AFTER INSERT ON Accounts
FOR EACH ROW
BEGIN
    INSERT INTO AccountPreferences(account_id, pref_key, pref_value)
    VALUES (NEW.account_id, 'language', 'English'),
           (NEW.account_id, 'alerts', 'on');
END;
//
DELIMITER ;


















