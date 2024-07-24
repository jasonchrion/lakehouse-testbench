create database if not exists ${DB};
use ${DB};

drop table if exists reason;

create table reason
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.reason;
