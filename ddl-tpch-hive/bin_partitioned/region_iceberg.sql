create database if not exists ${DB};
use ${DB};

drop table if exists region;

create table region
stored by iceberg
stored as ${FILE}
tblproperties (
 'format-version'='2'
)
as select distinct * from ${SOURCE}.region;
