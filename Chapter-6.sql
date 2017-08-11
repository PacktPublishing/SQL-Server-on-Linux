/* Chapter 6. Crash Course in Querying 
					SQL Source code*/

--Retrieves data from columns "ProductNumber" and "Name", stored inside the "Product" table
USE AdventureWorks

SELECT TOP 5 ProductNumber, Name
FROM Production.Product


--This approach should be avoided in production environments
SELECT *
FROM Production.Product


--Playing with string functions
SELECT SUBSTRING ('SQL Server loves Linux', 18, 5)

SELECT LEFT ('SQL Server loves Linux', 3)

SELECT UPPER ('SQL Server loves Linux')

SELECT REPLACE ('SQL Server loves Linux', 'Linux', 'openSUSE')

SELECT LEN ('SQL Server loves Linux')

/* Company manager requires a list of all products, which next to the product name should 
 contain a product number and colour. Product names should all be capitalized and the list 
 should omit the product initials (first two characters) contained rest of a product number.*/
SELECT TOP 5 UPPER (Name),
SUBSTRING (ProductNumber, 4, 6) , Color
FROM Production.Product

--List of products that can be manufactured in two days
SELECT ProductNumber, Color
FROM Production.Product
WHERE DaysToManufacture = 2

--List of products whose weight is greater than or equal to 1000
SELECT Name, Weight
FROM Production.Product
WHERE Weight >= 1000

--Retrieve Name and ProductNumber of the products named “Chainring”
SELECT Name
FROM Production.Product
WHERE Name = 'Chainring'

--Producst name start with "A" and third character is "f" 
SELECT Name
FROM Production.Product
WHERE Name LIKE '[^A]_f%'

--Return top 3 rows from table Products whose "ListPrice" is less than 2000 AND takes no longer than 1 day to manufacture them
SELECT TOP 3 ProductNumber, ListPrice, DaysToManufacture
FROM Production.Product
WHERE ListPrice < 2000 AND DaysToManufacture = 1

--Same query but with OR
SELECT TOP 3ProductNumber, ListPrice, DaysToManufacture
FROM Production.Product
WHERE ListPrice < 2000 OR DaysToManufacture = 1

--Option with NOT
SELECT TOP 3 ProductNumber, ListPrice, DaysToManufacture
FROM Production.Product
WHERE NOT ListPrice < 2000

--Return top 5 products whose color is NULL
SELECT TOP 5 Name, Color
FROM Production.Product
WHERE Color IS NULL

--Replace NULL value with  more appropriate term such as N/A
SELECT TOP 5 Name, ISNULL (Color, 'N/A')
FROM Production.Product

--List of persons orderd by LastName, asceding
SELECT TOP 10  LastName, FirstName
FROM Person.Person
ORDER BY LastName

--Sorting can be carried out on multiple columns where each can have a different form of sorting
SELECT TOP 10  LastName, FirstName
FROM Person.Person
ORDER BY LastName DESC, FirstName ASC

--Increase price by 17 %
SELECT ProductNumber AS Number,
	ListPrice AS 'Old price', (ListPrice*1.17) AS 'New price'
FROM Production.Product
WHERE ListPrice > 3400

--The largest and smallest list prices, average size of product, and the total days spent to manufacture the product
SELECT MAX (ListPrice) AS MaxPrice, 
	MIN (ListPrice) AS MinPrice, 
	AVG (CONVERT (int, Size)) AS AvgSize,
	SUM (DaysToManufacture) AS TotalDays
FROM Production.Product
WHERE ISNUMERIC (Size) = 1

--Count the number of rows and number of column data in the "Production.Product" table
SELECT COUNT (*), COUNT (SellEndDate) 
FROM Production.Product

--Query will return an error
SELECT ProductID, COUNT (ProductID) AS ProductSales, 
	SUM (LineTotal) As Profit
FROM Purchasing.PurchaseOrderDetail
ORDER BY ProductID

--Same query with GROUP BY clause
SELECT TOP 5 ProductID, COUNT (ProductID) AS ProductSales, 
	SUM (LineTotal) As Profit
FROM Purchasing.PurchaseOrderDetail
GROUP BY ProductID
ORDER BY ProductID

--Query will return an error
SELECT SUM (OrderQty) AS TotalOrderQty
FROM Purchasing.PurchaseOrderDetail
WHERE SUM (OrderQty) > 1000

--Same query with HAVING clause
SELECT SUM (OrderQty) AS TotalOrderQty
FROM Purchasing.PurchaseOrderDetail
HAVING SUM (OrderQty) > 1000

--List of all products for which a review is created
SELECT P.ProductNumber, LEFT (R.Comments, 20)
FROM Production.Product AS P
	INNER JOIN Production.ProductReview AS R
		ON P.ProductID = R.ProductID

--LEFT JOIN version of previous query
SELECT TOP 7 P.ProductNumber, LEFT (R.Comments, 20)
FROM Production.Product AS P
	LEFT JOIN Production.ProductReview AS R
		ON P.ProductID = R.ProductID
ORDER BY R.Comments DESC

--RIGHT JOIN version of previous query
SELECT TOP 10 P.ProductNumber, LEFT (R.Comments, 20)
FROM Production.Product AS P
	RIGHT JOIN Production.ProductReview AS R
		ON P.ProductID = R.ProductID

--Quantity of every product on each production location		
SELECT TOP 10 P.Name AS Product, L.Name AS Location, I.Quantity
FROM Production.Product AS P
	INNER JOIN Production.ProductInventory AS I
		ON P.ProductID = I.ProductID
	INNER JOIN Production.Location L
		ON L.LocationID = I.LocationID
ORDER BY Quantity DESC

--Products whose price is higher than average prices of the same sub-category
SELECT TOP 4 P1.Name, P1.ListPrice
FROM Production.Product AS P1
	INNER JOIN Production.Product AS P2
		ON P1.ProductSubcategoryID = P2.ProductSubcategoryID
GROUP BY P1.Name, P1.ListPrice
HAVING P1.ListPrice > AVG (P2.ListPrice)












