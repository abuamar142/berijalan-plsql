-- ============================================
-- TASK 7: Create procedure gen_approval
-- ============================================

create or replace procedure gen_approval (
   id_cust         in varchar2,
   cd_user         in varchar2,
   result_approval in varchar2,
   reason_reject   in varchar2,
   out_status      out varchar2,
   out_message     out varchar2
) as
   v_amount_pengajuan number;
   v_highest_approval varchar2(10);
   v_current_no_sr    number(2);
   v_next_cd_user     varchar2(10);
begin
    -- 1. Validasi Input
   if id_cust is null then
      out_status := 'F';
      out_message := 'Id Customer harus diisi';
      return;
   end if;

   if cd_user is null then
      out_status := 'F';
      out_message := 'CD User Approval harus diisi';
      return;
   end if;

   if result_approval is null then
      out_status := 'F';
      out_message := 'Result Approval harus diisi';
      return;
   end if;

   if result_approval not in ( 'APPROVED',
                               'REJECTED' ) then
      out_status := 'F';
      out_message := 'Result Approval tidak sesuai';
      return;
   end if;
    
    -- Jika result approval REJECTED, reason reject wajib diisi
   if
      result_approval = 'REJECTED'
      and ( reason_reject is null
      or trim(reason_reject) = '' )
   then
      out_status := 'F';
      out_message := 'Reason Reject wajib diisi';
      return;
   end if;

    -- 2. Ambil data dari tabel pengajuan
   select amount_pengajuan,
          highest_approval
     into
      v_amount_pengajuan,
      v_highest_approval
     from trn_pengajuan_cust
    where id_cust = gen_approval.id_cust;

    -- 3. Hitung nomor urut approval berikutnya
   select nvl(
      max(no_sr),
      0
   ) + 1
     into v_current_no_sr
     from trn_appr_cust
    where id_cust = gen_approval.id_cust;

    -- 4. Insert ke table transaksi approval customer
   insert into trn_appr_cust (
      id_cust,
      no_sr,
      cd_user,
      time_approval,
      result,
      reason_reject
   ) values ( gen_approval.id_cust,
              v_current_no_sr,
              gen_approval.cd_user,
              sysdate,
              result_approval,
              reason_reject );

    -- 5. Update data ke table transaksi pengajuan customer
   if result_approval = 'REJECTED' then
        -- REJECTED: Jika cd_user approval ada yang memberikan keputusan reject
      update trn_pengajuan_cust
         set status = 'REJECTED',
             reason_reject = gen_approval.reason_reject,
             date_updated = sysdate
       where id_cust = gen_approval.id_cust;

   elsif
      cd_user = v_highest_approval
      and result_approval = 'APPROVED'
   then
        -- APPROVED: Jika keputusan approved sampai level yang tertinggi
      update trn_pengajuan_cust
         set status = 'APPROVED',
             date_updated = sysdate
       where id_cust = gen_approval.id_cust;

   else
        -- IN PROGRESS: Jika sudah berjalan approval tapi belum final
      v_next_cd_user := get_next_level_app(
         cd_user,
         v_highest_approval
      );
      update trn_pengajuan_cust
         set status = 'IN PROGRESS',
             cd_user =
                case
                   when v_next_cd_user = ' ' then
                      null
                   else
                      v_next_cd_user
                end,
             date_updated = sysdate
       where id_cust = gen_approval.id_cust;
   end if;

    -- Jika semua berhasil
   out_status := 'T';
   out_message := 'Success Insert Data';
exception
   when no_data_found then
      out_status := 'F';
      out_message := 'Failed Update Data';
   when others then
      out_status := 'F';
      out_message := 'Failed Update Data';
end gen_approval;
/

-- ============================================
-- TEST CASES untuk procedure gen_approval
-- ============================================

-- Test Case 1: Positive case - APPROVED
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => 'gcLwfEbBmk',
      cd_user         => 'USER01',
      result_approval => 'APPROVED',
      reason_reject   => null,
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 1: Positive - APPROVED ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 2: Positive case - REJECTED with reason
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => 'FSDHEbgKZm',
      cd_user         => 'USER02',
      result_approval => 'REJECTED',
      reason_reject   => 'Credit score too low',
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 2: Positive - REJECTED ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 3: Negative case - id_cust kosong
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => null,
      cd_user         => 'USER01',
      result_approval => 'APPROVED',
      reason_reject   => null,
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 3: Negative - id_cust kosong ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 4: Negative case - cd_user kosong
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => 'gcLwfEbBmk',
      cd_user         => null,
      result_approval => 'APPROVED',
      reason_reject   => null,
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 4: Negative - cd_user kosong ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 5: Negative case - result_approval kosong
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => 'gcLwfEbBmk',
      cd_user         => 'USER01',
      result_approval => null,
      reason_reject   => null,
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 5: Negative - result_approval kosong ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 6: Negative case - result_approval tidak sesuai
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => 'gcLwfEbBmk',
      cd_user         => 'USER01',
      result_approval => 'PENDING',
      reason_reject   => null,
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 6: Negative - result_approval tidak sesuai ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 7: Negative case - REJECTED tapi reason_reject kosong
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => 'gcLwfEbBmk',
      cd_user         => 'USER01',
      result_approval => 'REJECTED',
      reason_reject   => null,
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 7: Negative - REJECTED tapi reason kosong ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/

-- Test Case 8: Negative case - id_cust tidak ditemukan
declare
   v_status  varchar2(1);
   v_message varchar2(255);
begin
   gen_approval(
      id_cust         => 'NOTEXIST99',
      cd_user         => 'USER01',
      result_approval => 'APPROVED',
      reason_reject   => null,
      out_status      => v_status,
      out_message     => v_message
   );

   dbms_output.put_line('=== TEST CASE 8: Negative - id_cust tidak ditemukan ===');
   dbms_output.put_line('Status: ' || v_status);
   dbms_output.put_line('Message: ' || v_message);
   dbms_output.put_line('');
end;
/