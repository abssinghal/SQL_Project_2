-- 1. Create new schema as alumni
create schema alumni;

-- 2. Import all .csv files into MySQL
-- DONE Snapshot attached

-- 3. Run SQL command to see the structure of six tables
use  alumni;
describe  college_a_hs;
describe  college_a_se;
describe college_a_sj;
describe college_b_hs;
describe college_b_se;
describe college_b_sj;

-- 4. Display first 1000 rows of tables (College_A_HS, College_A_SE, College_A_SJ, College_B_HS, College_B_SE, College_B_SJ) with Python.
-- Snapshot attached

-- 5. Import first 1500 rows of tables (College_A_HS, College_A_SE, College_A_SJ, College_B_HS, College_B_SE, College_B_SJ) into MS Excel.
-- snapshot attached

-- 6. Perform data cleaning on table College_A_HS and store cleaned data in view College_A_HS_V, Remove null values.
create view college_a_hs_v as (select * from college_a_hs where  RollNo is not null and
LastUpdate is not null and Name is not null and FatherName is not null and MotherName is not null and Batch is not null and
Degree is not null and PresentStatus is not null and HSDegree is not null and EntranceExam is not null and Institute is not null and
Location is not null );

-- 7. Perform data cleaning on table College_A_SE and store cleaned data in view College_A_SE_V, Remove null values.
create view college_a_se_v as (select * from college_a_se where  rollno is not null and
LastUpdate is not null and Name is not null and FatherName is not null and MotherName is not null and Batch is not null and
Degree is not null and presentstatus is not null and organization is not null and
Location is not null );

-- 8. Perform data cleaning on table College_A_SJ and store cleaned data in view College_A_SJ_V, Remove null values.
create view college_a_sj_v as (select * from college_a_sj where  rollno is not null and
LastUpdate is not null and Name is not null and FatherName is not null and MotherName is not null and Batch is not null and
Degree is not null and presentstatus is not null and organization is not null and
Location is not null );

-- 9. Perform data cleaning on table College_B_HS and store cleaned data in view College_B_HS_V, Remove null values.
create view college_b_hs_v as (select * from college_b_hs where  RollNo is not null and
LastUpdate is not null and Name is not null and FatherName is not null and MotherName is not null and Batch is not null and
Degree is not null and PresentStatus is not null and HSDegree is not null and EntranceExam is not null and Institute is not null and
Location is not null );

-- 10.Perform data cleaning on table College_B_SE and store cleaned data in view College_B_SE_V, Remove null values.
create view college_b_se_v as (select * from college_b_se where  RollNo is not null and
LastUpdate is not null and Name is not null and FatherName is not null and MotherName is not null and Batch is not null and
Degree is not null and PresentStatus is not null and organization is not null and
Location is not null );

-- 11.Perform data cleaning on table College_B_SJ and store cleaned data in view College_B_SJ_V, Remove null values.
create view college_b_sj_v as (select * from college_b_sj where  RollNo is not null and
LastUpdate is not null and Name is not null and FatherName is not null and MotherName is not null and Batch is not null and
Degree is not null and PresentStatus is not null and organization is not null and
Location is not null );

-- 12. Make procedure to use string function/s for converting record of Name, FatherName, MotherName into lower case for views (College_A_HS_V, College_A_SE_V, College_A_SJ_V, College_B_HS_V, College_B_SE_V, College_B_SJ_V) 
-- Procedure
delimiter |
create procedure tolowercase (in TableName varchar(20)) 
begin 
set @sql =concat('select lower(name) as Name ,lower(fathername) as Father_name,lower(mothername)  as Mother_name from ', TableName );
prepare stmt from @sql;
execute stmt;
DEALLOCATE PREPARE stmt;
end |

-- Enter the table name to et lower case data
set @tablename = 'college_a_hs_v';
call tolowercase(@tablename);

