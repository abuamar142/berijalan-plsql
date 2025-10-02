-- ============================================
-- TASK 5: Create procedure insert pengajuan customer
-- ============================================

-- Sequence untuk ID 10 digit
create sequence seq_id_cust_10d start with 1 nocache;

-- Procedure insert pengajuan customer
create or replace procedure prc_insert_pengajuan_customer (
   id_cust          in varchar2,
   amount_pengajuan in number,
   out_status       out varchar2,
   out_message      out varchar2
) as
   v_id_cust_generated varchar2(10);
   v_nama              varchar2(200);
   v_highest_approval  varchar2(10);
   v_cd_user_lowest    varchar2(10);
begin
    -- 1) Validasi input
   if id_cust is null
   or trim(id_cust) = '' then
      out_status := 'F';
      out_message := 'Id Customer harus diisi';
      return;
   end if;

   if amount_pengajuan is null then
      out_status := 'F';
      out_message := 'Amount Pengajuan harus diisi';
      return;
   end if;

    -- 2) Siapkan nilai-nilai
   v_nama := id_cust;  -- nama dari param in id_cust

    -- 3) Get highest approval dari function Task 2
   v_highest_approval := get_highest_level(amount_pengajuan);
    
    -- Jika function mengembalikan ' ', berarti amount diluar range
   if v_highest_approval = ' ' then
      out_status := 'F';
      out_message := 'Failed Insert Data';
      return;
   end if;

    -- 4) Get cd_user level terendah dari Master Approval
   select cd_user
     into v_cd_user_lowest
     from (
      select cd_user
        from mst_approval
       order by min asc
   )
    where rownum = 1;

    -- 5) Generate id_cust 10 digit untuk tabel pengajuan
   select lpad(
      seq_id_cust_10d.nextval,
      10,
      '0'
   )
     into v_id_cust_generated
     from dual;

    -- 6) Insert ke tabel transaksi pengajuan customer
   insert into trn_pengajuan_cust (
      id_cust,
      nama,
      amount_pengajuan,
      status,
      highest_approval,
      cd_user,
      reason_reject,
      date_updated
   ) values ( v_id_cust_generated,
              v_nama,
              amount_pengajuan,
              'WAITING',
              v_highest_approval,
              v_cd_user_lowest,
              null,
              sysdate );

    -- 7) Output sukses
   out_status := 'T';
   out_message := 'Success Insert Data';
exception
   when others then
      out_status := 'F';
      out_message := 'Failed Insert Data';
end prc_insert_pengajuan_customer;
/

-- Test Case 1: Insert berhasil (amount dalam range)
declare
   v_status  varchar2(1);
   v_message varchar2(200);
begin
   prc_insert_pengajuan_customer(
      id_cust          => 'CUST001',
      amount_pengajuan => 2500000,
      out_status       => v_status,
      out_message      => v_message
   );

   dbms_output.put_line('=== TEST CASE 1: Amount dalam range ===');
   dbms_output.put_line('STATUS : ' || v_status);
   dbms_output.put_line('MESSAGE: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 2: Insert failed (amount diluar range di mst_approval)
declare
   v_status  varchar2(1);
   v_message varchar2(200);
begin
   prc_insert_pengajuan_customer(
      id_cust          => 'CUST002',
      amount_pengajuan => 999999999,
      out_status       => v_status,
      out_message      => v_message
   );

   dbms_output.put_line('=== TEST CASE 2: Amount diluar range ===');
   dbms_output.put_line('STATUS : ' || v_status);
   dbms_output.put_line('MESSAGE: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 3: Insert failed (id_cust kosong)
declare
   v_status  varchar2(1);
   v_message varchar2(200);
begin
   prc_insert_pengajuan_customer(
      id_cust          => null,
      amount_pengajuan => 2500000,
      out_status       => v_status,
      out_message      => v_message
   );

   dbms_output.put_line('=== TEST CASE 3: ID Customer kosong ===');
   dbms_output.put_line('STATUS : ' || v_status);
   dbms_output.put_line('MESSAGE: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 4: Insert failed (amount kosong)
declare
   v_status  varchar2(1);
   v_message varchar2(200);
begin
   prc_insert_pengajuan_customer(
      id_cust          => 'CUST004',
      amount_pengajuan => null,
      out_status       => v_status,
      out_message      => v_message
   );

   dbms_output.put_line('=== TEST CASE 4: Amount kosong ===');
   dbms_output.put_line('STATUS : ' || v_status);
   dbms_output.put_line('MESSAGE: ' || v_message);
end;
/