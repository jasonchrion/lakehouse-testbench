create database if not exists ${DB};
use ${DB};

drop table if exists web_site;

create table web_site
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.web_site;
