CREATE DATABASE Companydata;
USE Companydata;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    created_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    salary DECIMAL(10,2),
    department VARCHAR(50),
    dept_id INT,
    hire_date DATE,
    date_of_birth DATE,
    status VARCHAR(20) DEFAULT 'Active',
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    join_date DATE DEFAULT (CURRENT_DATE),
    city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    category VARCHAR(50),
    stock_quantity INT DEFAULT 0
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    assigned_emp_id INT,
    status VARCHAR(20) DEFAULT 'Active',
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (assigned_emp_id) REFERENCES Employees(emp_id)
);

CREATE TABLE UserRoles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    role_name VARCHAR(50) DEFAULT 'Employee',
    assigned_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

CREATE TABLE Employee_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    action VARCHAR(50),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_values JSON,
    new_values JSON
);

CREATE TABLE Employee_Backup (
    backup_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    emp_name VARCHAR(100),
    deleted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Departments (dept_name, location) VALUES
('IT', 'Bangalore'),
('HR', 'Mumbai'),
('Finance', 'Delhi'),
('Marketing', 'Chennai'),
('Sales', 'Pune');

INSERT INTO Employees (emp_name, first_name, last_name, email, phone, salary, department, dept_id, hire_date, date_of_birth, status) VALUES
('John Doe', 'John', 'Doe', 'john.doe@company.com', '9876543210', 65000, 'IT', 1, '2023-01-15', '1990-05-20', 'Active'),
('Jane Smith', 'Jane', 'Smith', 'jane.smith@company.com', '9876543211', 45000, 'HR', 2, '2023-03-10', '1988-08-15', 'Active'),
('Mike Johnson', 'Mike', 'Johnson', 'mike.johnson@company.com', '9876543212', 75000, 'Finance', 3, '2022-11-20', '1985-12-10', 'Active'),
('Sarah Wilson', 'Sarah', 'Wilson', 'sarah.wilson@company.com', '9876543213', 55000, 'IT', 1, '2024-01-05', '1992-03-25', 'Active'),
('David Brown', 'David', 'Brown', 'david.brown@company.com', '9876543214', 40000, 'Marketing', 4, '2023-06-12', '1989-07-18', 'Active'),
('Lisa Davis', 'Lisa', 'Davis', 'lisa.davis@company.com', '9876543215', 80000, 'IT', 1, '2021-09-08', '1987-11-30', 'Active'),
('Tom Anderson', 'Tom', 'Anderson', NULL, '9876543216', 35000, 'Sales', 5, '2024-02-14', '1993-01-12', 'Inactive'),
('Emily White', 'Emily', 'White', 'emily.white@company.com', '9876543217', 62000, 'Finance', 3, '2024-06-20', '1991-04-08', 'Active');

INSERT INTO Customers (customer_name, email, phone, join_date, city) VALUES
('ABC Corp', 'contact@abc.com', '9123456789', '2024-01-15', 'Mumbai'),
('XYZ Ltd', 'info@xyz.com', '9123456790', '2024-05-20', 'Delhi'),
('PQR Industries', 'sales@pqr.com', '9123456791', '2024-07-01', 'Bangalore'),
('LMN Solutions', 'support@lmn.com', '9123456792', '2023-12-10', 'Chennai');

INSERT INTO Products (product_name, price, category, stock_quantity) VALUES
('Laptop', 50000.00, 'Electronics', 50),
('Mouse', 500.00, 'Electronics', 200),
('Keyboard', 1500.00, 'Electronics', 150),
('Monitor', 15000.00, 'Electronics', 80),
('Printer', 8000.00, 'Electronics', 30);

INSERT INTO Orders (customer_id, product_id, quantity, order_date, total_amount) VALUES
(1, 1, 2, '2024-06-01', 100000.00),
(2, 2, 10, '2024-06-15', 5000.00),
(3, 3, 5, '2024-07-01', 7500.00),
(1, 4, 1, '2024-07-05', 15000.00);

INSERT INTO Projects (project_name, assigned_emp_id, status, start_date, end_date) VALUES
('Website Development', 1, 'Active', '2024-01-01', '2024-12-31'),
('Mobile App', 4, 'Active', '2024-03-01', '2024-09-30'),
('Database Migration', 6, 'Active', '2024-02-15', '2024-08-15');

-- A. Views in SQL (Tasks 1–15)
-- 1. Create a view `ActiveEmployees` that shows employees with `status = 'Active'`.
CREATE VIEW ActiveEmployees AS
SELECT * FROM Employees WHERE status = 'Active';

-- 2. Create a view `HighSalaryEmployees` to display employees earning more than ₹50,000.
CREATE VIEW HighSalaryEmployees AS
SELECT * FROM Employees WHERE salary > 50000;

-- 3. Create a view that joins `Employees` and `Departments` showing `emp_name`, `dept_name`.
CREATE VIEW EmployeeDepartmentView AS
SELECT e.emp_name, d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id;

-- 4. Update the `HighSalaryEmployees` view to also include the `department` column.
DROP VIEW HighSalaryEmployees;
CREATE VIEW HighSalaryEmployees AS
SELECT emp_id, emp_name, salary, department
FROM Employees 
WHERE salary > 50000;

-- 5. Create a view to show only `emp_id`, `emp_name`, and hide the `salary` (for security).
CREATE VIEW SecureEmployeeView AS
SELECT emp_id, emp_name, email, phone, department, hire_date, status
FROM Employees;

-- 6. Create a view `ITEmployees` showing only employees from the 'IT' department.
CREATE VIEW ITEmployees AS
SELECT * FROM Employees WHERE department = 'IT';

-- 7. Drop the view `ITEmployees`.
DROP VIEW ITEmployees;

-- 8. Create a view to show only customers from `Customers` table who joined in the last 6 months.
CREATE VIEW RecentCustomers AS
SELECT * FROM Customers 
WHERE join_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- 9. Create a view with an alias: show `emp_name AS EmployeeName`, `dept_name AS Dept`.
CREATE VIEW EmployeeAlias AS
SELECT emp_name AS EmployeeName, department AS Dept, salary AS Salary
FROM Employees;

-- 10. Create a view that filters out employees with NULL email addresses.
CREATE VIEW EmployeesWithEmail AS
SELECT * FROM Employees WHERE email IS NOT NULL;

-- 11. Create a view that displays employees hired in the last year using `DATEDIFF` or `INTERVAL`.
CREATE VIEW RecentHires AS
SELECT * FROM Employees 
WHERE hire_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);

