create database if not exists ${DB};
use ${DB};

drop table if exists item;

create table item
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.item
CLUSTER BY i_item_sk
;
