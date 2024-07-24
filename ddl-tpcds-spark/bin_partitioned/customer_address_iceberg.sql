create database if not exists ${DB};
use ${DB};

drop table if exists customer_address;

create table customer_address
using iceberg
tblproperties(
 'write.format.default'='${FILE}'
)
as select * from ${SOURCE}.customer_address 
CLUSTER BY ca_address_sk
;
