#!/bin/bash
set -e
echo "Installing formatter."
git clone https://github.com/antlr/Antlr4Formatter.git ~/antlr_formatter
cd ~/antlr_formatter/ && ./mvnw clean package
echo "Done."

read -p "Add formater Alias in .bashrc (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        echo "Adding alias ..."
        echo -e "alias format='() {java -jar ~/antlr_formatter/antlr4-formatter-standalone/target/antlr4-formatter-standalone-1.2.2-SNAPSHOT.jar --input="$1" ;}'" >> ~/.bashrc
        chmod +x ~/antlr_formatter/formatFile.sh
        source ~/.bashrc
        echo "Done."
    ;;
    * )
        echo No
    ;;
esac
echo "Exiting ..."
