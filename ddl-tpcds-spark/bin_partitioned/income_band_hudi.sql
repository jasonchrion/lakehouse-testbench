create database if not exists ${DB};
use ${DB};

drop table if exists income_band;

create table income_band
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.income_band;
