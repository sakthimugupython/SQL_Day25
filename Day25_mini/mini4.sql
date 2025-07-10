-- 4. Product Stock and Audit Logger

CREATE DATABASE StockLoggerSystem;
USE StockLoggerSystem;

CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    item_type VARCHAR(100),
    quantity INT,
    cost_price DECIMAL(10,2)
);

CREATE TABLE ItemAudit (
    audit_no INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    change_type VARCHAR(50),
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Items VALUES
(101, 'Monitor', 'Electronics', 40, 12000),
(102, 'Mouse', 'Electronics', 75, 600),
(103, 'Marker', 'Office Supplies', 20, 15),
(104, 'Stapler', 'Office Supplies', 55, 90);

CREATE OR REPLACE VIEW LimitedStockView AS
SELECT item_id, item_name, item_type, quantity
FROM Items
WHERE quantity < 50;

DELIMITER //
CREATE PROCEDURE InsertNewItem(
    IN iid INT,
    IN iname VARCHAR(100),
    IN itype VARCHAR(100),
    IN qty INT,
    IN cost DECIMAL(10,2)
)
BEGIN
    INSERT INTO Items VALUES(iid, iname, itype, qty, cost);
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER TrackItemChange
AFTER INSERT ON Items
FOR EACH ROW
BEGIN
    INSERT INTO ItemAudit(item_id, change_type) VALUES (NEW.item_id, 'INSERT');
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION StockSumByType(itemtype VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE stock_total INT;
    SELECT SUM(quantity) INTO stock_total FROM Items WHERE item_type = itemtype;
    RETURN IFNULL(stock_total, 0);
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW PublicItemView AS
SELECT item_id, item_name, item_type, quantity
FROM Items;









