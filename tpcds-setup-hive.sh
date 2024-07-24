#!/bin/bash

function usage {
  echo "Usage: tpcds-setup.sh scale_factor [temp_directory]"
  exit 1
}

function runcommand {
  if [ "X$DEBUG_SCRIPT" != "X" ]; then
    $1
  else
    $1 2>/dev/null
  fi
}

PRG="$0"
PRGDIR=`dirname "$PRG"`

cd $PRGDIR
TESTBENCH_HOME=`pwd`
export TESTBENCH_HOME

if [ ! -f ${TESTBENCH_HOME}/tpcds-gen/target/tpcds-gen-1.0.jar ]; then
  echo "Please build the data generator with ./tpcds-build.sh first"
  exit 1
fi

# Tables in the TPC-DS schema.
DIMS="date_dim time_dim item customer customer_demographics household_demographics customer_address store promotion warehouse ship_mode reason income_band call_center web_page catalog_page web_site"
FACTS="store_sales store_returns web_sales web_returns catalog_sales catalog_returns inventory"

# Get the parameters.
SCALE=$1
DIR=$2
BUCKETS=13
if [ "X$DEBUG_SCRIPT" != "X" ]; then
  set -x
fi

# Sanity checking.
if [ X"$SCALE" = "X" ]; then
  usage
fi
if [ X"$DIR" = "X" ]; then
  DIR=/tmp/tpcds-generate
fi
if [ $SCALE -eq 1 ]; then
  echo "Scale factor must be greater than 1"
  exit 1
fi

# Do the actual data load.
hdfs dfs -mkdir -p ${DIR}
hdfs dfs -ls ${DIR}/${SCALE} > /dev/null
if [ $? -ne 0 ]; then
  echo "Generating data at scale factor $SCALE."
  (cd ${TESTBENCH_HOME}/tpcds-gen; hadoop jar target/*.jar -d ${DIR}/${SCALE}/ -s ${SCALE})
fi
hdfs dfs -ls ${DIR}/${SCALE} > /dev/null
if [ $? -ne 0 ]; then
  echo "Data generation failed, exiting."
  exit 1
fi

hadoop fs -chmod -R 777  ${DIR}/${SCALE}

echo "TPC-DS text data generation complete."

#ENGINE="/opt/hive/bin/beeline -n root -u 'jdbc:hive2://localhost:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2?tez.queue.name=default' "
ENGINE="/opt/hive/bin/beeline -n root -u 'jdbc:hive2://localhost:10000?tez.queue.name=default' "

# Create the text/flat tables as external tables. These will be later be converted to ORCFile.
echo "Loading text data into external tables."
runcommand "$ENGINE  -i ${TESTBENCH_HOME}/settings/load-flat.sql -f ${TESTBENCH_HOME}/ddl-tpcds-hive/text/alltables.sql --hivevar DB=tpcds_text_${SCALE} --hivevar LOCATION=${DIR}/${SCALE}"

# Create the optimized tables.
if [ "X$FORMAT" = "X" ]; then
  FORMAT=orc
fi

LOAD_FILE="load_${FORMAT}_${SCALE}.mk"
SILENCE="2> /dev/null 1> /dev/null" 
if [ "X$DEBUG_SCRIPT" != "X" ]; then
  SILENCE=""
fi

echo -e "all: ${DIMS} ${FACTS}" > $LOAD_FILE

i=1
total=24
DATABASE=tpcds_${FORMAT}_${SCALE}
MAX_REDUCERS=2500 # maximum number of useful reducers for any scale 
REDUCERS=$((test ${SCALE} -gt ${MAX_REDUCERS} && echo ${MAX_REDUCERS}) || echo ${SCALE})

# Populate the smaller tables.
for t in ${DIMS}
do
  tbl=$t;
  if [ "X$ICEBERG" != "X" ]; then
    tbl=$t"_iceberg"
  fi
  COMMAND="$ENGINE -i ${TESTBENCH_HOME}/settings/load-partitioned.sql -f ${TESTBENCH_HOME}/ddl-tpcds-hive/bin_partitioned/${tbl}.sql \
    --hivevar DB=${DATABASE} \
    --hivevar SOURCE=tpcds_text_${SCALE} \
    --hivevar SCALE=${SCALE} \
    --hivevar REDUCERS=${REDUCERS} \
    --hivevar FILE=${FORMAT}"
  echo -e "${t}:\n\t@$COMMAND $SILENCE && echo 'Optimizing table $t ($i/$total).'" >> $LOAD_FILE
  i=`expr $i + 1`
done

for t in ${FACTS}
do
  tbl=$t;
  if [ "X$ICEBERG" != "X" ]; then
    tbl=$t"_iceberg"
  fi
  COMMAND="$ENGINE -i ${TESTBENCH_HOME}/settings/load-partitioned.sql -f ${TESTBENCH_HOME}/ddl-tpcds-hive/bin_partitioned/${tbl}.sql \
      --hivevar DB=${DATABASE} \
      --hivevar SCALE=${SCALE} \
      --hivevar SOURCE=tpcds_text_${SCALE} \
      --hivevar BUCKETS=${BUCKETS} \
      --hivevar REDUCERS=${REDUCERS} \
      --hivevar FILE=${FORMAT}"
  echo -e "${t}:\n\t@$COMMAND $SILENCE && echo 'Optimizing table $t ($i/$total).'" >> $LOAD_FILE
  i=`expr $i + 1`
done

make -j 1 -f $LOAD_FILE

echo "Loading constraints"
runcommand "$ENGINE -f ${TESTBENCH_HOME}/ddl-tpcds-hive/bin_partitioned/add_constraints.sql --hivevar DB=${DATABASE}"

echo "Analyzing table"
runcommand "$ENGINE -f ${TESTBENCH_HOME}/ddl-tpcds-hive/bin_partitioned/analyze.sql --hivevar DB=${DATABASE} --hivevar REDUCERS=${REDUCERS}"

echo "Data loaded into database ${DATABASE}."
