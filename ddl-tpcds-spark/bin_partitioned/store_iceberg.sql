create database if not exists ${DB};
use ${DB};

drop table if exists store;

create table store
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.store
CLUSTER BY s_store_sk
;
