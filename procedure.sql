-- create procedure
create or replace procedure add_job (
   job_id     pls_integer,
   job_title  varchar2,
   min_salary number default 1000,
   max_salary number default null
) is
begin
   insert into jobs values ( job_id,
                             job_title,
                             min_salary,
                             max_salary );
   dbms_output.put_line('The job : '
                        || job_title
                        || ' is inserted!...');
end;

-- a standard run of the procedure
call add_job(
   '1',
   'IT Director',
   5000,
   20000
);
-- running a procedure with using the default values
call add_job(
   '2',
   'IT Director',
   5000
);
-- running a procedure with the named notation
call add_job(
   '5',
   'IT Director',
   max_salary => 10000
);
-- running a procedure with the named notation example 2
call add_job(
   job_title  => 'IT Director',
   job_id     => '7',
   max_salary => 10000,
   min_salary => 500
);

select *
  from jobs;

create or replace function get_avg_sal (
   p_dept_id departments.department_id%type
) return number as
   v_avg_sal number;
begin
   select avg(salary)
     into v_avg_sal
     from employees
    where department_id = p_dept_id;

   return v_avg_sal;
end get_avg_sal;

-- using a function in begin-end block
declare
   v_avg_salary number;
begin
   v_avg_salary := get_avg_sal(50);
   dbms_output.put_line(v_avg_salary);
end;

-- using functions in a select clause
select employee_id,
       first_name,
       salary,
       department_id,
       get_avg_sal(department_id) avg_sal
  from employees;

-- using functions in group by, order by, where clauses
select get_avg_sal(department_id)
  from employees
 where salary > get_avg_sal(department_id)
 group by get_avg_sal(department_id)
 order by get_avg_sal(department_id);

-- dropping a function 
drop function get_avg_sal;

create or replace procedure get_employee_name (
   p_dept_id number
) is
   v_name varchar2(100);
begin
   select first_name
          || ' '
          || last_name
     into v_name
     from employees
    where department_id = p_dept_id;
   dbms_output.put_line('Nama Karyawan : ' || v_name);
exception
   when no_data_found then
      dbms_output.put_line('Tidak ada karyawan di dept ' || p_dept_id);
   when too_many_rows then
      dbms_output.put_line('Lebih dari 1 karyawan ditemukan di dept ' || p_dept_id);
   when others then
      dbms_output.put_line('Error umum : ' || sqlerrm);
end;

call get_employee_name(30);

create table emps_high_paid
   as
      select *
        from employees
       where 1 = 0;

-- creating and using subprogram is anonymous blocks - true usage
declare
   function get_emp (
      emp_num employees.employee_id%type
   ) return employees%rowtype is
      emp employees%rowtype;
   begin
      select *
        into emp
        from employees
       where employee_id = emp_num;
      return emp;
   end;
   procedure insert_high_paid_emp (
      emp_id employees.employee_id%type
   ) is
      emp employees%rowtype;
   begin
      emp := get_emp(emp_id);
      insert into emps_high_paid values emp;
   end;
begin
   for r_emp in (
      select *
        from employees
   ) loop
      if r_emp.salary > 15000 then
         insert_high_paid_emp(r_emp.employee_id);
      end if;
   end loop;
end;

-- create table hr.trn_error_log
create table hr.trn_error_log (
   dt_error        date default trunc(sysdate),
   no_aggr         varchar2(17 byte),
   attribute1      varchar2(4000 byte),
   attribute2      long,
   proc_name       varchar2(50 byte),
   error_code      varchar2(30 byte),
   error_message   varchar2(1000 byte),
   dt_added        date default sysdate,
   id_user_added   varchar2(30 byte) default 'SYS',
   dt_updated      date,
   id_user_updated varchar2(30 byte)
);

-- create procedure hr.prc_gen_log_error
create or replace procedure hr.prc_gen_log_error (
   pdt_eod      date default trunc(sysdate),
   pno_aggr     varchar2 default ' ',
   pattribute1  varchar2 default ' ',
   pattribute2  long default ' ',
   pproc_name   varchar2 default ' ',
   perror_msg   varchar2 default ' ',
   p_error_code varchar2 default ' '
) is
   v_dt_error   date := trunc(sysdate);
   v_error_code hr.trn_error_log.error_code%type := ' ';
begin
   if p_error_code = ' ' then
      v_error_code := trim(substr(
         perror_msg,
         1,
         90
      ));
   else
      v_error_code := substr(
         p_error_code,
         1,
         50
      );
   end if;

   insert into hr.trn_error_log (
      dt_error,
      no_aggr,
      attribute1,
      attribute2,
      proc_name,
      error_code,
      error_message,
      dt_added,
      id_user_added,
      dt_updated,
      id_user_updated
   ) values ( pdt_eod,
              pno_aggr,
              substr(
                 pattribute1,
                 1,
                 4000
              ),
              pattribute2,
              pproc_name,
              v_error_code,
              perror_msg,
              sysdate,
              'SYSTEM',
              sysdate,
              'SYSTEM' );
   commit;
exception
   when others then
      null;
end;

create or replace procedure get_employee_name2 (
   p_dept_id number
) is
   v_name      varchar2(100);
   v_msg_error varchar2(500);
begin
   select first_name
          || ' '
          || last_name
     into v_name
     from employees
    where department_id = p_dept_id;
   dbms_output.put_line('Nama Karyawan : ' || v_name);
exception
   when others then
      v_msg_error := substr(
         trim(sqlerrm)
         || '-'
         || dbms_utility.format_error_backtrace,
         1,
         500
      );
      dbms_output.put_line('Msg Error : ' || v_msg_error);
      hr.prc_gen_log_error(
         pdt_eod      => trunc(sysdate),
         pno_aggr     => to_char(p_dept_id),
         pattribute1  => '',
         pattribute2  => '',
         pproc_name   => upper('get_employee_name2'),
         perror_msg   => substr(
            v_msg_error,
            1,
            500
         ),
         p_error_code => ''
      );
      dbms_output.put_line('Error umum : ' || sqlerrm);
end;

call get_employee_name2(30);

select *
  from hr.trn_error_log;

-- indexing and hit index
create or replace function get_avg_sal (
   p_dept_id departments.department_id%type
) return number as
   v_avg_sal number;
begin
   select /*+INDEX( employees EMP_DEPARTMENT_IX )*/ avg(salary)
     into v_avg_sal
     from employees
    where department_id = p_dept_id;
   return v_avg_sal;
end get_avg_sal;

-- cek explan (ctrl + shift + E)
select /*+INDEX(employees EMP_DEPARTMENT_IX)*/ avg(salary)
  from employees
 where department_id = 30;
-- wrong using index
select /*+INDEX(employees EMP_EMP_ID_PK)*/ avg(salary)
  from employees
 where department_id = 30;