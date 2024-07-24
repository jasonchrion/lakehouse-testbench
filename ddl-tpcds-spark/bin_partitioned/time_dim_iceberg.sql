create database if not exists ${DB};
use ${DB};

drop table if exists time_dim;

create table time_dim
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.time_dim;
