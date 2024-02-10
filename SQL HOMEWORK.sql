
-------((((((((
-- set1
Create a query with the following columns:
1. PurchaseOrderID, from Purchasing.PurchaseOrderDetail
2. PurchaseOrderDetailID, from Purchasing.PurchaseOrderDetail
3. OrderQty, from Purchasing.PurchaseOrderDetail
4. UnitPrice, from Purchasing.PurchaseOrderDetail
5. LineTotal, from Purchasing.PurchaseOrderDetail
6. OrderDate, from Purchasing.PurchaseOrderHeader
7. A derived column, aliased as “OrderSizeCategory”, calculated via CASE logic as follows:
o When OrderQty > 500, the logic should return “Large”
o When OrderQty > 50 but <= 500, the logic should return “Medium”
o Otherwise, the logic should return “Small”
8. The “Name” field from Production.Product, aliased as “ProductName”
9. The “Name” field from Production.ProductSubcategory, aliased as “Subcategory”; if this value is
NULL, return the string “None” instead
10. The “Name” field from Production.ProductCategory, aliased as “Category”; if this value is NULL,
return the string “None” instead
11.Only return rows where the order date occurred in December of ANY year. The
MONTH function should provide a helpful shortcut here.?*--

set 2
The Sales data in our AdventureWorks database is structured almost identically to our Purchasing data.
It is so similar, in fact, that we can actually align columns from several of the Sales and Purchasing tables
to create a unified dataset in which some rows pertain to Sales, and some to Purchasing. Note that we
are talking about combining data by columns rather than by rows here – think UNION.
So with that said, your second challenge is to enhance your query from Challenge 1 by “stacking” it with
the corresponding Sales data. That may seem daunting, but it is actually WAY easier than it sounds! It
turns out that our two Purchasing tables from the Exercise 1 query map to an equivalent Sales table:
• Purchasing.PurchaseOrderDetail maps to Sales.SalesOrderDetail
• Purchasing.PurchaseOrderHeader maps to Sales.SalesOrderHeader

--set 3
Create a query with the following columns:
11. BusinessEntityID, from Person.Person
12. PersonType, from Person.Person
13. A derived column, aliased as “FullName”, that combines the first, last, and middle names from
Person.Person.
o There should be exactly one space between each of the names.
o If “MiddleName” is NULL and you try to “add” it to the other two names, the result will
be NULL, which isn’t what you want.
o You could use ISNULL to return an empty string if the middle name is NULL, but then
you’d end up with an extra space between first and last name – a space we would have
needed if we had a middle name to work with.
o So what we really need is to apply conditional, IF/THEN type logic; if middle name is
NULL, we just need a space between first name and last name. If not, then we need a
space, the middle name, and then another space. See if you can accomplish this with a
CASE statement.
14. The “AddressLine1” field from Person.Address; alias this as “Address”.
15. The “City” field from Person.Address
16. The “PostalCode” field from Person.Address
17. The “Name” field from Person.StateProvince; alias this as “State”.
18. The “Name” field from Person.CountryRegion; alias this as “Country”.
Only return rows where person type (from Person.Person) is “SP”, OR the postal code begins with a
“9” AND the postal code is exactly 5 charact
Only return rows where person type (from Person.Person) is “SP”, OR the postal code begins with a
“9” AND the postal code is exactly 5 characters long AND the country (i.e., “Name” from
Person.CountryRegion) is “United States”
--- set 4
Enhance your query from Exercise 3 as follows:
1. Join in the HumanResources.Employee table to Person.Person on BusinessEntityID. Note that
many people in the Person.Person table are not employees, and we don’t want to limit our
output to just employees, so choose your join type accordingly.
2. Add the “JobTitle” field from HumanResources.Employee to our output. If it is NULL (as it will be
for people in our Person.Person table who are not employees, return “None”.
3. Add a derived column, aliased as “JobCategory”, that returns different categories based on the
value in the “JobTitle” column as follows:
o If the job title contains the words “Manager”, “President”, or “Executive”, return
“Management”. Applying wildcards with LIKE could be a helpful approach here.
o If the job title contains the word “Engineer”, return “Engineering”.
o If the job title contains the word “Production”, return “Production”.
o If the job title contains the word “Marketing”, return “Marketing”.
o If the job title is NULL, return “NA”.
o If the job title is one of the following exact strings (NOT patterns), return “Human
Resources”: “Recruiter”, “Benefits Specialist”, OR “Human Resources Administrative
Assistant”. You could use a series of ORs here, but the IN keyword could be a nice
shortcut.
o As a default case when none of the other conditions are true, return “Other”.
--- set5
Select the number of days remaining until the end of the current month; that is, the difference in days
between the current date and the last day of the current month.
Your solution should be dynamic: it should work no matter what day, month, or year you run it, which
means it needs to calculate the end of the current month based on the current date.
))))))))))))))))-------------
-- set1
--1
SELECT a.PurchaseOrderID
from Purchasing.PurchaseOrderDetail a
--2
SELECT a.PurchaseOrderDetailID
from Purchasing.PurchaseOrderDetail a
--3
SELECT a.OrderQty
from Purchasing.PurchaseOrderDetail a
--4
SELECT a.UnitPrice
from Purchasing.PurchaseOrderDetail a
--5
SELECT a.LineTotal
from Purchasing.PurchaseOrderDetail a
--6
SELECT a.OrderDate
from Purchasing.PurchaseOrderHeader a
--7
select a.*, [OrderSizeCategory]=
case
when a.OrderQty>500 then 'Large'
when a.OrderQty between 50 and 500 then 'Medium'
else 'Small'
end
from Purchasing.PurchaseOrderDetail a
--8
select a.name 'Product Name'
from Production.product a
--9
select a.Name,ISNULL(a.Name,'None') 'SubCategory'
from Production.ProductSubcategory a
--10
select a.Name,ISNULL(a.Name,'None') 'Category'
from Production.ProductCategory a
--11
select a.*
from Sales.SalesOrderHeader a
where MONTH(a.OrderDate)= MONTH(cast('12-12-2012' as date))

