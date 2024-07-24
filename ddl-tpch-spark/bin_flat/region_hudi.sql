create database if not exists ${DB};
use ${DB};

drop table if exists region;

create table region
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select distinct * from ${SOURCE}.region;
