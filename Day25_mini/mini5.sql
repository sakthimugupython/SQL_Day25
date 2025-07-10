-- 5. Leave Management System
CREATE DATABASE HRLeaveManager;
USE HRLeaveManager;

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(100),
    supervisor_id INT
);

CREATE TABLE LeaveQuota (
    staff_id INT PRIMARY KEY,
    leave_remaining INT
);

CREATE TABLE LeaveEntries (
    entry_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT,
    days_requested INT,
    approval_status VARCHAR(50)
);

INSERT INTO Staff VALUES
(101, 'Nikhil', 201),
(102, 'Sara', 201),
(103, 'Tushar', 202),
(201, 'Supervisor1', NULL),
(202, 'Supervisor2', NULL);

INSERT INTO LeaveQuota VALUES
(101, 9),
(102, 11),
(103, 7);

INSERT INTO LeaveEntries (staff_id, days_requested, approval_status) VALUES
(101, 3, 'Pending'),
(102, 2, 'Pending');

CREATE VIEW SupervisorLeaveView AS
SELECT le.entry_id, le.staff_id, s.staff_name, le.days_requested, le.approval_status
FROM LeaveEntries le
JOIN Staff s ON le.staff_id = s.staff_id
WHERE s.supervisor_id = 201;

DELIMITER //
CREATE PROCEDURE HandleLeaveApproval(IN eid INT, IN status VARCHAR(50))
BEGIN
    UPDATE LeaveEntries
    SET approval_status = status
    WHERE entry_id = eid;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION RemainingLeaveCheck(staff INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE remain INT;
    SELECT leave_remaining INTO remain FROM LeaveQuota WHERE staff_id = staff;
    RETURN IFNULL(remain, 0);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER UpdateLeaveQuota
AFTER INSERT ON LeaveEntries
FOR EACH ROW
BEGIN
    UPDATE LeaveQuota
    SET leave_remaining = leave_remaining - NEW.days_requested
    WHERE staff_id = NEW.staff_id;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS UpdateLeaveQuota;

DELIMITER //
CREATE TRIGGER UpdateLeaveQuota
AFTER INSERT ON LeaveEntries
FOR EACH ROW
BEGIN
    UPDATE LeaveQuota
    SET leave_remaining = leave_remaining - NEW.days_requested
    WHERE staff_id = NEW.staff_id;
END;
//
DELIMITER ;










