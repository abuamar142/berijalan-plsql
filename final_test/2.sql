-- ============================================
-- TASK 2: Create function get_highest_level
-- ============================================

create or replace function get_highest_level (
   amount_pengajuan in number
) return varchar2 as
   v_cd_user varchar2(10);
begin
    -- Mencari cd_user berdasarkan rentang nominal
   select cd_user
     into v_cd_user
     from mst_approval
    where amount_pengajuan between min and max;

   return v_cd_user;
exception
   when no_data_found then
      return ' ';
   when others then
      return ' ';
end;
/

-- Test cases
declare
   v_cd_user varchar2(10);
begin
    -- Test 1: amount_pengajuan = 6000000, maka cd_user = USER02
   v_cd_user := get_highest_level(6000000);
   dbms_output.put_line('Test 1 (6000000): ' || v_cd_user);
    
    -- Test 2: amount_pengajuan = 45000000, maka cd_user = USER03
   v_cd_user := get_highest_level(45000000);
   dbms_output.put_line('Test 2 (45000000): ' || v_cd_user);
    
    -- Test 3: Amount diluar range, return ' ' (spasi)
   v_cd_user := get_highest_level(999999999);
   dbms_output.put_line('Test 3 (999999999): '''
                        || v_cd_user
                        || '''');
end;
/