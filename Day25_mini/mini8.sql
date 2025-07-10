-- 8. Customer Loyalty Program

CREATE DATABASE RewardsManager;
USE RewardsManager;

CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    reward_points INT
);

CREATE TABLE RewardAudit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    before_points INT,
    after_points INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Clients VALUES
(101, 'Vikram', 140),
(102, 'Meena', 230),
(103, 'Asha', 60);

CREATE OR REPLACE VIEW ClientRewardsView AS
SELECT client_id, client_name, reward_points,
CASE
    WHEN reward_points >= 200 THEN 'Gold'
    WHEN reward_points >= 100 THEN 'Silver'
    ELSE 'Bronze'
END AS level
FROM Clients;

DELIMITER //
CREATE FUNCTION LoyaltyTier(p INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN p >= 200 THEN 'Gold'
        WHEN p >= 100 THEN 'Silver'
        ELSE 'Bronze'
    END;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ModifyPoints(IN cid INT, IN updated_pts INT)
BEGIN
    DECLARE old_pts INT;
    SELECT reward_points INTO old_pts FROM Clients WHERE client_id = cid;
    
    UPDATE Clients
    SET reward_points = updated_pts
    WHERE client_id = cid;
    
    INSERT INTO RewardAudit(client_id, before_points, after_points)
    VALUES (cid, old_pts, updated_pts);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER TrackPointUpdate
AFTER UPDATE ON Clients
FOR EACH ROW
BEGIN
    IF OLD.reward_points <> NEW.reward_points THEN
        INSERT INTO RewardAudit(client_id, before_points, after_points)
        VALUES (OLD.client_id, OLD.reward_points, NEW.reward_points);
    END IF;
END;
//
DELIMITER ;

DROP VIEW IF EXISTS ClientRewardsView;

CREATE OR REPLACE VIEW ClientRewardsView AS
SELECT client_id, client_name, reward_points,
CASE
    WHEN reward_points >= 300 THEN 'Platinum'
    WHEN reward_points >= 200 THEN 'Gold'
    WHEN reward_points >= 100 THEN 'Silver'
    ELSE 'Bronze'
END AS level
FROM Clients;
















