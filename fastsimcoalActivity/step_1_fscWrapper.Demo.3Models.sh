############### This script is meant to help you run fastsimcoal analyses on a simulated SFS ##########
## script by: Annabel Beichman <annabel.beichman@gmail.com> ##
# script would need to be modified for your own particular dataset (sample size, mutation rate, demographic models)
# before running you must supply the paths to fastsimcoal and to your working directory which contains the test scripts and sfs
# you can copy + paste chunks of code into the command line or you can run the whole script using source step_1_fscWrapper.Demo.3Models.sh in the command line
# Directory Structure:
# wd
# |-- step0, step1, step2 # scripts to run fastsimcoal analysis
# |--SFS/generic.SFSForDemographyWorkshop_MAFpop0.obs # directory with sfs in it
# |--modelFiles/ # directory with 1Epoch, 2 Epoch and 3Epoch .tpl and .est files

########## Set your analysis parameters ###################
# In "real life" you should do 50 replicates, with 40 ECM cycles (-L 40) and 100,000 coalescent trees (-n 100000)
# For now we are going to use 10 replicates, 50,000 coalescent trees and 20 ECM cycles <-- but if you are doing this for real UPDATE THOSE FLAGS! 
numReps=10 # number of replicates. should be 50+ if you're doing this for real
numCoalTrees=50000 # number of coalescent trees. should be 100000+ if you're doing this for real
numECM=20 # number of ECM optimization cycles. should be 40+ if you're doing this for real
cores=4 # number of cores parallelize

################### Set your paths #################################################
fsc=/path/to/fsc26 # <-- YOU MUST UPDATE THIS PATH: provide path to where you installed fsc26
#fsc=/Applications/fsc26_mac64/fsc26 #example on my home computer 
#fsc=~/bin/fsc26 # example on my hoffman

wd=/path/to/working/directory #  <-- YOU MUST UPDATE THIS PATH to your fastsimcoalActivity directory that contains the SFS and all the tpl and est files
#wd=/Users/annabelbeichman/Documents/UCLA/DemographyWorkshop/ActivityMaterials/fastsimcoalActivity # example on my computer
#wd=$SCRATCH/DemographyWorkshop/ActivityMaterials/fastsimcoalActivity/ # example on my hoffman 

####### provide SFS filename:
sfs=generic.SFSForDemographyWorkshop_MAFpop0.obs #  name of SFS 

###################### Carry out analysis ##################
# note: you could loop over all your models, but I've kept them modular here to keep things step-by-step
############ 1 Epoch Model #############
model=1D.1Epoch
modelDir=$wd/fscResults-10/$model 
mkdir -p $modelDir # make the directory for your model inference


for i in $(seq 1 $numReps) # this will iterate over your numReps replicates (e.g. 10)
do

mkdir -p $modelDir/run_${i} # make a directory for each replicate
cd $modelDir/run_${i} # you have to physically be in the inference directory (annoying) 
/bin/cp $wd/SFS/$sfs $modelDir/run_${i}/${model}_MAFpop0.obs # your SFS needs to be in the inference directory and needs to have the same name as your model files (annoying, I know!)
/bin/cp $wd/modelFiles/${model}.tpl $wd/modelFiles/${model}.est $modelDir/run_${i} # copy your model files into the run's directories
$fsc -t ${model}.tpl -n ${numCoalTrees} -m -e ${model}.est -M -L ${numECM} -c${cores} -q # run fastsimcoal with 100,000 coalescent trees and 40 ecm cycles
done

############ 2 Epoch Model #############
model=1D.2Epoch
modelDir=$wd/fscResults-10/$model 
mkdir -p $modelDir # make the directory for your model inference


for i in $(seq 1 $numReps) # this will iterate over your numReps replicates (e.g. 10)
do

mkdir -p $modelDir/run_${i} # make a directory for each replicate
cd $modelDir/run_${i} # you have to physically be in the inference directory (annoying) 
/bin/cp $wd/SFS/$sfs $modelDir/run_${i}/${model}_MAFpop0.obs # your SFS needs to be in the inference directory and needs to have the same name as your model files (annoying, I know!)
/bin/cp $wd/modelFiles/${model}.tpl $wd/modelFiles/${model}.est $modelDir/run_${i} # copy your model files into the run's directories
$fsc -t ${model}.tpl -n ${numCoalTrees} -m -e ${model}.est -M -L ${numECM} -c${cores} -q # run fastsimcoal with 100,000 coalescent trees and 40 ecm cycles
done



############ 3 Epoch Model #############
model=1D.3Epoch
modelDir=$wd/fscResults-10/$model 
mkdir -p $modelDir # make the directory for your model inference

for i in $(seq 1 $numReps) # this will iterate over your numReps replicates (e.g. 10)
do

mkdir -p $modelDir/run_${i} # make a directory for each replicate
cd $modelDir/run_${i} # you have to physically be in the inference directory (annoying) 
/bin/cp $wd/SFS/$sfs $modelDir/run_${i}/${model}_MAFpop0.obs # your SFS needs to be in the inference directory and needs to have the same name as your model files (annoying, I know!)
/bin/cp $wd/modelFiles/${model}.tpl $wd/modelFiles/${model}.est $modelDir/run_${i} # copy your model files into the run's directories
$fsc -t ${model}.tpl -n ${numCoalTrees} -m -e ${model}.est -M -L ${numECM} -c${cores} -q # run fastsimcoal with 100,000 coalescent trees and 40 ecm cycles
done
