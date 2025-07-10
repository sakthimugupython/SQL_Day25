-- 20. Real Estate Property Listing Portal

CREATE DATABASE PropertyPortal;
USE PropertyPortal;

CREATE TABLE Listings (
    listing_id INT PRIMARY KEY,
    headline VARCHAR(100),
    area VARCHAR(100),
    cost DECIMAL(12,2),
    listing_status VARCHAR(20),
    seller_name VARCHAR(100),
    seller_email VARCHAR(100)
);

CREATE TABLE Viewings (
    viewing_id INT AUTO_INCREMENT PRIMARY KEY,
    listing_id INT,
    viewer_name VARCHAR(100),
    view_date DATE,
    view_time TIME,
    booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ListingLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    listing_id INT,
    log_action VARCHAR(100),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Listings VALUES
(101, '3BHK Flat', 'Chennai', 6500000.00, 'Available', 'Kiran Babu', 'kiran@mail.com'),
(102, 'Independent House', 'Pune', 9200000.00, 'Sold', 'Anusha Iyer', 'anusha@mail.com');

INSERT INTO Viewings (listing_id, viewer_name, view_date, view_time)
VALUES (101, 'Preethi Das', '2025-07-21', '10:00:00');

CREATE OR REPLACE VIEW ActiveListingsView AS
SELECT listing_id, headline, area, cost, listing_status
FROM Listings
WHERE listing_status = 'Available';

DELIMITER //
CREATE PROCEDURE BookViewing(
    IN lid INT,
    IN vname VARCHAR(100),
    IN vdate DATE,
    IN vtime TIME
)
BEGIN
    INSERT INTO Viewings(listing_id, viewer_name, view_date, view_time)
    VALUES (lid, vname, vdate, vtime);
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetListingCount(area_input VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE count_result INT;
    SELECT COUNT(*) INTO count_result FROM Listings WHERE area = area_input;
    RETURN count_result;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER LogListingUpdate
AFTER UPDATE ON Listings
FOR EACH ROW
BEGIN
    INSERT INTO ListingLogs(listing_id, log_action)
    VALUES (NEW.listing_id, 'Listing Modified');
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW PublicListingView AS
SELECT listing_id, headline, area, cost, listing_status
FROM Listings;




































