-- ============================================
-- TASK 3: Create table transaksi pengajuan customer
-- ============================================

-- Create table transaksi pengajuan customer
create table trn_pengajuan_cust (
   id_cust          varchar2(10) primary key,  -- auto generate number 10 digit
   nama             varchar2(100) not null,
   amount_pengajuan number not null,
   status           varchar2(20) not null,     -- WAITING, IN PROGRESS, APPROVED, REJECTED
   highest_approval varchar2(10),              -- level approval tertinggi
   cd_user          varchar2(10),              -- id user bucket approval saat ini
   reason_reject    varchar2(255),             -- alasan reject
   date_updated     date                       -- date time action
);

-- Insert sample data sesuai requirement
insert into trn_pengajuan_cust values ( 'gcLwfEbBmk',
                                        'Awa',
                                        4500000,
                                        'WAITING',
                                        'USER01',
                                        null,
                                        null,
                                        to_date('01-Mar-2025 10:02:22','DD-Mon-YYYY HH24:MI:SS') );

insert into trn_pengajuan_cust values ( 'FSDHEbgKZm',
                                        'Vina',
                                        70000000,
                                        'IN PROGRESS',
                                        'USER01',
                                        'USER02',
                                        null,
                                        to_date('01-Mar-2025 10:02:22','DD-Mon-YYYY HH24:MI:SS') );

insert into trn_pengajuan_cust values ( 'LirplNBJJM',
                                        'Doni',
                                        30000000,
                                        'REJECTED',
                                        'USER01',
                                        null,
                                        'bad customer',
                                        to_date('01-Mar-2025 10:02:22','DD-Mon-YYYY HH24:MI:SS') );

commit;

-- Verifikasi data
select *
  from trn_pengajuan_cust;