-- ============================================
-- TASK 1: Create table master approval
-- ============================================

-- Create table master approval
create table mst_approval (
   no      number(2) primary key,
   min     number(12,2) not null,
   max     number(12,2) not null,
   cd_user varchar2(10) not null
);

-- Insert data master approval
insert into mst_approval values ( 1,
                                  1,
                                  5000000,
                                  'USER01' );
insert into mst_approval values ( 2,
                                  5000001,
                                  15000000,
                                  'USER02' );
insert into mst_approval values ( 3,
                                  15000001,
                                  50000000,
                                  'USER03' );
insert into mst_approval values ( 4,
                                  50000001,
                                  100000000,
                                  'USER04' );
insert into mst_approval values ( 5,
                                  100000001,
                                  500000000,
                                  'USER05' );

commit;

-- Verifikasi data
select *
  from mst_approval
 order by no;

drop table mst_approval;