-----set 2
--a
select a.SalesOrderID,a.SalesOrderDetailID,a.OrderQty,a.ProductID,a.UnitPrice,a.LineTotal,a.ModifiedDate
from Sales.SalesOrderDetail a
union all
select b.PurchaseOrderID,b.PurchaseOrderDetailID,b.OrderQty,b.ProductID,b.UnitPrice,b.LineTotal,b.ModifiedDate
from Purchasing.PurchaseOrderDetail b
--b
select a.SalesOrderID,a.RevisionNumber,a.OrderDate,a.ShipDate,a.Status,a.CustomerID,a.SalesPersonID,a.ShipMethodID,a.SubTotal,a.TaxAmt,a.Freight,a.TotalDue,a.ModifiedDate
from Sales.SalesOrderHeader a
union all
select b.PurchaseOrderID,b.RevisionNumber,b.OrderDate,b.ShipDate,b.Status,b.EmployeeID,b.VendorID,b.ShipMethodID,b.SubTotal,b.TaxAmt,b.Freight,b.TotalDue,b.ModifiedDate
from Purchasing.PurchaseOrderHeader b
--set 3
--1
select a.BusinessEntityID
from Person.Person a
--2
select a.PersonType
from Person.Person a
--3
select a.FirstName,a.MiddleName,a.LastName,[Full_Name]=
case 
when a.MiddleName is null then a.FirstName+' '+ a.LastName
else a.FirstName+' '+ a.MiddleName+' '+ a.LastName
end
from Person.Person a
--4
select a.AddressLine1 'Address'
from Person.Address a
--5
select a.city
from Person.Address a
--6
select *
from Person.Address a
--7
select a.Name 'Province'
from Person.StateProvince a
--8
select a.Name 'Country' 
from Person.CountryRegion a
--9
select *
 from Person.Person a
left join Person.EmailAddress b
 on a.BusinessEntityID=b.BusinessEntityID
 where a.PersonType='SP' or(left(b.PostalCode,1)=9 and LEN(b.PostalCode)=5)
--10
select *
 from Person.Person a
join Person.Address b
 on a.BusinessEntityID=b.BusinessEntityID
 where  a.PersonType='SP' or(left(b.PostalCode,1)=9 and LEN(b.PostalCode)=5)
 --11
 select *
 from Person.Person a
join Person.Address b
 on a.BusinessEntityID=b.BusinessEntityID and a.PersonType='SP' or(left(b.PostalCode,1)=9 and LEN(b.PostalCode)=5) 
 inner join Person.CountryRegion c
 where c.Name='United States'
--Only return rows where person type (from Person.Person) is “SP”, OR the postal code begins with a
--“9” AND the postal code is exactly 5 charact
select *
from Person.Address a
where a.PersonType ='SP'OR (left(a.PostalCode,1)=9 and LEN(a.PostalCode)=5) 

select *
from Person.Address a
where a.PersonType ='SP'OR (left(a.PostalCode,1)=9 and LEN(a.PostalCode)=5 and a.Name= 'United States')

--set 4
--1
 select *
 from HumanResources.Employee hem
 right join Person.Person pp
 on hem.BusinessEntityID=pp.BusinessEntityID
 --2
 Add the “JobTitle” field from HumanResources.Employee to our output. If it is NULL (as it will be
for people in our Person.Person table who are not employees, return “None”.

 select *,[JobTitle]= isnull(hem.jobtitle,'None')
 from HumanResources.Employee hem
 right join Person.Person pp
 on hem.BusinessEntityID=pp.BusinessEntityID
 --3
select *,[Jobcategory]= 
case 
when hem.JobTitle like '%Manager%'or hem.JobTitle like '%President%' or hem.JobTitle like '%Executive%' then  'Management'
when hem.JobTitle like '%Engineer%' then  'Engineering'
when hem.JobTitle like '%Production%' then  'Production'
when hem.JobTitle like '%Marketing' then  'Marketing'
when hem.JobTitle is null then  'NA'
when hem.JobTitle in('Recruiter', 'Benefits Specialist','Human Resources Administrative Assistant') then 'Human Resources'
else 'Other'
end
 from HumanResources.Employee hem
 right join Person.Person pp
 on hem.BusinessEntityID=pp.BusinessEntityID
 --3

 select datediff(day,getdate(),dateadd(month,1,dateadd(day,-1,DATEFROMPARTS(year(getdate()),Month(getdate()),1)))) 
 as Remaining_days_in_the_month



