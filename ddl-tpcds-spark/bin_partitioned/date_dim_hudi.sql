create database if not exists ${DB};
use ${DB};

drop table if exists date_dim;

create table date_dim
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.date_dim;
