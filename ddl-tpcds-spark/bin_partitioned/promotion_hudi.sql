create database if not exists ${DB};
use ${DB};

drop table if exists promotion;

create table promotion
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.promotion;
