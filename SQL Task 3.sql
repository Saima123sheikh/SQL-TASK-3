create table employees (
EmployeeID serial primary key,
FirstName varchar,
LastName varchar,
Department varchar,
City varchar,
ManagerID int,
Salary int
);

create table customers (
CustomerID serial primary key,
CustomerName varchar,
ContactNumber varchar (15)
);

create table products (
ProductID serial primary key,
ProductName varchar,
Category varchar
);

create table sales (
SaleID serial primary key,
ProductID int references products (productid),
QuantitySold int,
SaleDate date
);


create table events (
EventID serial primary key,
EventName varchar,
EventDate date
);

create table participants (
ParticipantID serial primary key,
ParticipantName varchar,
Score int
);

create table orders (
OrderID serial primary key,
CustomerId int references customers(CustomerId),
OrderDate date,
TotalAmount decimal
);


--1--
Select * from employees
where department = 'IT'
and salary > 50000;

--2--
select o.orderid,c.customername,c.contactnumber from orders o
join customers c on  c.customerid = o.customerid

--3--
select productid, sum (quantitysold) as totalquantitysold from sales 
group by productid order by productid;

--4--
select TO_CHAR (saledate,'mm') as salemonth, avg(quantitysold) as averagequantitysold from sales
group by TO_CHAR (saledate,'mm') ;

--5--
select upper(productname) as productname from products;

--6--
select  eventiD, eventname, eventdate from events
where eventdate between current_date
and (current_date + interval '30 day');

--7--
select * from employees
where salary > ( select avg(salary) as salary from employees);

--8--
create or replace function products_upd()
returns trigger as $$
begin
new.lastmodified = current_timsestamp;
return new;
end;
$$ language plpgsql

create trigger update_products
before update on products
for each row
execute function products_upd();

--9--
create view active_customer as ( select c.customerid,c.customername,o.orderdate from customers c
join orders o on o.customerid = c.customerid
where extract (year from orderdate) = 2023);

--10--
--wrong scenario, but query will be--
select count(*) as NullTotalAmountCount from sales 
where TotalAmount is NULL;

--11--
select ParticipantID, ParticipantName, score, rank () over(order by score desc) from participants;

--12--
--wrong scenario, but query will be--
cummulative salary = total amount of salary earned or paid

select EmployeeID, Salary, Department, sum(Salary) over (partition by Department order by EmployeeID) as cumulativesalary
from salaries;

--13--
Select SaleID,Quantitysold,SaleDate,ProductID,
sum(Quantitysold) over (partition by ProductID) as RunningTotal from sales
order by ProductID, SaleDate, SaleID;

--14--
--wrong scenario, but query will be--
update products set price =price + (price * 10/100)
where  category = 'Electronics';

--15--
--wrong scenario, but query will be--
delete from customers where city = 'delhi';

  


