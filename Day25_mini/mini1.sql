-- 1. Employee Access Control System

CREATE DATABASE StaffControlSystem;
USE StaffControlSystem;

CREATE TABLE StaffMembers (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(100),
    team_name VARCHAR(100),
    pay_amount DECIMAL(10,2)
);

CREATE TABLE StaffAudit (
    audit_entry INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT,
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO StaffMembers VALUES
(101, 'Ravi', 'Admin', 55000),
(102, 'Sana', 'Tech', 72000),
(103, 'Kiran', 'Accounts', 83000);

CREATE OR REPLACE VIEW PublicStaffView AS
SELECT staff_id, staff_name, team_name FROM StaffMembers;

DELIMITER //
CREATE PROCEDURE FetchStaffByTeam(IN team VARCHAR(100))
BEGIN
    SELECT * FROM StaffMembers WHERE team_name = team;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER InsertStaffLog
AFTER INSERT ON StaffMembers
FOR EACH ROW
BEGIN
    INSERT INTO StaffAudit(staff_id) VALUES (NEW.staff_id);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION TeamMemberCount(team_input VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE count_result INT;
    SELECT COUNT(*) INTO count_result FROM StaffMembers WHERE team_name = team_input;
    RETURN count_result;
END;
//
DELIMITER ;




