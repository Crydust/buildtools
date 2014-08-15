#!/bin/sh

echo '* initialize'
# initialize build state, set properties

artifactId=greeter
version=1.0-SNAPSHOT
entryPoint=be.crydust.greeter.App

buildDirectory=target
outputDirectory=target/classes
finalName=${artifactId}-${version}
testOutputDirectory=target/test-classes
sourceDirectory=src/main/java
testSourceDirectory=src/test/java
resources=src/main/resources
testResources=src/test/resources

sourceEncoding=UTF-8
reportEncoding=UTF-8
source=1.8
target=1.8

compileClasspath=lib/slf4j-api-1.7.7.jar
runtimeClasspath=lib/logback-classic-1.1.2.jar:lib/logback-core-1.1.2.jar
testClasspath=lib/junit-4.11.jar:lib/hamcrest-core-1.3.jar

echo '* clean'
# remove files generated at build-time
rm -rf ${buildDirectory}

echo '* download dependencies'
# download files if not present and keep them outside the target directory for caching
mkdir -p lib
cd lib
[ ! -f slf4j-api-1.7.7.jar ]       && curl -O http://central.maven.org/maven2/org/slf4j/slf4j-api/1.7.7/slf4j-api-1.7.7.jar
[ ! -f logback-classic-1.1.2.jar ] && curl -O http://central.maven.org/maven2/ch/qos/logback/logback-classic/1.1.2/logback-classic-1.1.2.jar
[ ! -f logback-core-1.1.2.jar ]    && curl -O http://central.maven.org/maven2/ch/qos/logback/logback-core/1.1.2/logback-core-1.1.2.jar
[ ! -f junit-4.11.jar ]            && curl -O http://central.maven.org/maven2/junit/junit/4.11/junit-4.11.jar
[ ! -f hamcrest-core-1.3.jar ]     && curl -O http://central.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
cd ..

echo '* process-resources'
# copy and process the resources into the destination directory, ready for packaging.
mkdir -p ${outputDirectory}
cp -R ${resources}/* ${outputDirectory}

echo '* compile'
# compile the source code of the project
find ${sourceDirectory} -name '*.java' -exec javac -g -deprecation -cp ${compileClasspath} -sourcepath ${sourceDirectory} -d ${outputDirectory} -encoding ${sourceEncoding} -source ${source} -target ${target} {} \;

echo '* process-test-resources'
# copy and process the resources into the test destination directory
mkdir -p ${testOutputDirectory}
cp -R ${testResources}/* ${testOutputDirectory}

echo '* test-compile'
# compile the test source code into the test destination directory
find ${testSourceDirectory} -name '*.java' -exec javac -g -deprecation -cp ${outputDirectory}:${testClasspath}:${compileClasspath} -sourcepath ${testSourceDirectory} -d ${testOutputDirectory} -encoding ${sourceEncoding} -source ${source} -target ${target} {} \;

echo '* test'
# run tests using a suitable unit testing framework. These tests should not require the code be packaged or deployed.
java -cp ${testOutputDirectory}:${outputDirectory}:${testClasspath}:${compileClasspath}:${runtimeClasspath} org.junit.runner.JUnitCore be.crydust.greeter.GreeterTest

echo '* prepare-package'
# perform any operations necessary to prepare a package before the actual packaging

echo '* copy-dependencies'
mkdir -p ${buildDirectory}/lib
cp lib/slf4j-api-1.7.7.jar lib/logback-classic-1.1.2.jar lib/logback-core-1.1.2.jar ${buildDirectory}/lib

echo '* javadoc'
javadoc -cp ${compileClasspath} -sourcepath ${sourceDirectory} -d ${buildDirectory}/apidocs -encoding ${sourceEncoding} -charset ${reportEncoding} -docencoding ${reportEncoding} -use -windowtitle 'greeter 1.0-SNAPSHOT API' -bottom 'Copyright &#169; 2014. All rights reserved.' be.crydust.greeter

echo '* package'
# take the compiled code and package it in its distributable format
echo 'Class-Path: lib/slf4j-api-1.7.7.jar lib/logback-classic-1.1.2.jar lib/logback-core-1.1.2.jar' > ${buildDirectory}/manifest
jar cfme ${buildDirectory}/${finalName}.jar ${buildDirectory}/manifest ${entryPoint} -C ${outputDirectory} .
jar cf ${buildDirectory}/${finalName}-sources.jar -C ${sourceDirectory} . -C ${resources} .
jar cf ${buildDirectory}/${finalName}-javadoc.jar -C ${buildDirectory}/apidocs . -C ${resources} .

cd ${buildDirectory}
zip ${finalName}-distribution.zip *.jar lib/*
cd ..
zip ${buildDirectory}/${finalName}-distribution.zip LICENSE.txt NOTICE.txt README.txt

echo '* run'
java -jar ${buildDirectory}/${finalName}.jar

# DEBUG code
#echo '* tree'
#tree --dirsfirst -F
#echo '* jar'
#jar tf ${buildDirectory}/${finalName}.jar
#echo '* sources jar'
#jar tf ${buildDirectory}/${finalName}-sources.jar
#echo '* distribution'
#zipinfo ${buildDirectory}/${finalName}-distribution.zip

