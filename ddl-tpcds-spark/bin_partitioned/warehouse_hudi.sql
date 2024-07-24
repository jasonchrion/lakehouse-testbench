create database if not exists ${DB};
use ${DB};

drop table if exists warehouse;

create table warehouse
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.warehouse;
