#!/bin/bash
# This script will install all development tools required for this project 
# Usage: ./install_env.sh 
set -e
LIST_OF_APPS="wget nano libc6-i386 libc6-x32 curl unzip"

echo "Create bin directory for antlr..."
mkdir $HOME/bin
echo "Done"

echo "Install dev tools wget, git, nano..."
sudo apt update 
sudo apt install $LIST_OF_APPS -y 
echo "Done."

# install java 
echo "Install java 17"
sudo apt install openjdk-17-jdk
java --version
echo "Done."

echo "Cleaning .deb..."
rm -rf jdk-17_linux-x64_bin.deb
echo "Done."

echo "Moving apps antr and mvap code..." 
cp ./sources/antlr-4.9.2-complete.jar ~/bin/
cp ./sources/mvap.zip ~/mvap/
unzip ./sources/mvap.zip -d ~/mvap/
echo "Done."

echo "Add alias to bash profile" 
echo -e "export CLASSPATH=.:~/bin/antlr-4.9.2-complete.jar:~/bin/MVaP.jar:$CLASSPATH" >> ~/.bashrc
echo -e "alias antlr4='java -Xmx500M -cp "~/bin/antlr-4.9.2-complete.jar:$CLASSPATH" org.antlr.v4.Tool'" >> ~/.bashrc
echo -e "alias grun='java -Xmx500M -cp "~/bin/antlr-4.9.2-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'" >> ~/.bashrc
source ~/.bashrc
echo "Done."

echo "Compiling MVAP"
cd ~/mvap/
echo "compilation folder : "
pwd
antlr4 MVaP.g4
javac *.java
jar cfm MVaP.jar META-INF/MANIFEST.MF *.class
echo "Done."




 