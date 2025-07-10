-- 17. Transport Booking and Route Manager

CREATE DATABASE TravelSystem;
USE TravelSystem;

CREATE TABLE Journeys (
    journey_id INT PRIMARY KEY,
    start_city VARCHAR(100),
    end_city VARCHAR(100),
    start_time DATETIME
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    journey_id INT,
    ticket_code VARCHAR(10),
    booked BOOLEAN
);

CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    traveler_name VARCHAR(100),
    journey_id INT,
    ticket_id INT,
    reserved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Journeys VALUES
(101, 'Delhi', 'Jaipur', '2025-07-17 07:00:00'),
(102, 'Ahmedabad', 'Surat', '2025-07-18 10:15:00');

INSERT INTO Tickets VALUES
(201, 101, 'C1', FALSE),
(202, 101, 'C2', TRUE),
(203, 102, 'D1', FALSE),
(204, 102, 'D2', FALSE);

CREATE OR REPLACE VIEW ClientJourneyView AS
SELECT journey_id, start_city, end_city, start_time
FROM Journeys;

DELIMITER //
CREATE PROCEDURE ReserveTicket(
    IN tname VARCHAR(100),
    IN jid INT,
    IN tid INT
)
BEGIN
    INSERT INTO Reservations(traveler_name, journey_id, ticket_id)
    VALUES (tname, jid, tid);

    UPDATE Tickets SET booked = TRUE WHERE ticket_id = tid;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION SeatStatus(tid INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE msg VARCHAR(20);
    SELECT IF(booked, 'Booked', 'Available') INTO msg FROM Tickets WHERE ticket_id = tid;
    RETURN msg;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER UpdateBookedFlag
AFTER INSERT ON Reservations
FOR EACH ROW
BEGIN
    UPDATE Tickets SET booked = TRUE WHERE ticket_id = NEW.ticket_id;
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW PublicJourneyRoutes AS
SELECT start_city, end_city, start_time FROM Journeys;
































