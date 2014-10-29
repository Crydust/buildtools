@ECHO OFF

mkdir ivy

IF NOT EXIST %~dp0.\ivy\ivy-2.4.0-rc1.jar (
bitsadmin /Transfer myDownloadJob /download /priority normal https://repo.maven.apache.org/maven2/org/apache/ivy/ivy/2.4.0-rc1/ivy-2.4.0-rc1.jar %~dp0.\ivy\ivy-2.4.0-rc1.jar
)

ant -lib ivy/ivy-2.4.0-rc1.jar %*
