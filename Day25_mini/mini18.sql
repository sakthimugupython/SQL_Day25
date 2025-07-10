-- 18. Online Assessment Tracker

CREATE DATABASE ETestPortal;
USE ETestPortal;

CREATE TABLE Learners (
    learner_id INT PRIMARY KEY,
    learner_name VARCHAR(100)
);

CREATE TABLE Exams (
    exam_id INT PRIMARY KEY,
    learner_id INT,
    topic VARCHAR(100),
    marks INT,
    result VARCHAR(2),
    attempt_time DATETIME,
    is_finalized BOOLEAN
);

CREATE TABLE ExamLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT,
    log_note VARCHAR(100),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Learners VALUES
(101, 'Arun'),
(102, 'Lakshmi');

INSERT INTO Exams VALUES
(201, 101, 'Physics', 88, 'A', '2025-07-10 13:00:00', TRUE),
(202, 102, 'Chemistry', 74, 'B', '2025-07-10 13:20:00', TRUE);

CREATE OR REPLACE VIEW LearnerScores AS
SELECT exam_id, learner_id, topic, marks, result
FROM Exams
WHERE is_finalized = TRUE;

DELIMITER //
CREATE PROCEDURE SubmitExam(
    IN lid INT,
    IN top VARCHAR(100),
    IN mks INT,
    IN res VARCHAR(2),
    IN atime DATETIME
)
BEGIN
    INSERT INTO Exams(learner_id, topic, marks, result, attempt_time, is_finalized)
    VALUES (lid, top, mks, res, atime, FALSE);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION CalculateGrade(marks INT)
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN marks >= 90 THEN 'A+'
        WHEN marks >= 80 THEN 'A'
        WHEN marks >= 70 THEN 'B'
        WHEN marks >= 60 THEN 'C'
        ELSE 'F'
    END;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER BlockFinalizedEdit
BEFORE UPDATE ON Exams
FOR EACH ROW
BEGIN
    IF OLD.is_finalized = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finalized exam cannot be modified';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER LogExamSubmission
AFTER INSERT ON Exams
FOR EACH ROW
BEGIN
    INSERT INTO ExamLogs(exam_id, log_note)
    VALUES (NEW.exam_id, 'Exam Submitted');
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW InstructorOnlyView AS
SELECT exam_id, learner_id, topic, marks, result
FROM Exams
WHERE is_finalized = FALSE;


































