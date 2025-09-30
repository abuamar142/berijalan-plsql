-- cursor
declare
   cursor c_emps is
   select first_name,
          last_name
     from employees;
   v_first_name employees.first_name%type;
   v_last_name  employees.last_name%type;
begin
   open c_emps;
   fetch c_emps into
      v_first_name,
      v_last_name;
   fetch c_emps into
      v_first_name,
      v_last_name;
   fetch c_emps into
      v_first_name,
      v_last_name;
   dbms_output.put_line(v_first_name
                        || ' '
                        || v_last_name);
   fetch c_emps into
      v_first_name,
      v_last_name;
   dbms_output.put_line(v_first_name
                        || ' '
                        || v_last_name);
   close c_emps;
end;

declare
   v_cur  sys_refcursor;
   v_id   number;
   v_name varchar2(100);
begin
    -- open dynamic cursor
   open v_cur for select employee_id,
                         first_name
                                   from employees
                   where rownum <= 5;

   loop
      fetch v_cur into
         v_id,
         v_name;
      exit when v_cur%notfound;
      dbms_output.put_line('ID: '
                           || v_id
                           || ', Name: '
                           || v_name);
   end loop;
   close v_cur;
end;

-- cursor with join
declare
   cursor c_emps is
   select first_name,
          last_name,
          department_name
     from employees
     join departments
   using ( department_id )
    where department_id between 30 and 60;
   v_first_name      employees.first_name%type;
   v_last_name       employees.last_name%type;
   v_department_name departments.department_name%type;
begin
   open c_emps;
   fetch c_emps into
      v_first_name,
      v_last_name,
      v_department_name;
   dbms_output.put_line(v_first_name
                        || ' '
                        || v_last_name
                        || ' in the department of '
                        || v_department_name);
   close c_emps;
end;

-- cursor parameter
declare
   cursor c_emps (
      p_dept_id number
   ) is
   select first_name,
          last_name,
          department_name
     from employees
     join departments
   using ( department_id )
    where department_id = p_dept_id;
   v_emps c_emps%rowtype;
begin
   open c_emps(60);
   fetch c_emps into v_emps;
   dbms_output.put_line('The employees in department of '
                        || v_emps.department_name
                        || ' are :');
   close c_emps;
   open c_emps(60);
   loop
      fetch c_emps into v_emps;
      exit when c_emps%notfound;
      dbms_output.put_line(v_emps.first_name
                           || ' '
                           || v_emps.last_name);
   end loop;
   close c_emps;
end;

-- cursor with multiple parameters
declare
   cursor c_emps (
      p_dept_id number,
      p_job_id  varchar2
   ) is
   select first_name,
          last_name,
          job_id,
          department_name
     from employees
     join departments
   using ( department_id )
    where department_id = p_dept_id
      and job_id = p_job_id;
   v_emps c_emps%rowtype;
begin
   for i in c_emps(
      50,
      'ST_MAN'
   ) loop
      dbms_output.put_line(i.first_name
                           || ' '
                           || i.last_name
                           || ' '
                           || i.job_id);
   end loop;
   dbms_output.put_line('-');
   for i in c_emps(
      80,
      'SA_MAN'
   ) loop
      dbms_output.put_line(i.first_name
                           || ' '
                           || i.last_name
                           || ' '
                           || i.job_id);
   end loop;
end;