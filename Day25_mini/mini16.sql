-- 16. Help Desk and Ticket Logger

CREATE DATABASE SupportDeskSystem;
USE SupportDeskSystem;

CREATE TABLE SupportReps (
    rep_id INT PRIMARY KEY,
    rep_name VARCHAR(100)
);

CREATE TABLE Issues (
    issue_id INT PRIMARY KEY,
    problem_text VARCHAR(255),
    rep_assigned INT,
    issue_status VARCHAR(20),
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    closed_at TIMESTAMP
);

CREATE TABLE IssueHistory (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    issue_id INT,
    previous_status VARCHAR(20),
    current_status VARCHAR(20),
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO SupportReps VALUES
(201, 'Deepa'),
(202, 'Manoj');

INSERT INTO Issues VALUES
(301, 'Email not syncing', 201, 'Open', NOW(), NULL),
(302, 'Unable to connect to server', 202, 'Pending', NOW(), NULL);

CREATE OR REPLACE VIEW ActiveIssuesView AS
SELECT issue_id, problem_text, rep_name, issue_status
FROM Issues
JOIN SupportReps ON Issues.rep_assigned = SupportReps.rep_id
WHERE issue_status = 'Open';

DELIMITER //
CREATE PROCEDURE AssignIssue(
    IN iid INT,
    IN rid INT
)
BEGIN
    UPDATE Issues SET rep_assigned = rid WHERE issue_id = iid;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION AverageResolutionHours()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE average_hours DECIMAL(10,2);
    SELECT AVG(TIMESTAMPDIFF(HOUR, reported_at, closed_at)) INTO average_hours
    FROM Issues
    WHERE closed_at IS NOT NULL;
    RETURN IFNULL(average_hours, 0);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER LogIssueStatusChange
BEFORE UPDATE ON Issues
FOR EACH ROW
BEGIN
    IF OLD.issue_status <> NEW.issue_status THEN
        INSERT INTO IssueHistory(issue_id, previous_status, current_status)
        VALUES (OLD.issue_id, OLD.issue_status, NEW.issue_status);
    END IF;
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW RepIssueAccess AS
SELECT issue_id, problem_text, issue_status
FROM Issues
WHERE issue_status IN ('Open', 'Pending');






























