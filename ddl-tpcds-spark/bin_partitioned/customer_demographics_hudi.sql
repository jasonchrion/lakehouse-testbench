create database if not exists ${DB};
use ${DB};

drop table if exists customer_demographics;

create table customer_demographics
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.customer_demographics;