-- 12. Create a view that includes a computed column (e.g., `bonus = salary * 0.10`).
CREATE VIEW EmployeesWithBonus AS
SELECT emp_id, emp_name, salary, 
       ROUND(salary * 0.10, 2) AS bonus,
       department
FROM Employees;

-- 13. Create a view that joins 3 tables: `Orders`, `Customers`, and `Products`.
CREATE VIEW OrderDetailsView AS
SELECT o.order_id, c.customer_name, p.product_name, 
       o.quantity, o.total_amount, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Products p ON o.product_id = p.product_id;

-- 14. Create a view to simplify a complex query with `GROUP BY` (e.g., total salary by department).
CREATE VIEW DepartmentSalaryView AS
SELECT department, 
       COUNT(*) AS employee_count,
       SUM(salary) AS total_salary,
       AVG(salary) AS average_salary
FROM Employees
WHERE status = 'Active'
GROUP BY department;

-- 15. Create a read-only view for junior staff (exclude salary, bonus, and private info).
CREATE VIEW JuniorStaffView AS
SELECT emp_id, emp_name, email, phone, department, hire_date, status
FROM Employees
WHERE status = 'Active';

-- B. Stored Procedures (Tasks 16–30)
-- 16. Create a stored procedure `GetAllEmployees` to select all records from `Employees`.
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT * FROM Employees;
END //
DELIMITER ;

-- 17. Call `GetAllEmployees()` using `CALL`.
CALL GetAllEmployees();

-- 18. Create a stored procedure `GetEmployeesByDept(IN dept_name VARCHAR(50))`.
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept_name VARCHAR(50))
BEGIN
    SELECT * FROM Employees WHERE department = dept_name;
