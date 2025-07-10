-- 11. Doctor Appointment and Notification Tracker

CREATE DATABASE MedTrackSystem;
USE MedTrackSystem;

CREATE TABLE Physicians (
    physician_id INT PRIMARY KEY,
    physician_name VARCHAR(100),
    dept VARCHAR(100)
);

CREATE TABLE Consultations (
    consult_id INT AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(100),
    physician_id INT,
    consult_time DATETIME,
    consult_status VARCHAR(50)
);

CREATE TABLE AlertLog (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    physician_id INT,
    alert_msg VARCHAR(255),
    alert_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Physicians VALUES
(101, 'Dr. Nair', 'Orthopedics'),
(102, 'Dr. Desai', 'Pediatrics'),
(103, 'Dr. Rao', 'ENT');

INSERT INTO Consultations (client_name, physician_id, consult_time, consult_status) VALUES
('Sneha', 101, '2025-07-13 09:30:00', 'Scheduled'),
('Amit', 102, '2025-07-13 10:30:00', 'Scheduled');

CREATE OR REPLACE VIEW PhysicianScheduleView AS
SELECT c.consult_id, c.client_name, p.physician_name, c.consult_time, c.consult_status
FROM Consultations c
JOIN Physicians p ON c.physician_id = p.physician_id;

DELIMITER //
CREATE PROCEDURE ScheduleConsultation(
    IN cname VARCHAR(100),
    IN pid INT,
    IN ctime DATETIME
)
BEGIN
    INSERT INTO Consultations(client_name, physician_id, consult_time, consult_status)
    VALUES (cname, pid, ctime, 'Scheduled');
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetNextSlot(pid INT)
RETURNS DATETIME
DETERMINISTIC
BEGIN
    DECLARE slot DATETIME;
    SELECT MIN(consult_time) INTO slot
    FROM Consultations
    WHERE physician_id = pid AND consult_time > NOW();
    RETURN slot;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER SendNotificationOnConsult
AFTER INSERT ON Consultations
FOR EACH ROW
BEGIN
    INSERT INTO AlertLog(physician_id, alert_msg)
    VALUES (NEW.physician_id, CONCAT('New consultation booked with ', NEW.client_name));
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW SafePhysicianView AS
SELECT physician_id, physician_name, dept
FROM Physicians;






















