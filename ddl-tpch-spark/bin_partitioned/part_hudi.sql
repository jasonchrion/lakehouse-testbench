create database if not exists ${DB};
use ${DB};

drop table if exists part;

create table part
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.part
cluster by p_brand
;
