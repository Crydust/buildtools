#!/bin/sh

mkdir -p ivy
cd ivy
[ ! -f ivy-2.4.0-rc1.jar ] && curl -O https://repo.maven.apache.org/maven2/org/apache/ivy/ivy/2.4.0-rc1/ivy-2.4.0-rc1.jar
cd ..

ant -lib ivy/ivy-2.4.0-rc1.jar $*