END //
DELIMITER ;

-- 19. Call `GetEmployeesByDept('HR')`.
CALL GetEmployeesByDept('HR');

-- 20. Create a stored procedure that inserts a new employee with input parameters.
DELIMITER //
CREATE PROCEDURE InsertEmployee(
    IN p_emp_name VARCHAR(100),
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_salary DECIMAL(10,2),
    IN p_department VARCHAR(50),
    IN p_dept_id INT,
    IN p_hire_date DATE,
    IN p_date_of_birth DATE
)
BEGIN
    INSERT INTO Employees (emp_name, first_name, last_name, email, phone, salary, department, dept_id, hire_date, date_of_birth)
    VALUES (p_emp_name, p_first_name, p_last_name, p_email, p_phone, p_salary, p_department, p_dept_id, p_hire_date, p_date_of_birth);
END //
DELIMITER ;

-- 21. Create a stored procedure that deletes an employee by `emp_id`.
DELIMITER //
CREATE PROCEDURE DeleteEmployee(IN p_emp_id INT)
BEGIN
    DELETE FROM Employees WHERE emp_id = p_emp_id;
END //
DELIMITER ;

-- 22. Create a stored procedure that updates salary for a given employee.
DELIMITER //
CREATE PROCEDURE UpdateEmployeeSalary(IN p_emp_id INT, IN p_new_salary DECIMAL(10,2))
BEGIN
    UPDATE Employees 
    SET salary = p_new_salary 
    WHERE emp_id = p_emp_id;
END //
DELIMITER ;

-- 23. Create a stored procedure that returns the total number of employees using OUT parameter.
DELIMITER //
CREATE PROCEDURE GetEmployeeCount(OUT total_employees INT)
BEGIN
    SELECT COUNT(*) INTO total_employees FROM Employees;
END //
DELIMITER ;

-- 24. Modify a stored procedure using `DROP` and recreate it with new logic.
DROP PROCEDURE GetAllEmployees;
DELIMITER //
CREATE PROCEDURE GetAllEmployees()
BEGIN
    SELECT emp_id, emp_name, department, salary, status 
    FROM Employees 
    ORDER BY emp_name;
END //
DELIMITER ;

-- 25. Create a procedure to fetch employees whose name starts with a specific letter.
DELIMITER //
CREATE PROCEDURE GetEmployeesByNameLetter(IN start_letter VARCHAR(1))
BEGIN
    SELECT * FROM Employees 
    WHERE emp_name LIKE CONCAT(start_letter, '%');
END //
DELIMITER ;

-- 26. Create a procedure that calculates and displays average salary per department.
DELIMITER //
CREATE PROCEDURE GetAvgSalaryByDept()
BEGIN
    SELECT department, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department;
END //
DELIMITER ;

-- 27. Create a procedure to count employees in each department using `GROUP BY`.
DELIMITER //
CREATE PROCEDURE CountEmployeesByDept()
BEGIN
    SELECT department, COUNT(*) AS employee_count
    FROM Employees
    GROUP BY department;
END //
DELIMITER ;

-- 28. Create a stored procedure to show employees who joined this month.
DELIMITER //
CREATE PROCEDURE GetEmployeesJoinedThisMonth()
BEGIN
    SELECT * FROM Employees 
    WHERE MONTH(hire_date) = MONTH(CURRENT_DATE) 
    AND YEAR(hire_date) = YEAR(CURRENT_DATE);
END //
DELIMITER ;

-- 29. Create a stored procedure that performs multiple queries (select + insert log).
DELIMITER //
CREATE PROCEDURE ProcessEmployeeData(IN p_emp_id INT)
BEGIN
    SELECT * FROM Employees WHERE emp_id = p_emp_id;
    
    INSERT INTO Employee_Audit (emp_id, action, action_time) 
    VALUES (p_emp_id, 'Data Accessed', NOW());
END //
DELIMITER ;

