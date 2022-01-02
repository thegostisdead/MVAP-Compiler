#!/bin/bash
set -e
source ~/.bashrc
echo "Start compiling"
antlr4 calculette.g4
javac calculette*.java
echo "Compile done."
echo "Start grun"
grun calculette 'calcul' -gui
