create database if not exists ${DB};
use ${DB};

drop table if exists inventory;

create table inventory
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.inventory
CLUSTER BY inv_date_sk
;