-- 30. Call a procedure inside a transaction and rollback if an error occurs.
DELIMITER //
CREATE PROCEDURE TransferEmployee(IN p_emp_id INT, IN p_new_dept VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE Employees 
    SET department = p_new_dept 
    WHERE emp_id = p_emp_id;
    
    INSERT INTO Employee_Audit (emp_id, action, action_time) 
    VALUES (p_emp_id, 'Department Transfer', NOW());
    
    COMMIT;
END //
DELIMITER ;

-- C. SQL Functions (Tasks 31–40)
-- 31. Create a function `EmployeeCount(dept_name VARCHAR(50)) RETURNS INT`.
DELIMITER //
CREATE FUNCTION EmployeeCount(dept_name VARCHAR(50)) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE emp_count INT;
    SELECT COUNT(*) INTO emp_count 
    FROM Employees 
    WHERE department = dept_name;
    RETURN emp_count;
END //
DELIMITER ;

-- 32. Call `SELECT EmployeeCount('Finance');`.
SELECT EmployeeCount('Finance') AS FinanceEmployees;

-- 33. Create a function to return the average salary of a department.
DELIMITER //
CREATE FUNCTION GetAvgSalary(dept_name VARCHAR(50)) 
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE avg_sal DECIMAL(10,2);
    SELECT AVG(salary) INTO avg_sal 
    FROM Employees 
    WHERE department = dept_name;
    RETURN IFNULL(avg_sal, 0);
END //
DELIMITER ;

-- 34. Create a function to calculate age from date of birth.
DELIMITER //
CREATE FUNCTION CalculateAge(birth_date DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, birth_date, CURDATE());
END //
DELIMITER ;

-- 35. Create a function that returns the highest salary in the `Employees` table.
DELIMITER //
CREATE FUNCTION GetHighestSalary() 
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE max_sal DECIMAL(10,2);
    SELECT MAX(salary) INTO max_sal FROM Employees;
    RETURN IFNULL(max_sal, 0);
END //
DELIMITER ;

-- 36. Create a function that returns a formatted full name (`first_name + ' ' + last_name`).
DELIMITER //
CREATE FUNCTION GetFullName(first_name VARCHAR(50), last_name VARCHAR(50)) 
RETURNS VARCHAR(101)
DETERMINISTIC
BEGIN
    RETURN CONCAT(IFNULL(first_name, ''), ' ', IFNULL(last_name, ''));
END //
DELIMITER ;

-- 37. Create a function that returns whether a department exists (`BOOLEAN` output).
DELIMITER //
CREATE FUNCTION DepartmentExists(dept_name VARCHAR(50)) 
RETURNS BOOLEAN
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE dept_count INT;
    SELECT COUNT(*) INTO dept_count 
    FROM Departments 
    WHERE dept_name = dept_name;
    RETURN dept_count > 0;
END //
DELIMITER ;

-- 38. Create a function to calculate the number of working days since joining.
DELIMITER //
CREATE FUNCTION GetWorkingDays(join_date DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), join_date);
END //
DELIMITER ;

-- 39. Create a function that returns the total number of orders for a customer.
DELIMITER //
CREATE FUNCTION GetCustomerOrderCount(cust_id INT) 
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count 
    FROM Orders 
    WHERE customer_id = cust_id;
    RETURN order_count;
END //
DELIMITER ;

-- 40. Create a function to return true if an employee is eligible for bonus (salary > 60000).
DELIMITER //
CREATE FUNCTION IsBonusEligible(emp_salary DECIMAL(10,2)) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    RETURN emp_salary > 60000;
END //
DELIMITER ;

-- D. Triggers in SQL (Tasks 41–50)
-- 41. Create a table `Employee_Audit` with `emp_id`, `action`, `action_time`.
-- Already created above

-- 42. Create an `AFTER INSERT` trigger on `Employees` to log new entries into `Employee_Audit`.
DELIMITER //
CREATE TRIGGER logNewEmployee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit (emp_id, action, action_time, new_values)
    VALUES (NEW.emp_id, 'INSERT', NOW(), 
            JSON_OBJECT('emp_name', NEW.emp_name, 'department', NEW.department, 'salary', NEW.salary));
