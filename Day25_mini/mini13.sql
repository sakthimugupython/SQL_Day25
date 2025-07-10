-- 13. Restaurant Table Reservation System

CREATE DATABASE DineReserveSystem;
USE DineReserveSystem;

CREATE TABLE Seating (
    seat_id INT PRIMARY KEY,
    seats INT,
    seat_status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_name VARCHAR(100),
    seat_id INT,
    booking_time DATETIME,
    booking_status VARCHAR(50)
);

CREATE TABLE BookingAudit (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    event_type VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Seating VALUES
(101, 4, 'Available'),
(102, 2, 'Available'),
(103, 8, 'Available');

CREATE OR REPLACE VIEW OpenSeatsView AS
SELECT * FROM Seating WHERE seat_status = 'Available';

DELIMITER //
CREATE PROCEDURE MakeBooking(
    IN gname VARCHAR(100),
    IN sid INT,
    IN btime DATETIME
)
BEGIN
    INSERT INTO Bookings(guest_name, seat_id, booking_time, booking_status)
    VALUES (gname, sid, btime, 'Reserved');

    UPDATE Seating SET seat_status = 'Reserved' WHERE seat_id = sid;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION IsSeatFree(sid INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE stat VARCHAR(20);
    SELECT seat_status INTO stat FROM Seating WHERE seat_id = sid;
    RETURN stat;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER MarkSeatReserved
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Seating SET seat_status = 'Reserved' WHERE seat_id = NEW.seat_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER LogBookingCancel
AFTER DELETE ON Bookings
FOR EACH ROW
BEGIN
    INSERT INTO BookingAudit(booking_id, event_type)
    VALUES (OLD.booking_id, 'Cancelled');
END;
//
DELIMITER ;


























