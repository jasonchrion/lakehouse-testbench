create database if not exists ${DB};
use ${DB};

drop table if exists call_center;

create table call_center
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.call_center;
