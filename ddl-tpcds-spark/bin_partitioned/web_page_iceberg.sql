create database if not exists ${DB};
use ${DB};

drop table if exists web_page;

create table web_page
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.web_page;
