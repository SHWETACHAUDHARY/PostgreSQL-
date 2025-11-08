Select * from employees where salary >10000;
Select name, department from employees;
Select * from employees;

Select * from employees where hire_date>'2022-01-01';
Select * from employees order by salary desc;
Select * from employees order by salary desc limit 3;

Select count(id) from employees;
Select avg(salary) from employees;
Select min(salary), max(salary) from employees;
select concat(name,department) from employees;
Select name, hire_date, CURRENT_DATE as today, age(current_date,hire_date) from employees;

CREATE table department (dept_id SERIAL PRIMARY KEY,
dept_name varchar(30)
)
Insert into department (dept_name) values ('Engineering'),('Account'),('Compliance')
Alter table employees Add column departments int ;
Update employees set departments=1 where department='Engineering';
Update employees set departments=2 where department='Compliance';
Update employees set departments=3 where department='Account';

Alter table employees drop column department;
Alter table employees SET column 
Alter table employees Alter column departments type foreign key;
Alter table employees Add foreign key(departments) References department(dept_id);

Alter table department alter column dept_name SET not null;
Select * from employees

CREATE table projects (id SERIAL PRIMARY KEY, name varchar(30),emp_id int, foreign key(emp_id) references employees(id))
Insert into projects(name, emp_id) values ('ProjectAAA',1),('ProjectAAA',2),('ProjectBBB',7),('ProjectBBB',5)
Select * from projects
Select e.name,p.name from employees as e 
JOIN projects as p on e.id=p.id

Select e.name,p.name,e.id,p.id from employees as e 
FULL JOIN projects as p on e.id=p.emp_id

Select e.name from employees as e
Left Join projects as p ON e.id!=p.id

Select * from projects as p JOin Employees as e ON p.emp_id=e.id



Select e.name,d.dept_name from employees as e Left JOIN department as d ON d.dept_id=e.departments

Select * from projects as p join employees as e on p.emp_id=e.id






