create database if not exists ${DB};
use ${DB};

drop table if exists part;

create table part
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.part
cluster by p_brand
;
