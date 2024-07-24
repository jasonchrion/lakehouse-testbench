create database if not exists ${DB};
use ${DB};

drop table if exists partsupp;

create table partsupp
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.partsupp
cluster by PS_SUPPKEY
;
