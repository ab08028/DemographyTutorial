# Concatenate FSC results #
# results will end up in :
# $wd/resultsSummaries/$model
# want a table for each model/population with all results
models='1D.1Epoch 1D.2Epoch 1D.3Epoch'
numReps=50 # number of replicates. should be 50+ if you're doing this for real

#wd=/path/to/working/directory 
wd=/Users/annabelbeichman/Documents/UCLA/DemographyWorkshop/ActivityMaterials/fastsimcoalActivity

resultsDir=$wd/fscResults-full50
mkdir -p $resultsDir/resultsSummaries

for model in $models
do
outfile=$resultsDir/resultsSummaries/fsc.inference.${model}.all.output.concatenated.txt
# get header from the run_1 output (could be any run):
header=`head -n1 $resultsDir/$model/run_1/$model/*bestlhoods`
printf "runNum\t$header\n" > $outfile # setting up the header of your output file; adding a column called runNum to keep track of replicate numbers
########### copy generic files into directory and update #########
for i in $(seq 1 $numReps)
do
outdir=$resultsDir/$model/run_${i}/$model/ # specify where output will be pulled from
results=`grep -v [A-Z] $outdir/*bestlhoods` # grab the bestLhoods results file contents
printf "$i\t$results\n" >> $outfile  # send it to your outfile

done
done
