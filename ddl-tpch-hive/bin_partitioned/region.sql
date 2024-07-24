create database if not exists ${DB};
use ${DB};

drop table if exists region;

create table region
stored as ${FILE}
tblproperties(
 'orc.bloom.filter.columns'='*',
 'orc.compress'='ZLIB'
)
as select distinct * from ${SOURCE}.region;
