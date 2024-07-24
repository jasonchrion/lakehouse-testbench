create database if not exists ${DB};
use ${DB};

drop table if exists customer_address;

create table customer_address
using hudi
tblproperties(
 hoodie.table.base.file.format='${FILE}'
)
as select * from ${SOURCE}.customer_address 
CLUSTER BY ca_address_sk
;
