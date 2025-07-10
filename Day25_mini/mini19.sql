-- 19. Insurance Policy Issuance System

CREATE DATABASE SecurePolicySystem;
USE SecurePolicySystem;

CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Coverages (
    coverage_id INT PRIMARY KEY,
    client_id INT,
    coverage_type VARCHAR(100),
    valid_from DATE,
    valid_to DATE,
    fee DECIMAL(10,2),
    coverage_status VARCHAR(20)
);

CREATE TABLE CoverageLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    coverage_id INT,
    log_action VARCHAR(100),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Clients VALUES
(101, 'Anita Joseph', 'anita@securemail.com'),
(102, 'Sunil Rao', 'sunil@securemail.com');

INSERT INTO Coverages VALUES
(201, 101, 'Life', '2025-02-01', '2030-02-01', 30000.00, 'Active'),
(202, 102, 'Home', '2025-06-01', '2030-06-01', 12000.00, 'Active');

CREATE OR REPLACE VIEW ClientCoverageStatus AS
SELECT coverage_id, client_id, coverage_type, valid_from, valid_to, coverage_status
FROM Coverages;

DELIMITER //
CREATE PROCEDURE GenerateCoverage(
    IN clid INT,
    IN ctype VARCHAR(100),
    IN vfrom DATE,
    IN vto DATE,
    IN amt DECIMAL(10,2)
)
BEGIN
    DECLARE new_id INT;
    SET new_id = (SELECT IFNULL(MAX(coverage_id), 200) + 1 FROM Coverages);
    INSERT INTO Coverages(coverage_id, client_id, coverage_type, valid_from, valid_to, fee, coverage_status)
    VALUES (new_id, clid, ctype, vfrom, vto, amt, 'Active');
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetActiveCoverageCount(clid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE active_cnt INT;
    SELECT COUNT(*) INTO active_cnt
    FROM Coverages
    WHERE client_id = clid AND coverage_status = 'Active';
    RETURN active_cnt;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER TrackCoverageUpdate
AFTER UPDATE ON Coverages
FOR EACH ROW
BEGIN
    INSERT INTO CoverageLog(coverage_id, log_action)
    VALUES (NEW.coverage_id, 'Coverage Info Changed');
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW ExternalCoverageView AS
SELECT coverage_id, coverage_type, valid_from, valid_to, coverage_status
FROM Coverages;




































