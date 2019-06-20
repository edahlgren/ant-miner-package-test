#!/bin/bash

# Get system dependencies
apt-get update
apt-get install -y wget git make openjdk-8-jdk

# Get the ant miner code
mkdir /home/src && cd /home/src
git clone https://github.com/febo/myra.git

# Build the ant miner code
cd myra
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
make

# Link the jar for ease of use
mkdir /home/bin
ln /home/src/myra/target/myra-4.6.jar /home/bin/myra-4.6.jar

# Get the test data
mkdir /home/data && cd /home/data
wget https://storm.cis.fordham.edu/~gweiss/data-mining/weka-data/iris.arff
wget https://storm.cis.fordham.edu/~gweiss/data-mining/weka-data/diabetes.arff
wget https://raw.githubusercontent.com/renatopp/arff-datasets/master/classification/car.arff
wget https://raw.githubusercontent.com/renatopp/arff-datasets/master/classification/zoo.arff

# Fixup the test data
sed -i 's/INTEGER\ \[0,9\]/REAL/' /home/data/zoo.arff
sed -i 's/ATTRIBUTE\ type/ATTRIBUTE\ class/' /home/data/zoo.arff

# Create scripts for running the different miners
echo 'java -cp /home/bin/myra-4.6.jar myra.classification.rule.impl.AntMiner "$@"' >> /home/AntMiner.sh
chmod 755 /home/AntMiner.sh

echo 'java -cp /home/bin/myra-4.6.jar myra.regression.rule.impl.AntMinerReg "$@"' >> /home/AntMinerReg.sh
chmod 755 /home/AntMinerReg.sh

echo 'java -cp /home/bin/myra-4.6.jar myra.classification.tree.AntTreeMiner "$@"' >> /home/AntTreeMiner.sh
chmod 755 /home/AntTreeMiner.sh

echo 'java -cp /home/bin/myra-4.6.jar myra.classification.rule.impl.UcAntMinerPB "$@"' >> /home/UcAntMinerPB.sh
chmod 755 /home/UcAntMinerPB.sh

echo 'java -cp /home/bin/myra-4.6.jar myra.classification.rule.impl.cAntMiner "$@"' >> /home/cAntMiner.sh
chmod 755 /home/cAntMiner.sh

echo 'java -cp /home/bin/myra-4.6.jar myra.classification.rule.impl.cAntMinerPB "$@"' >> /home/cAntMinerPB.sh
chmod 755 /home/cAntMinerPB.sh
