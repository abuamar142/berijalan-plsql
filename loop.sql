-- basic loops
declare
   v_counter number(2) := 1;
begin
   loop
      dbms_output.put_line('My counter is : ' || v_counter);
      v_counter := v_counter + 1;
      -- if v_counter = 10 then
      --    dbms_output.put_line('Now I reached : ' || v_counter);
      --    exit;
      -- end if;
      exit when v_counter > 10;
   end loop;
end;

-- while loop
declare
   v_counter number(2) := 1;
begin
   while v_counter <= 10 loop
      dbms_output.put_line('My counter is : ' || v_counter);
      v_counter := v_counter + 1;
      -- exit when v_counter > 3;
   end loop;
end;

-- for loop
begin
   for i in 1..10 loop
      dbms_output.put_line('My counter is : ' || i);
   end loop;
end;

declare
   n number := 5; -- Number of rows
begin
   for i in 1..n loop -- Outer loop for rows
      for j in 1..i loop -- Inner loop for columns
         dbms_output.put(j || ' ');
      end loop;
      dbms_output.new_line; -- Move to the next row
   end loop;
end;

declare
   n number := 5; -- Number of rows
begin
   for i in 1..n loop -- Loop for rows
      for j in 1..n - i loop -- Loop for spaces
         dbms_output.put(' ');
      end loop;
      for k in 1..2 * i - 1 loop -- Loop for stars
         dbms_output.put('*');
      end loop;
      dbms_output.new_line; -- Move to the next row
   end loop;
end;

declare
   v_inner number := 1;
begin
   for v_outer in 1..10 loop
      dbms_output.put_line('My outer value is : ' || v_outer);
      v_inner := 1;
      while v_inner * v_outer < 15 loop
         v_inner := v_inner + 1;
         continue when mod(
            v_inner * v_outer,
            2
         ) = 0;
         dbms_output.put_line(' My inner value is : ' || v_inner);
      end loop;
   end loop;
end;

declare
   v_inner number := 1;
begin
   << outer_loop >> for v_outer in 1..10 loop
      dbms_output.put_line('My outer value is : ' || v_outer);
      v_inner := 1;
      << inner_loop >> loop
         v_inner := v_inner + 1;
         continue outer_loop when v_inner = 10;
         dbms_output.put_line(' My inner value is : ' || v_inner);
      end loop inner_loop;
   end loop outer_loop;
end;

declare begin
   for v_outer in 1..10 loop
      dbms_output.put_line('My outer value is : ' || v_outer);
      for v_inner in 2..9 loop
         dbms_output.put_line(' My inner value is : ' || v_inner);
      end loop;
   end loop;
end;

-- finding prime numbers using goto statement
declare
   v_searched_number number := 4;
   v_is_prime        boolean := true;
begin
   for x in 2..v_searched_number - 1 loop
      if v_searched_number mod x = 0 then
         dbms_output.put_line(v_searched_number || ' is not a prime number..');
         v_is_prime := false;
         goto end_point;
      end if;
   end loop;
   if v_is_prime then
      dbms_output.put_line(v_searched_number || ' is a prime number..');
   end if;
   << end_point >> dbms_output.put_line('Check complete..');
end;

declare
   v_searched_number number := 2;
   v_is_prime        boolean := true;
   x                 number := 2;
begin
   << start_point >> if v_searched_number = x then
      goto prime_point;
   end if;
   if v_searched_number mod x = 0 then
      dbms_output.put_line(v_searched_number || ' is not a prime number..');
      v_is_prime := false;
      goto end_point;
   end if;
   x := x + 1;
   if x = v_searched_number then
      goto prime_point;
   end if;
   goto start_point;
   << prime_point >> if v_is_prime then
      dbms_output.put_line(v_searched_number || ' is a prime number..');
   end if;
   << end_point >> dbms_output.put_line('Check complete..');
end;