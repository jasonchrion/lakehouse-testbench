create database if not exists ${DB};
use ${DB};

drop table if exists ship_mode;

create table ship_mode
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.ship_mode;
