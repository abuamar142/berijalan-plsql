-- ============================================
-- TASK 6: Create function get_next_level_app
-- ============================================

create or replace function get_next_level_app (
   cd_user_current     in varchar2,
   cd_highest_approval in varchar2
) return varchar2 as
   v_current_no   number(2);
   v_highest_no   number(2);
   v_next_no      number(2);
   v_next_cd_user varchar2(10);
begin
    -- Jika cd_user_current = cd_highest_approval, return ' ' (spasi)
   if cd_user_current = cd_highest_approval then
      return ' ';
   end if;
    
    -- Ambil nomor urut current user
   select no
     into v_current_no
     from mst_approval
    where cd_user = cd_user_current;
    
    -- Ambil nomor urut highest user
   select no
     into v_highest_no
     from mst_approval
    where cd_user = cd_highest_approval;

    -- Hitung next level
   v_next_no := v_current_no + 1;
    
    -- Jika next level > highest level, return ' ' (spasi)
   if v_next_no > v_highest_no then
      return ' ';
   end if;

    -- Cari cd_user untuk level approval berikutnya
   select cd_user
     into v_next_cd_user
     from mst_approval
    where no = v_next_no;

   return v_next_cd_user;
exception
   when no_data_found then
      return ' ';
   when others then
      return ' ';
end get_next_level_app;
/

-- Test cases
declare
   v_next_user varchar2(10);
begin
    -- Test 1: cd_user_current = 'USER02' maka cd_user_next = 'USER03'
   v_next_user := get_next_level_app(
      'USER02',
      'USER05'
   );
   dbms_output.put_line('Test 1 - Current USER02, Highest USER05: '''
                        || v_next_user
                        || '''');
    
    -- Test 2: cd_user_current = 'USER04' maka cd_user_next = 'USER05'
   v_next_user := get_next_level_app(
      'USER04',
      'USER05'
   );
   dbms_output.put_line('Test 2 - Current USER04, Highest USER05: '''
                        || v_next_user
                        || '''');
    
    -- Test 3: cd_user_current = cd_highest approval, maka return ' ' (spasi)
   v_next_user := get_next_level_app(
      'USER05',
      'USER05'
   );
   dbms_output.put_line('Test 3 - Current USER05, Highest USER05: '''
                        || v_next_user
                        || '''');
end;
/


-- USER02 -> next = USER03 (selama highest >= USER03)
select get_next_level_app(
   'USER02',
   'USER05'
) as next_user
  from dual;

-- USER04 -> next = USER05
select get_next_level_app(
   'USER04',
   'USER05'
) as next_user
  from dual;

-- Jika current sudah highest -> ' ' (spasi)
select '['
       || get_next_level_app(
   'USER05',
   'USER05'
)
       || ']' as next_user
  from dual;

-- Jika current di atas batas highest (misal highest USER03) -> ' '
select '['
       || get_next_level_app(
   'USER04',
   'USER03'
)
       || ']' as next_user
  from dual;