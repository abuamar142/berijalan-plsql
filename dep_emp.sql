create table hr.dep (
   deptno   number,
   name     varchar2(50) not null,
   location varchar2(50),
   constraint pk_departments primary key ( deptno )
);

create table hr.emp (
   empno      number,
   name       varchar2(50) not null,
   job        varchar2(50),
   manager    number,
   hiredate   date,
   salary     number(7,2),
   commission number(7,2),
   deptno     number,
   constraint pk_employees primary key ( empno ),
   constraint fk_employess_deptno foreign key ( deptno )
      references hr.dep ( deptno )
);

create or replace trigger hr.dep_biu before
   insert or update or delete on hr.dep
   for each row
begin
   if
      inserting
      and :new.deptno is null
   then
      :new.deptno := to_number ( sys_guid(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
   end if;
end;
/

create or replace trigger hr.emp_biu before
   insert or update or delete on hr.emp
   for each row
begin
   if
      inserting
      and :new.empno is null
   then
      :new.empno := to_number ( sys_guid(),'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );
   end if;
end;
/

insert into hr.dep (
   name,
   location
) values ( 'Finance',
           'New York' );
insert into hr.dep (
   name,
   location
) values ( 'Development',
           'San Jose' );

insert into hr.emp (
   name,
   job,
   salary,
   deptno
) values ( 'Sam Smith',
           'Programmer',
           5000,
           (
              select deptno
                from hr.dep
               where name = 'Development'
           ) );
insert into hr.emp (
   name,
   job,
   salary,
   deptno
) values ( 'Mara Martin',
           'Analyst',
           6000,
           (
              select deptno
                from hr.dep
               where name = 'Finance'
           ) );
insert into hr.emp (
   name,
   job,
   salary,
   deptno
) values ( 'Yun Yates',
           'Analyst',
           5500,
           (
              select deptno
                from hr.dep
               where name = 'Finance'
           ) );

select e.name employee,
       (
          select name
            from hr.dep d
           where d.deptno = e.deptno
       ) department,
       e.job
  from hr.emp e
 order by e.name;
select e.name employee,
       d.name department,
       e.job,
       d.location
  from hr.dep d,
       hr.emp e
 where d.deptno = e.deptno (+)
 order by d.name,
          e.name;

alter table hr.emp add country_code varchar2(2);
update hr.emp
   set
   country_code = 'US';
update hr.emp
   set
   commission = 2000
 where name = 'Sam Smith';

select name,
       country_code,
       salary,
       commission
  from hr.emp
 order by name;
select count(*) employee_count,
       sum(salary) total_salary,
       sum(commission) total_commission,
       min(salary + nvl(
          commission,
          0
       )) min_compensation,
       max(salary + nvl(
          commission,
          0
       )) max_compensation
  from hr.emp;