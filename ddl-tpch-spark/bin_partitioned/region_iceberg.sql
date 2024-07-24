create database if not exists ${DB};
use ${DB};

drop table if exists region;

create table region
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select distinct * from ${SOURCE}.region;
