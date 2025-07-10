-- 3. Student Information Portal
CREATE DATABASE CampusPortal;
USE CampusPortal;

CREATE TABLE Learners (
    learner_id INT PRIMARY KEY,
    learner_name VARCHAR(100),
    enrollment_year INT,
    grade_point DECIMAL(3,2),
    paid_fees DECIMAL(10,2)
);

CREATE TABLE LearnerAudit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    learner_id INT,
    audit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Learners VALUES
(101, 'Vikram', 2021, 8.7, 48000),
(102, 'Meena', 2023, 9.3, 53000),
(103, 'Tarun', 2021, 7.9, 47000);

CREATE OR REPLACE VIEW LearnerPublicView AS
SELECT learner_id, learner_name, grade_point FROM Learners;

CREATE OR REPLACE VIEW AdminAccessView AS
SELECT learner_id, learner_name, paid_fees FROM Learners;

DELIMITER //
CREATE PROCEDURE FetchLearnersByYear(IN enroll_year INT)
BEGIN
    SELECT * FROM Learners WHERE enrollment_year = enroll_year;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION FetchGradePoint(l_id INT)
RETURNS DECIMAL(3,2)
DETERMINISTIC
BEGIN
    DECLARE gpa DECIMAL(3,2);
    SELECT grade_point INTO gpa FROM Learners WHERE learner_id = l_id;
    RETURN gpa;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER TrackNewLearner
AFTER INSERT ON Learners
FOR EACH ROW
BEGIN
    INSERT INTO LearnerAudit(learner_id) VALUES (NEW.learner_id);
END;
//
DELIMITER ;

DROP VIEW IF EXISTS LearnerPublicView;
DROP VIEW IF EXISTS AdminAccessView;







