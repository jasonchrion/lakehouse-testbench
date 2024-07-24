create database if not exists ${DB};
use ${DB};

drop table if exists nation;

create table nation
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select distinct * from ${SOURCE}.nation;