set @tablename = 'college_a_se_v';
call tolowercase(@tablename);

set @tablename = 'college_a_sj_v';
call tolowercase(@tablename);

set @tablename = 'college_b_hs_v';
call tolowercase(@tablename);

set @tablename = 'college_b_se_v';
call tolowercase(@tablename);

set @tablename = 'college_b_sj_v';
call tolowercase(@tablename);

-- 13 Import the created views (College_A_HS_V, College_A_SE_V, College_A_SJ_V, College_B_HS_V, College_B_SE_V, 
-- College_B_SJ_V) into MS Excel and make pivot chart for location of Alumni.
-- Snapshots attached

-- 14 Write a query to create procedure get_name_collegeA using the cursor to fetch names of all students from college A.
delimiter |
create procedure  get_name_collegeA (inout collegename text)
begin
declare finished int default 0;
declare getnamedetail varchar(5000) default "";
declare getnames 
cursor for 
select name from college_a_hs_v union 
select name from college_a_se_v union 
select name from college_a_sj_v;
declare continue handler for not found set finished =1;

open getnames;

get_name_collegeA : loop
fetch getnames into getnamedetail;
if finished =1 then leave get_name_collegeA;
end if;
set collegename=concat(getnamedetail," ; ",collegename);
end loop get_name_collegeA;
close getnames;
end |
delimiter ;

set @collegename = "";
call get_name_collegeA(@collegename);
select @collegename;

-- 15 Write a query to create procedure get_name_collegeB using the cursor to fetch names of all students from college B.
delimiter |
create procedure  get_name_collegeB (inout collegename text)
begin
declare finished int default 0;
declare getnamedetail varchar(5000) default "";
declare getnames 
cursor for 
select name from college_b_hs_v union 
select name from college_b_se_v union 
select name from college_b_sj_v;
declare continue handler for not found set finished =1;

open getnames;

get_name_collegeB : loop
fetch getnames into getnamedetail;
if finished =1 then leave get_name_collegeB;
end if;
set collegename=concat(getnamedetail," ; ",collegename);
end loop get_name_collegeB;
close getnames;
end |
delimiter ;

set @collegename = "";
call get_name_collegeB(@collegename);
select @collegename;

-- 16. Calculate the percentage of career choice of College A and College B Alumni
use alumni;
with temptable as( 
select a.* ,'a'  as college from
(select presentstatus from college_a_hs_v union all
select presentstatus from college_a_se_v union all 
select presentstatus from college_a_sj_v) as a
union all
select b.* , 'b' as college from
(select presentstatus from college_b_hs_v union all
select presentstatus from college_b_se_v union all 
select presentstatus from college_b_sj_v) as b) 

select "HigherStudies" PresentStatus,
(select count(*) from temptable where temptable.college='a' and temptable.presentstatus='Higher Studies')/
(select count(*) from temptable where temptable.college='a' )*100 as 'College A Percentage',
(select count(*) from temptable where temptable.college='b' and temptable.presentstatus='Higher Studies')/
(select count(*) from temptable where temptable.college='b' )*100 as 'College B Percentage'

union all

select "Self Employed" PresentStatus,
(select count(*) from temptable where temptable.college='a' and temptable.presentstatus='Self Employed')/
(select count(*) from temptable where temptable.college='a' )*100 as 'College A Percentage',
(select count(*) from temptable where temptable.college='b' and temptable.presentstatus='Self Employed')/
(select count(*) from temptable where temptable.college='b' )*100 as 'College B Percentage'

union all

select "Service Job" PresentStatus,
(select count(*) from temptable where temptable.college='a' and temptable.presentstatus='Service/Job')/
(select count(*) from temptable where temptable.college='a' )*100 as 'College A Percentage',
(select count(*) from temptable where temptable.college='b' and temptable.presentstatus='Service/Job')/
(select count(*) from temptable where temptable.college='b' )*100 as 'College B Percentage';