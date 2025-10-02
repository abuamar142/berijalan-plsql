-- ============================================
-- TASK 4: Create table transaksi approval customer
-- ============================================

-- Create table transaksi approval customer
create table trn_appr_cust (
   id_cust       varchar2(10) not null,      -- auto generate number 10 digit
   no_sr         number(2) not null,         -- nomor urut approval, setiap transaksi +1
   cd_user       varchar2(10) not null,      -- user yang melakukan approval
   time_approval date default sysdate,       -- date time action
   result        varchar2(20) not null,      -- keputusan approval (APPROVED/REJECTED)
   reason_reject varchar2(1000),             -- alasan reject
   primary key ( id_cust,
                 no_sr ),
   check ( result in ( 'APPROVED',
                       'REJECTED' ) )
);

-- Insert sample data sesuai requirement
insert into trn_appr_cust values ( 'FSDHEbgKZm',
                                   1,
                                   'USER01',
                                   to_date('04-Mar-2025 21:00','DD-Mon-YYYY HH24:MI'),
                                   'APPROVED',
                                   null );

insert into trn_appr_cust values ( 'FSDHEbgKZm',
                                   2,
                                   'USER02',
                                   to_date('05-Mar-2025 21:00','DD-Mon-YYYY HH24:MI'),
                                   'APPROVED',
                                   null );

insert into trn_appr_cust values ( 'FSDHEbgKZm',
                                   3,
                                   'USER03',
                                   to_date('05-Mar-2025 22:00','DD-Mon-YYYY HH24:MI'),
                                   'REJECTED',
                                   'bad customer' );

insert into trn_appr_cust values ( 'LirplNBJJM',
                                   1,
                                   'USER01',
                                   to_date('04-Mar-2025 21:00','DD-Mon-YYYY HH24:MI'),
                                   'APPROVED',
                                   null );

insert into trn_appr_cust values ( 'LirplNBJJM',
                                   2,
                                   'USER02',
                                   to_date('05-Mar-2025 21:00','DD-Mon-YYYY HH24:MI'),
                                   'REJECTED',
                                   'history jelek' );

commit;

-- Verifikasi data
select *
  from trn_appr_cust
 order by id_cust,
          no_sr;