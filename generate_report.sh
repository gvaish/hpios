#!/bin/sh

export PATH=$PATH:/opt/local/bin
export X_COV_FOLDER=/Users/vgaurav/Library/Developer/Xcode/DerivedData/HighPerformance-fdbbtenbmjbgkqdqxeisaunzkqjg/Build/Intermediates/HighPerformance.build/Debug-iphonesimulator/HighPerformance.build
#echo ${CLANG_ANALYZER_OUTPUT_DIR} > /tmp/hpts.txt
#echo ${X_COV_FOLDER} >> /tmp/hpts.txt
#echo ${PROJECT} >> /tmp/hpts.txt
#echo $PATH >> /tmp/hpts.txt
#which lcov >> /tmp/hpts.txt 2>&1
#set >> /tmp/hpts.txt

lcov --directory "${X_COV_FOLDER}/Objects-normal/x86_64/" --capture --output-file /tmp/${PROJECT}.info
genhtml --output-directory /tmp/${PROJECT}-reports/ /tmp/${PROJECT}.info
open /tmp/${PROJECT}-reports/index.html

