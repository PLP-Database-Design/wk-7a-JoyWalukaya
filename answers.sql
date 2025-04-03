-- ====================
-- Question 1: Achieving 1NF (First Normal Form)
-- ====================
-- The Products column contains multiple values, which violates 1NF.
-- We need to split the products into separate rows to achieve 1NF.

SELECT OrderID, CustomerName, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n
ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1
ORDER BY OrderID, n.n;

-- This query will transform the ProductDetail table by splitting the Products column into individual rows.
-- Each product now has a separate row under the same OrderID and CustomerName.

-- ====================
-- Question 2: Achieving 2NF (Second Normal Form)
-- ====================
-- The original table has partial dependencies, where the CustomerName depends only on the OrderID.
-- To achieve 2NF, we need to remove the partial dependency by creating two tables:
-- 1. Orders table: Stores OrderID and CustomerName (OrderID is the primary key).
-- 2. OrderDetails table: Stores Product and Quantity with the foreign key referencing OrderID.

-- 1. Create the Orders table: This stores the OrderID and CustomerName.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- 2. Insert data into Orders table from the original OrderDetails table.
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- 3. Create the OrderDetails table: This stores OrderID, Product, and Quantity.
CREATE TABLE OrderDetails (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 4. Insert data into OrderDetails table from the original OrderDetails table.
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

