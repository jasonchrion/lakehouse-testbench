create database if not exists ${DB};
use ${DB};

drop table if exists time_dim;

create table time_dim
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.time_dim;
