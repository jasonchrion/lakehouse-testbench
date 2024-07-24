create database if not exists ${DB};
use ${DB};

drop table if exists web_page;

create table web_page
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.web_page;
