-- output
   set SERVEROUTPUT on;
declare
   v varchar2(20) := 2 + 25 * 3;
begin
   dbms_output.put_line(v);
end;

--------------------------------
declare
   v_text    varchar2(50) not null default 'Hello';
   v_number1 number := 50;
   v_number2 number(2) := 50.42;
   v_number3 number(
      10,
      2
   ) := 50.42;
   v_number4 pls_integer := 50;
   v_number5 binary_float := 5.42;
   v_date1   date := to_date ( '2025/09/29 12:01:32','YYYY/MM/DD HH:MI:SS' );
   v_date2   timestamp := systimestamp;
   v_date3   timestamp(9) with time zone := systimestamp;
begin
   v_text := 'PL/SQL' || 'Bootcamp';
   dbms_output.put_line(v_text);
   dbms_output.put_line(v_number1);
   dbms_output.put_line(v_number2);
   dbms_output.put_line(v_number3);
   dbms_output.put_line(v_number4);
   dbms_output.put_line(v_number5);
   dbms_output.put_line(v_date1);
   dbms_output.put_line(to_char(
      v_date1,
      'DD-MON-YYYY HH24:MI:SS'
   ));
   dbms_output.put_line(v_date2);
   dbms_output.put_line(v_date3);
end;

--using boolean
declare
   v_boolean boolean := false;
begin
   dbms_output.put_line(sys.diutil.bool_to_int(v_boolean));
end;

-- %type attribute
-- desc employees;
declare
   v_type  employees.job_id%type;
   v_type2 v_type%type;
   v_type3 employees.job_id%type;
begin
   v_type := 'IT_PROG';
   v_type2 := 'SA_MAN';
   v_type3 := null;
   dbms_output.put_line(v_type);
   dbms_output.put_line(v_type2);
   dbms_output.put_line(v_type3);
end;

-- delimiters and commenting
declare
   v_text varchar2(10) := 'PL/SQL';
begin
    -- This is a single line comment
/* This is a
multi-line 
comment */
-- DBMS_OUTPUT.PUT_LINE(V_TEXT || 'is a good language');
   null;
end;

-- if statement
declare
   v_number number := -10;
begin
   if v_number < 10 then
      dbms_output.put_line('I am smaller than 10');
   elsif v_number < 20 then
      dbms_output.put_line('I am smaller than 20');
   elsif v_number < 30 then
      dbms_output.put_line('I am smaller than 30');
   else
      dbms_output.put_line('I am equal or greater than 30');
   end if;
end;
declare
   v_number number := 30;
   v_name   varchar2(30) := 'Adam';
begin
   if v_number < 10
   or v_name = 'Carol' then
      dbms_output.put_line('Hi');
      dbms_output.put_line('I am smaller than 10');
   elsif v_number < 20 then
      dbms_output.put_line('I am smaller than 20');
   elsif v_number < 30 then
      dbms_output.put_line('I am smaller than 30');
   else
      if v_number is null then
         dbms_output.put_line('The number is null..');
      else
         dbms_output.put_line('I am equal or greater than 30');
      end if;
   end if;
end;

-- simple case expression
declare
   v_job_code        varchar2(10) := 'SA_MAN';
   v_salary_increase number;
begin
   v_salary_increase :=
      case v_job_code
         when 'SA_MAN' then
            1.2
         when 'SA_REP' then
            0.3
         else 0
      end;
   dbms_output.put_line('Your salary increase is : ' || v_salary_increase);
end;

-- searched case expression
declare
   v_job_code        varchar2(10) := 'IT_PROG';
   v_department      varchar2(10) := 'IT';
   v_salary_increase number;
begin
   v_salary_increase :=
      case
         when v_job_code = 'SA_MAN' then
            0.2
         when
            v_department = 'IT'
            and v_job_code = 'IT_PROG'
         then
            0.3
         else 0
      end;
   dbms_output.put_line('Your salary increase is : ' || v_salary_increase);
end;
declare
   v_job_code        varchar2(10) := 'IT_PROG';
   v_department      varchar2(10) := 'IT';
   v_salary_increase number;
begin
   case
      when v_job_code = 'SA_MAN' then
         v_salary_increase := 0.2;
         dbms_output.put_line('The salary increase for a Sales Manager is : ' || v_salary_increase);
      when
         v_department = 'IT'
         and v_job_code = 'IT_PROG'
      then
         v_salary_increase := 0.3;
         dbms_output.put_line('The salary increase for an IT Programmer is : ' || v_salary_increase);
      else
         v_salary_increase := 0;
         dbms_output.put_line('The salary increase for this job code is : ' || v_salary_increase);
   end case;
end;

-- decode
select employee_id,
       first_name
       || ' '
       || last_name,
       department_id,
       decode(
          department_id,
          10,
          'Accounting',
          20,
          'Sales',
          30,
          'IT',
          'Other'
       ) as department_name
  from hr.employees;