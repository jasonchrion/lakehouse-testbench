create database if not exists ${DB};
use ${DB};

drop table if exists lineitem;

create table lineitem 
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.lineitem
cluster by L_SHIPDATE
;
