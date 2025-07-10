-- 12. NGO Donation and Campaign Summary
CREATE DATABASE CharityCampaigns;
USE CharityCampaigns;

CREATE TABLE Events (
    event_id INT PRIMARY KEY,
    event_title VARCHAR(100),
    launch_date DATE,
    close_date DATE
);

CREATE TABLE Supporters (
    supporter_id INT PRIMARY KEY,
    supporter_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE Contributions (
    contrib_id INT AUTO_INCREMENT PRIMARY KEY,
    supporter_id INT,
    event_id INT,
    contrib_amount DECIMAL(10,2),
    contrib_date DATE
);

CREATE TABLE ContributionLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    contrib_id INT,
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Events VALUES
(101, 'School Supplies Drive', '2025-05-01', '2025-08-01'),
(102, 'Medical Aid Fund', '2025-06-10', '2025-09-10');

INSERT INTO Supporters VALUES
(201, 'Vikrant', 'vikrant@ngo.org'),
(202, 'Neha', 'neha@ngo.org');

INSERT INTO Contributions (supporter_id, event_id, contrib_amount, contrib_date) VALUES
(201, 101, 750.00, '2025-07-02'),
(202, 101, 600.00, '2025-07-04'),
(201, 102, 1000.00, '2025-07-06');

CREATE OR REPLACE VIEW EventContributionSummary AS
SELECT e.event_title, SUM(c.contrib_amount) AS total_contributions
FROM Contributions c
JOIN Events e ON c.event_id = e.event_id
GROUP BY c.event_id;

DELIMITER //
CREATE PROCEDURE AddContribution(
    IN sid INT,
    IN eid INT,
    IN amt DECIMAL(10,2),
    IN cdate DATE
)
BEGIN
    INSERT INTO Contributions(supporter_id, event_id, contrib_amount, contrib_date)
    VALUES (sid, eid, amt, cdate);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION DonorTotalSupport(sup_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(contrib_amount) INTO total
    FROM Contributions
    WHERE supporter_id = sup_id;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER TrackContribution
AFTER INSERT ON Contributions
FOR EACH ROW
BEGIN
    INSERT INTO ContributionLog(contrib_id)
    VALUES (NEW.contrib_id);
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW PublicSupporterInfo AS
SELECT supporter_id, supporter_name FROM Supporters;
























