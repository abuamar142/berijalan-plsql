-- membuat tabel dep
create table hr.dep (
   deptno   number,
   name     varchar2(50) not null,
   location varchar2(50),
   constraint pk_departments primary key ( deptno )
);

-- membuat tabel emp
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

-- membuat trigger biu ( before insert update ) untuk tabel dep dengan mengisikan deptno secara otomatis menggunakan sys_guid() ketika nilai deptno tidak diisi
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

-- membuat trigger biu ( before insert update ) untuk tabel emp dengan mengisikan empno secara otomatis menggunakan sys_guid() ketika nilai empno tidak diisi
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

-- menambahkan data ke tabel dep dan emp
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
-- menambahkan data ke tabel emp dengan subquery yang mengambil deptno dari tabel dep berdasarkan nama departemen
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
-- menambahkan data ke tabel emp dengan subquery yang mengambil deptno dari tabel dep berdasarkan nama departemen
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

-- menampilkan data dari tabel emp dan dep dengan join
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

-- menambahkan kolom country_code ke tabel emp
alter table hr.emp add country_code varchar2(2);
-- memperbarui kolom country_code untuk semua baris di tabel emp menjadi 'US'
update hr.emp
   set
   country_code = 'US';
-- memperbarui kolom commission untuk karyawan dengan nama 'Sam Smith' menjadi 2000
update hr.emp
   set
   commission = 2000
 where name = 'Sam Smith';

-- menampilkan data dari tabel emp dengan pengurutan berdasarkan nama
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