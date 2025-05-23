create database if not exists ${DB};
use ${DB};

drop table if exists household_demographics;

create table household_demographics
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.household_demographics;
