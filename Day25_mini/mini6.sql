-- 6. Payroll Processing and Monitoring

CREATE DATABASE FinancePayManager;
USE FinancePayManager;

CREATE TABLE StaffMembers (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(100),
    dept_name VARCHAR(100),
    pay DECIMAL(10,2)
);

CREATE TABLE PayAudit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT,
    previous_pay DECIMAL(10,2),
    updated_pay DECIMAL(10,2),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO StaffMembers VALUES
(101, 'Rajesh', 'Admin', 52000),
(102, 'Priya', 'Tech', 68000),
(103, 'Kavya', 'Accounts', 71000);

CREATE OR REPLACE VIEW AdminView AS
SELECT staff_id, staff_name, dept_name, pay FROM StaffMembers;

CREATE OR REPLACE VIEW StaffView AS
SELECT staff_id, staff_name, dept_name FROM StaffMembers;

DELIMITER //
CREATE PROCEDURE GenerateMonthlyPayReport()
BEGIN
    SELECT staff_id, staff_name, dept_name, pay, (pay * 0.10) AS tax_amount, (pay - (pay * 0.10)) AS take_home
    FROM StaffMembers;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION TaxCalculation(s_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE tax_val DECIMAL(10,2);
    SELECT pay * 0.10 INTO tax_val FROM StaffMembers WHERE staff_id = s_id;
    RETURN tax_val;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER PayChangeLogger
BEFORE UPDATE ON StaffMembers
FOR EACH ROW
BEGIN
    IF OLD.pay <> NEW.pay THEN
        INSERT INTO PayAudit(staff_id, previous_pay, updated_pay)
        VALUES (OLD.staff_id, OLD.pay, NEW.pay);
    END IF;
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW PayrollView AS
SELECT staff_id, staff_name, dept_name, pay, (pay * 0.10) AS tax
FROM StaffMembers;












