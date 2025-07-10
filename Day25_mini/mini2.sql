-- 2. Sales Reporting & Summary System
CREATE DATABASE RetailSummarySystem;
USE RetailSummarySystem;

CREATE TABLE Transactions (
    txn_id INT PRIMARY KEY,
    item_id INT,
    buyer_id INT,
    txn_value DECIMAL(10,2),
    txn_date DATE
);

CREATE TABLE TransactionLog (
    entry_id INT AUTO_INCREMENT PRIMARY KEY,
    txn_id INT,
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Buyers (
    buyer_id INT PRIMARY KEY,
    buyer_name VARCHAR(100)
);

INSERT INTO Transactions VALUES
(201, 2011, 301, 7200, '2025-06-03'),
(202, 2012, 302, 6400, '2025-06-28'),
(203, 2011, 303, 2500, '2025-07-03'),
(204, 2013, 302, 9800, '2025-07-07');

INSERT INTO Buyers VALUES
(301, 'Priya'),
(302, 'Rahul'),
(303, 'Neha');

CREATE OR REPLACE VIEW MonthlyTransactionSummary AS
SELECT DATE_FORMAT(txn_date, '%Y-%m') AS txn_month, SUM(txn_value) AS monthly_total
FROM Transactions
GROUP BY txn_month;

DELIMITER //
CREATE FUNCTION TotalValueByItem(item INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE val DECIMAL(10,2);
    SELECT SUM(txn_value) INTO val FROM Transactions WHERE item_id = item;
    RETURN IFNULL(val, 0);
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Top10Buyers()
BEGIN
    SELECT b.buyer_id, b.buyer_name, SUM(t.txn_value) AS total_value
    FROM Transactions t
    JOIN Buyers b ON t.buyer_id = b.buyer_id
    GROUP BY b.buyer_id, b.buyer_name
    ORDER BY total_value DESC
    LIMIT 10;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER RecordTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO TransactionLog(txn_id) VALUES (NEW.txn_id);
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW ManagerAccessView AS
SELECT txn_id, item_id, buyer_id, txn_value, txn_date
FROM Transactions;

CREATE OR REPLACE VIEW ClerkAccessView AS
SELECT txn_id, item_id, txn_date
FROM Transactions;





