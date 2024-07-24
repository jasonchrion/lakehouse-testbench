create database if not exists ${DB};
use ${DB};

drop table if exists catalog_page;

create table catalog_page
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.catalog_page;
