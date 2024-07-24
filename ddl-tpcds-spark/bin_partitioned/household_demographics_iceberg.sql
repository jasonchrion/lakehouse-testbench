create database if not exists ${DB};
use ${DB};

drop table if exists household_demographics;

create table household_demographics
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.household_demographics;
