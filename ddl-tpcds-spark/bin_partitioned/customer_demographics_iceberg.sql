create database if not exists ${DB};
use ${DB};

drop table if exists customer_demographics;

create table customer_demographics
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.customer_demographics;