END //
DELIMITER ;

-- 43. Insert a new employee and verify the audit table is updated.
INSERT INTO Employees (emp_name, first_name, last_name, email, phone, salary, department, dept_id, hire_date, date_of_birth)
VALUES ('Test Employee', 'Test', 'Employee', 'test@company.com', '9999999999', 50000, 'IT', 1, CURRENT_DATE, '1990-01-01');

-- 44. Create a `BEFORE UPDATE` trigger to prevent salary from decreasing.
DELIMITER //
CREATE TRIGGER preventSalaryDecrease
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be decreased';
    END IF;
END //
DELIMITER ;

-- 45. Update an employee's salary and ensure the rule is enforced.
UPDATE Employees SET salary = 70000 WHERE emp_id = 1;

-- 46. Create an `AFTER DELETE` trigger to log deleted employee IDs in a backup table.
DELIMITER //
CREATE TRIGGER logDeletedEmployee
AFTER DELETE ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Backup (emp_id, emp_name, deleted_date)
    VALUES (OLD.emp_id, OLD.emp_name, NOW());
    
    INSERT INTO Employee_Audit (emp_id, action, action_time, old_values)
    VALUES (OLD.emp_id, 'DELETE', NOW(), 
            JSON_OBJECT('emp_name', OLD.emp_name, 'department', OLD.department, 'salary', OLD.salary));
END //
DELIMITER ;

-- 47. Create a trigger that updates a `LastModified` column in `Employees` after any update.
DELIMITER //
CREATE TRIGGER updateLastModified
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    SET NEW.last_modified = NOW();
END //
DELIMITER ;

-- 48. Create a trigger to automatically insert default roles for a new user in `UserRoles` table.
DELIMITER //
CREATE TRIGGER assignDefaultRole
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO UserRoles (emp_id, role_name, assigned_date)
    VALUES (NEW.emp_id, 'Employee', NOW());
END //
DELIMITER ;

-- 49. Drop the trigger `logNewEmployee`.
DROP TRIGGER IF EXISTS logNewEmployee;

-- 50. Test a complex trigger that prevents deletion if an employee is assigned to active projects.
DELIMITER //
CREATE TRIGGER preventDeleteActiveEmployee
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    DECLARE active_projects INT;
    SELECT COUNT(*) INTO active_projects 
    FROM Projects 
    WHERE assigned_emp_id = OLD.emp_id AND status = 'Active';
    
    IF active_projects > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot delete employee with active projects';
    END IF;
END //
DELIMITER ;

SELECT * FROM ActiveEmployees;
SELECT * FROM HighSalaryEmployees;
SELECT * FROM EmployeeDepartmentView;
SELECT * FROM RecentCustomers;
SELECT * FROM EmployeesWithBonus;
SELECT * FROM OrderDetailsView;
SELECT * FROM DepartmentSalaryView;

CALL GetAllEmployees();
CALL GetEmployeesByDept('IT');
CALL GetAvgSalaryByDept();
CALL CountEmployeesByDept();

SELECT EmployeeCount('IT') AS IT_Employees;
SELECT GetAvgSalary('Finance') AS Finance_Avg_Salary;
SELECT CalculateAge('1990-05-20') AS Age;
SELECT GetHighestSalary() AS Max_Salary;
SELECT GetFullName('John', 'Doe') AS Full_Name;
SELECT DepartmentExists('IT') AS IT_Exists;
SELECT GetWorkingDays('2023-01-15') AS Working_Days;
SELECT GetCustomerOrderCount(1) AS Customer_Orders;
SELECT IsBonusEligible(65000) AS Bonus_Eligible;

SELECT * FROM Employee_Audit;
SELECT * FROM UserRoles;

CREATE INDEX idx_emp_department ON Employees(department);
CREATE INDEX idx_emp_salary ON Employees(salary);
CREATE INDEX idx_emp_status ON Employees(status);
CREATE INDEX idx_emp_hire_date ON Employees(hire_date);
CREATE INDEX idx_customer_join_date ON Customers(join_date);
CREATE INDEX idx_order_date ON Orders(order_date);