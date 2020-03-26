# wrapper for grid search
# runs fast, can do on home computer. If doing larger grids, run on hoffman
scriptdir= # path to script directory
model=1D.2Epoch # model name
script=grid.Search.${model}.dadi.dadiUnits.py 

indir= # path to input directory that contains SFS
sfs= # the name of SFS
############# set your high and low search range in dadi units : ############ 
nu_Low=0.1  # Divide desired low size in 'real' diploid units by Nanc to get dadi units
nu_High=2 #  Divide desired high size in 'real' diploid units by Nanc to get dadi units
T_Low=0.1 # Divide desired low time in 'real' generations by 2*Nanc to get dadi units
T_High=1 # Divide desired low time in 'real' generations by 2*Nanc to get dadi units
######### These are just example low/high values! Set them yourself for your project! ###############

################# Example #########################
pop=# name of population
outdir=/path/to/outdir/grid.search/$pop
mkdir -p $outdir # make the pop-specific outdir
sfs= # the name of SFS specific to your population
#  note that grid is log10 scaled, so will have more data points at the lower values, fewer as you go higher
# you can change this within the grid.search script if you want even scaling
# this will result in 100x100 grid
python $scriptdir/$script --sfs $indir/$sfs --pop $pop  --numGridPoints 100 --nu_Low ${nu_Low} --nu_High ${nu_High} --T_Low ${T_Low} --T_High ${T_High} --outdir $outdir

# gzip output
gzip -f $outdir/dadi.grid.search.${pop}.${model}.LL.output.txt
