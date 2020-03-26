#! /bin/bash
#$ -cwd
#$ -l h_rt=24:00:00,h_data=8G
#$ -N dadi_inference
#$ -o [/path/to/reports/]
#$ -e [/path/to/reports/]
#$ -m abe
#$ -M [your username]


######################### set up virtual environment (once) #####################
# if using on Hoffman, have to use virtual environment:
# you can set up the virtual env by doing:
# module load python/2.7.13_shared
# virtualenv $HOME/env_python2.7.13 # once
# then activate it every future time with  source $HOME/env_python2.7.13/bin/activate
# make sure you pip install numpy scipy matplotlib 
# and then you can deactivate

############# update these paths for your set up #####################
source /u/local/Modules/default/init/modules.sh
module load python/2.7.13_shared
source $HOME/env_python2.7.13/bin/activate # activate virtual environment that you made according to instructions above. May need to replace $HOME with path to your home dir
scriptdir= # location of your dadi .py scripts
scripts='1D.1Epoch.dadi.py 1D.2Epoch.dadi.py' # list of scripts you want to do inference with 

mu= # set mutation rate
# get total sites from total sites file that was written out as part of my easySFS scripts
L= # your total sites (including all monomorphic -- not just the monomorphic snps from easy sfs -- TOTAL sites you sequenced) **this is very important to get right **
pops= # list of populations name eg "CA AK AL" -- you will loop through these and do inference on all of them 
todaysdate=`date +%Y%m%d` # sets todays date in form 20200326
sfsdir= # set sfsdir
dadidir= # set dir where you want dadi analysis to go
sfs= #name of sfs

for pop in $pops # if you want to loop through populations
do
for script in $scripts
do
model=${script%.dadi.py}
echo "starting inference for $pop for model $model"
outdir=$dadidir/$pop/inference_$todaysdate/$model/ # creates output directory for population/inference date/model
mkdir -p $outdir
###### carry out dadi inference with 50 replicates that start with different p0 perturbed params: #####
for i in {1..50} # do 50 replicates
do
echo "carrying out inference $i for model $model for pop $pop" 
python $scriptdir/$script --runNum $i --pop $pop --mu $mu --L $L --sfs ${sfsdir}/$sfs --outdir $outdir
done

### concatenate results #############
echo "concatenating results"
grep rundate -m1 $outdir/${pop}.dadi.inference.${model}.runNum.1.output > $outdir/${pop}.dadi.inference.${model}.all.output.concatted.txt
for i in {1..50}
do
grep rundate -A1 $outdir/${pop}.dadi.inference.${model}.runNum.${i}.output | tail -n1 >> $outdir/${pop}.dadi.inference.${model}.all.output.concatted.txt
done

done
done
############################ deactivate virtualenv ###############
deactivate # deactivate virtualenv
