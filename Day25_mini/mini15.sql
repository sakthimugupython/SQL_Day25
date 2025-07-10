-- 15. Event Management System

CREATE DATABASE CorpEventsPortal;
USE CorpEventsPortal;

CREATE TABLE Programs (
    program_id INT PRIMARY KEY,
    program_title VARCHAR(100),
    program_date DATE,
    venue VARCHAR(100),
    visibility BOOLEAN
);

CREATE TABLE Attendees (
    attendee_id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT,
    attendee_name VARCHAR(100),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE AttendanceLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    attendee_id INT,
    log_action VARCHAR(100),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Programs VALUES
(101, 'Leadership Summit', '2025-08-15', 'Delhi', TRUE),
(102, 'Marketing Meetup', '2025-08-18', 'Hyderabad', FALSE);

INSERT INTO Attendees (program_id, attendee_name) VALUES
(101, 'Karan Mehta'),
(101, 'Aarti Singh');

CREATE OR REPLACE VIEW OpenProgramSchedule AS
SELECT program_id, program_title, program_date, venue
FROM Programs
WHERE visibility = TRUE;

DELIMITER //
CREATE PROCEDURE EnrollAttendee(
    IN prog_id INT,
    IN aname VARCHAR(100)
)
BEGIN
    INSERT INTO Attendees(program_id, attendee_name)
    VALUES (prog_id, aname);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetAttendeeCount(p_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Attendees WHERE program_id = p_id;
    RETURN total;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER LogEnrollment
AFTER INSERT ON Attendees
FOR EACH ROW
BEGIN
    INSERT INTO AttendanceLog(attendee_id, log_action)
    VALUES (NEW.attendee_id, 'Enrolled');
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW PublicPrograms AS
SELECT program_title, program_date, venue
FROM Programs
WHERE visibility = TRUE;





























