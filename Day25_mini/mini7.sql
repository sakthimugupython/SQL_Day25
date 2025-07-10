-- 7. Online Exam Result Generator
CREATE DATABASE OnlineGradeTracker;
USE OnlineGradeTracker;

CREATE TABLE ExamScores (
    score_id INT PRIMARY KEY,
    learner_id INT,
    course VARCHAR(100),
    score INT,
    is_published BOOLEAN DEFAULT FALSE,
    internal_note VARCHAR(255)
);

CREATE TABLE ScoreAudit (
    entry_id INT AUTO_INCREMENT PRIMARY KEY,
    score_id INT,
    event_type VARCHAR(50),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ExamScores VALUES
(201, 501, 'Physics', 85, TRUE, 'Good understanding'),
(202, 502, 'Chemistry', 67, FALSE, 'Can improve'),
(203, 503, 'Biology', 93, TRUE, 'Outstanding');

CREATE OR REPLACE VIEW GradeSummaryView AS
SELECT score_id, learner_id, course, score
FROM ExamScores
WHERE is_published = TRUE;

DELIMITER //
CREATE PROCEDURE GradeAssignment()
BEGIN
    SELECT learner_id, course,
    CASE
        WHEN score >= 90 THEN 'A+'
        WHEN score >= 75 THEN 'A'
        WHEN score >= 60 THEN 'B'
        ELSE 'C'
    END AS grade
    FROM ExamScores
    WHERE is_published = TRUE;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION CalculateGrade(val INT)
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN val >= 90 THEN 'A+'
        WHEN val >= 75 THEN 'A'
        WHEN val >= 60 THEN 'B'
        ELSE 'C'
    END;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER PreventScoreEdit
BEFORE UPDATE ON ExamScores
FOR EACH ROW
BEGIN
    IF OLD.is_published = TRUE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Published scores cannot be changed';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER RecordScoreChange
AFTER UPDATE ON ExamScores
FOR EACH ROW
BEGIN
    INSERT INTO ScoreAudit(score_id, event_type)
    VALUES (OLD.score_id, 'UPDATED');
END;
//
DELIMITER ;














