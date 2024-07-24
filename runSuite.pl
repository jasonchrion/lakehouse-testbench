#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

# PROTOTYPES
sub dieWithUsage(;$);

# GLOBALS
my $SCRIPT_NAME = basename( __FILE__ );
my $SCRIPT_PATH = dirname( __FILE__ );

# MAIN
dieWithUsage("one or more parameters not defined") unless @ARGV >= 3;
my $suite = shift;
my $scale = shift || 2;
my $format = shift || 3;
dieWithUsage("suite name required") unless $suite eq "tpcds" or $suite eq "tpch";

chdir $SCRIPT_PATH;
if( $suite eq 'tpcds' ) {
  chdir "sample-queries-tpcds";
} else {
  chdir 'sample-queries-tpch';
} # end if
my @queries = glob '*.sql';

my $db = "${suite}_${format}_${scale}";
if( $suite eq 'tpch' ) {
  if( $scale <= 1000 ) {
    $db = "${suite}_${format}_${scale}_flat";
  } else {
    $db = "${suite}_${format}_${scale}_partitioned";
  }
}

#my $engine = "trino --server http://trino:8080 --catalog hive --schema ${db} --ignore-errors --progress --debug ";
#my $engine = "/opt/kyuubi/bin/beeline -n root -u 'jdbc:hive2://kyuubi-thrift-binary:10009/${db}' ";
#my $engine = "beeline -n root -u 'jdbc:hive2://hive-zookeeper:2181/${db};serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2?tez.queue.name=default' ";
my $engine = "beeline -n root -u 'jdbc:hive2://localhost:10000/${db}?tez.queue.name=default' ";

print "filename,status,time,rows\n";
for my $query ( @queries ) {
  my $logname = "$query.log";
  my $cmd="$engine -f $query 2>&1 | tee $query.log";
  my $hiveStart = time();

  my @hiveoutput=`$cmd`;
  die "${SCRIPT_NAME}:: ERROR:  hive command unexpectedly exited \$? = '$?', \$! = '$!'" if $?;

  my $hiveEnd = time();
  my $hiveTime = $hiveEnd - $hiveStart;
  print "$query,completed,$hiveTime\n";
  #foreach my $line ( @hiveoutput ) {
  #  #if( $line =~ /Time taken:\s+([\d\.]+)\s+seconds,\s+Fetched:\s+(\d+)\s+row/ ) {
  #  if( $line =~ /([\d|No]+)\s+row[s]?\s+selected\s+\(([\d\.]+)\s+seconds\)/ ) {
  #    print "$query,success,$hiveTime,$1\n";
  #  } elsif(
  #    $line =~ /^FAILED: /
  #    # || /Task failed!/
  #    ) {
  #    print "$query,failed,$hiveTime\n";
  #  } # end if
  #} # end foreach
} # end for

sub dieWithUsage(;$) {
  my $err = shift || '';
  if( $err ne '' ) {
    chomp $err;
    $err = "ERROR: $err\n\n";
  } # end if

  print STDERR <<USAGE;
${err}Usage:
  perl ${SCRIPT_NAME} [tpcds|tpch] [scale] [format]

Description:
  This script runs the sample queries and outputs a CSV file of the time it took each query to run.  Also, all hive output is kept as a log file named 'queryXX.sql.log' for each query file of the form 'queryXX.sql'. Defaults to scale of 2.
USAGE
  exit 1;
}

