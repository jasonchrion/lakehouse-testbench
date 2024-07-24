create database if not exists ${DB};
use ${DB};

drop table if exists nation;

create table nation
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select distinct * from ${SOURCE}.nation;
