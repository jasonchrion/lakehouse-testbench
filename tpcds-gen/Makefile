
all: target/lib/dsdgen.jar target/tpcds-gen-1.0.jar

target/tpcds-gen-1.0.jar: $(shell find -name *.java) 
	mvn package

target/tpcds_kit.zip:
	mkdir -p target/
	cp tpcds_kit.zip target/tpcds_kit.zip

target/lib/dsdgen.jar: target/tools/dsdgen
	cd target/; mkdir -p lib/; ( jar cvf lib/dsdgen.jar tools/ || gjar cvf lib/dsdgen.jar tools/ )

target/tools/dsdgen: target/tpcds_kit.zip
	test -d target/tools/ || (cd target; unzip tpcds_kit.zip)
	test -d target/tools/ || (cd target; mv */tools tools)
	cd target/tools; cat ../../patches/all/*.patch | patch -p0
	cd target/tools; cat ../../patches/${MYOS}/*.patch | patch -p1
	cd target/tools; make clean; make dsdgen

clean:
	mvn clean
