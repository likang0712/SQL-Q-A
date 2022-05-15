

/****************************************/
/*
https://www.testdome.com/
testdome public SQL Q&A

A list of the Q&A filter by PUBLIC
https://www.testdome.com/questions?visibility=3&skillId=1483&orderBy=Difficulty&sort=none&skills=6-1483&sets=public

*/
/****************************************/


/* Workers
https://www.testdome.com/questions/sql/workers/69921

The following data definition defines an organization's employee hierarchy.

An employee is a manager if any other employee has their managerId set to this employee's id. That means John is a manager if at least one other employee has their managerId set to John's id.

TABLE employees
  id INTEGER NOT NULL PRIMARY KEY
  managerId INTEGER
  name VARCHAR(30) NOT NULL
  FOREIGN KEY (managerId) REFERENCES employees(id)
Write a query that selects only the names of employees who are not managers.

*/

SELECT name
FROM employees
WHERE id NOT IN
     (SELECT DISTINCT managerId FROM employees WHERE managerId IS NOT NULL)


/* Enrollment
https://www.testdome.com/questions/sql/enrollment/68896

A table containing the students enrolled in a yearly course has incorrect data in records with ids between 20 and 100 (inclusive).

TABLE enrollments
  id INTEGER NOT NULL PRIMARY KEY
  year INTEGER NOT NULL
  studentId INTEGER NOT NULL
Write a query that updates the field 'year' of every faulty record to 2015.
*/

UPDATE enrollments
SET year = 2015
WHERE id BETWEEN 20 AND 100

/* Pets
https://www.testdome.com/questions/sql/pets/68916

Information about pets is kept in two separate tables:

TABLE dogs
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL

TABLE cats
  id INTEGER NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
Write a query that select all distinct pet names.

*/
SELECT DISTINCT *
FROM (SELECT name FROM dogs
      UNION
      SELECT name FROM cats)


/* Sessions
https://www.testdome.com/questions/sql/sessions/68925

App usage data are kept in the following table:

TABLE sessions
  id INTEGER PRIMARY KEY,
  userId INTEGER NOT NULL,
  duration DECIMAL NOT NULL
Write a query that selects userId and average session duration for each user who has more than one session.
*/
SELECT userId, AVG(duration) AS 'avg sesstion'
FROM sessions
GROUP BY userId
HAVING COUNT(*) > 1


/*Students
https://www.testdome.com/questions/sql/students/68927

Given the following data definition, write a query that returns the number of students whose first name is John.

TABLE students
   id INTEGER PRIMARY KEY,
   firstName VARCHAR(30) NOT NULL,
   lastName VARCHAR(30) NOT NULL
*/
SELECT COUNT(*)
FROM students
WHERE firstname LIKE 'John'


/* Regional Sales Comparison
https://www.testdome.com/questions/sql/regional-sales-comparison/76445

An insurance company maintains records of sales made by its employees. Each employee is assigned to a state. States are grouped under regions. The following tables contain the data:

TABLE regions
  id INTEGER PRIMARY KEY
  name VARCHAR(50) NOT NULL

TABLE states
  id INTEGER PRIMARY KEY
  name VARCHAR(50) NOT NULL
  regionId INTEGER NOT NULL
  FOREIGN KEY (regionId) REFERENCES regions(id)

TABLE employees
  id INTEGER PRIMARY KEY
  name VARCHAR(50) NOT NULL
  stateId INTEGER NOT NULL
  FOREIGN KEY (stateId) REFERENCES states(id)

TABLE sales
  id INTEGER PRIMARY KEY
  amount INTEGER NOT NULL
  employeeId INTEGER NOT NULL
  FOREIGN KEY (employeeId) REFERENCES employees(id)  
Management requires a comparative region sales analysis report.

Write a query that returns:

The region name.
Average sales per employee for the region (Average sales = Total sales made for the region / Number of employees in the region).
The difference between the average sales of the region with the highest average sales, and the average sales per employee for the region (average sales to be calculated as explained above).
Employees can have multiple sales. A region with no sales should be also returned. Use 0 for average sales per employee for such a region when calculating the 2nd and the 3rd column.
*/
WITH aa AS (
SELECT regions.name
     , COALESCE(SUM(sales.amount)/COUNT(DISTINCT employees.id), 0) AS average
FROM regions LEFT JOIN states ON (regions.id = states.regionId)
             LEFT JOIN employees ON (employees.stateId = states.id)
             LEFT JOIN sales ON (employees.id = sales.employeeId)
GROUP BY regions.name
)

SELECT name, ROUND(average), ROUND((SELECT MAX(average) FROM aa) - average)
FROM aa


/* Web Shop

https://www.testdome.com/questions/sql/web-shop/69934

Each item in a web shop belongs to a seller. To ensure service quality, each seller has a rating.

The data are kept in the following two tables:

TABLE sellers
  id INTEGER PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  rating INTEGER NOT NULL

TABLE items
  id INTEGER PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  sellerId INTEGER
  FOREIGN KEY (sellerId) REFERENCES sellers(id)
Write a query that selects the item name and the name of its seller for each item that belongs to a seller with a rating greater than 4. The query should return the name of the item as the first column and name of the seller as the second column.
*/

SELECT items.name, sellers.name
FROM sellers, items
WHERE sellers.id = items.sellerId
  AND rating > 4

/* Users And Roles
https://www.testdome.com/questions/sql/users-and-roles/68928

The following two tables are used to define users and their respective roles:

TABLE users
  id INTEGER NOT NULL PRIMARY KEY,
  userName VARCHAR(50) NOT NULL

TABLE roles
  id INTEGER NOT NULL PRIMARY KEY,
  role VARCHAR(20) NOT NULL
The users_roles table should contain the mapping between each user and their roles. Each user can have many roles, and each role can have many users.

Modify the provided SQL create table statement so that:

Only users from the users table can exist within users_roles.
Only roles from the roles table can exist within users_roles.
A user can only have a specific role once.

*/
CREATE TABLE users_roles (
  userId INTEGER NOT NULL,
  roleId INTEGER NOT NULL,
  FOREIGN KEY(userId) REFERENCES users(id),
  FOREIGN KEY(roleId) REFERENCES roles(id),
  PRIMARY KEY (userId, roleId)
)


/* Registrations
https://www.testdome.com/questions/mysql/registrations/68405

Consider the following DDL statement:

CREATE TABLE registrations (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  create_date DATE NOT NULL,
  last_activity DATE NOT NULL
);
Fill in the blanks so that the following select returns all registrations that were last active at least 30 days after being created.
*/
SELECT name, create_date, last_activity 
FROM registrations
WHERE last_activity  >= DATE_ADD(create_date, INTERVAL 30 DAY);


