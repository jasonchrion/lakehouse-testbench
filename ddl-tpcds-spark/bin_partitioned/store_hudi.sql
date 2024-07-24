create database if not exists ${DB};
use ${DB};

drop table if exists store;

create table store
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.store
CLUSTER BY s_store_sk
;
