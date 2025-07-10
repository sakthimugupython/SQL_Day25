-- 10. E-Commerce Product Search & Filter Engine
CREATE DATABASE ShopPortal;
USE ShopPortal;

CREATE TABLE Items (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    item_group VARCHAR(50),
    item_price DECIMAL(10,2),
    offer_percent INT,
    available_stock INT
);

CREATE TABLE ItemLog (
    log_no INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    update_type VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Items VALUES
(101, 'Smartphone', 'Gadgets', 30000, 20, 12),
(102, 'Earbuds', 'Gadgets', 1500, 10, 0),
(103, 'Office Chair', 'Furniture', 4500, 8, 6),
(104, 'Bookshelf', 'Furniture', 3500, 0, 3);

CREATE OR REPLACE VIEW InStockItemsView AS
SELECT item_id, item_name, item_group, item_price, offer_percent
FROM Items
WHERE available_stock > 0;

DELIMITER //
CREATE FUNCTION PriceAfterOffer(iid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE pr DECIMAL(10,2);
    DECLARE off INT;
    DECLARE result DECIMAL(10,2);
    
    SELECT item_price, offer_percent INTO pr, off FROM Items WHERE item_id = iid;
    SET result = pr - (pr * off / 100);
    RETURN result;
END;
//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE FilterItems(IN grp VARCHAR(50), IN min_val DECIMAL(10,2), IN max_val DECIMAL(10,2))
BEGIN
    SELECT * FROM Items
    WHERE item_group = grp AND item_price BETWEEN min_val AND max_val AND available_stock > 0;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER RecordItemEdit
AFTER UPDATE ON Items
FOR EACH ROW
BEGIN
    INSERT INTO ItemLog(item_id, update_type)
    VALUES (NEW.item_id, 'MODIFIED');
END;
//
DELIMITER ;

CREATE OR REPLACE VIEW InStockItemsView AS
SELECT item_id, item_name, item_group, item_price, offer_percent
FROM Items
WHERE available_stock > 0;




















