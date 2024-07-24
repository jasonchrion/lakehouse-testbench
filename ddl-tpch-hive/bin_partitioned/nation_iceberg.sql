create database if not exists ${DB};
use ${DB};

drop table if exists nation;

create table nation
stored by iceberg
stored as ${FILE}
tblproperties (
 'format-version'='2'
)
as select distinct * from ${SOURCE}.nation;
