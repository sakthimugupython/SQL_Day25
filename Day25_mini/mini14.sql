-- 14. Service Center Workflow Automation

CREATE DATABASE WorkflowManager;
USE WorkflowManager;

CREATE TABLE Jobs (
    job_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    job_type VARCHAR(100),
    job_created DATETIME,
    job_status VARCHAR(20)
);

CREATE TABLE Engineers (
    engineer_id INT PRIMARY KEY,
    engineer_name VARCHAR(100)
);

CREATE TABLE JobAudit (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT,
    log_message VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Jobs VALUES
(101, 'Naveen', 'AC Service', '2025-07-10 09:00:00', 'Open'),
(102, 'Divya', 'Washing Machine Repair', '2025-07-10 10:00:00', 'Closed'),
(103, 'Sita', 'TV Installation', '2025-07-10 11:30:00', 'Open');

INSERT INTO Engineers VALUES
(201, 'Ramesh'),
(202, 'Anil');

CREATE OR REPLACE VIEW JobStatusView AS
SELECT job_id, client_name, job_type, job_status
FROM Jobs
WHERE job_status IN ('Open', 'Closed');

DELIMITER //
CREATE PROCEDURE AllocateEngineer(
    IN j_id INT,
    IN eng_id INT
)
BEGIN
    INSERT INTO JobAudit(job_id, log_message)
    VALUES (j_id, CONCAT('Engineer ', eng_id, ' assigned.'));
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION JobDuration(j_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE duration INT;
    SELECT TIMESTAMPDIFF(HOUR, job_created, NOW()) INTO duration
    FROM Jobs WHERE job_id = j_id;
    RETURN duration;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER RecordJobClosure
AFTER UPDATE ON Jobs
FOR EACH ROW
BEGIN
    IF NEW.job_status = 'Closed' THEN
        INSERT INTO JobAudit(job_id, log_message)
        VALUES (NEW.job_id, 'Job successfully completed.');
    END IF;
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW ClientJobView AS
SELECT job_id, job_type, job_status
FROM Jobs;




























