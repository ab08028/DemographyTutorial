# -*- coding: utf-8 -*-
"""
Created on Tue Oct 16 16:46:27 2018

@author: annabelbeichman
"""
import math # to get log10
import numpy as np
import scipy
import matplotlib
matplotlib.use('Agg') # so it doesn't pop up graphics on hoffman
import sys
import argparse
import dadi
from dadi import Numerics, PhiManip, Integration, Spectrum, Demographics1D
# note: module  Demographics1D has the following models file:///Users/annabelbeichman/Documents/UCLA/dadi/dadi/doc/api/dadi.Demographics1D-module.html
# has 2 epoch, and 3 epoch (bottleneck)

from numpy import array # don't comment this out
import datetime
todaysdate=datetime.datetime.today().strftime('%Y%m%d')

modelName="1D.2Epoch"
############### Parse input arguments ########################
parser = argparse.ArgumentParser(description='Carry out a grid search for a '+ modelName +' model ')
parser.add_argument("--pop",required=True,help="population identifier, e.g. 'CA'")
parser.add_argument("--sfs",required=True,help="path to FOLDED SFS in dadi format from easysfs (mask optional)")
parser.add_argument("--nu_Low",required=True,help="input lower bound on nu in dadi units (scaled by Nanc)-- distance between low and high will be searched evenly along a log scale")
parser.add_argument("--nu_High",required=True,help="input upper bound on nu in dadi units (scaled by Nanc) -- distance points between nu_Low and nu_High will be searched evenly along a log scale")
parser.add_argument("--T_Low",required=True,help="input lower bound on T in dadi units (scaled by 2*Nanc); distance between T_Low and T_High will be searched evenly along a log scale")
parser.add_argument("--T_High",required=True,help="input upper bound on T in dadi units (scaled by 2*Nanc); distance between low and high will be searched evenly along a log scale")
parser.add_argument("--numGridPoints",required=True,help="number of grid points per parameter you want. Keep in mind this can drastically affect run time (e.g. 10 --> 100 calculations; 25 -->  625 calculations")
parser.add_argument("--outdir",required=True,help="path to output directory")

# instead: put input as a range and do the grid search within python'
# python grid.search1D.2Epoch.dadi.py --pop CA --sfs [path to sfs] --nu_Low 0.1 --nu_High 1 --T_Low 0.1 --T_High 2 --numGridPoints 25 --outdir [path to outdir]
args = parser.parse_args()
pop=str(args.pop)
outdir=str(args.outdir)
sfs=str(args.sfs)
numGridPoints=float(args.numGridPoints)

### 2019011 update: input is in dadi units:
nu_High_rescaled=float(args.nu_High)
nu_Low_rescaled=float(args.nu_Low)
T_High_rescaled=float(args.T_High)
T_Low_rescaled=float(args.T_Low)
maxiter=100

############### Input data ####################################
#for testing
fs=dadi.Spectrum.from_file(sfs) # this is folded if from easy SFS

# check if it's folded, if not folded, fold it
if fs.folded==False:
    fs=fs.fold()
else:
    fs=fs
############ set up grid for specific model  ##########

func = Demographics1D.two_epoch #

param_names= ("nu","T")
scaled_param_names=("nu_scaledByGivenNanc_dip","T_scaledByGivenNanc_gen")
# Make extrapolation function:
func_ex = dadi.Numerics.make_extrap_log_func(func) # this will give you the exp SFS



# https://stackoverflow.com/questions/13370570/elegant-grid-search-in-python-numpy
from sklearn.model_selection import ParameterGrid
# from numpy use linspace where you tell it how many points you want between two numbers
# note that log10(nu_Low_rescaled) gives you the exponent to put in as the start
# this is correct! so for example if you wanted to search 10 points between
# 0.0001 and 0.001
# you would do np.logspace(-4,-3,10) where -4 and -3 are the exponents
# so to get those exponents you take the base10 log of 0.0001 to get -4 and put that in: *make sure to use log10!!! (not natural log) ***
nus= np.logspace(math.log10(nu_Low_rescaled),math.log10(nu_High_rescaled),numGridPoints) # return values evenly spaced along log scale,from base**start to base**stop base =10, get 10 data points
Ts= np.logspace(math.log10(T_Low_rescaled),math.log10(T_High_rescaled),numGridPoints) # goes from approx 1 gen to ~70 gen
# set up your set of parameters
param_grid = {'nu': nus, 'T' : Ts}
# use the sklearn module to make a list with every pair of parameters in it:
# similar to R expand
grid = ParameterGrid(param_grid)

# nu: Ratio of contemporary to ancient population size
# T: Time in the past at which size change happened (in units of 2*Na)
# don't need upper/lower bounds because not optimizing


############# set up outfile #########
outputFile=open(str(outdir)+"/"+"dadi.grid.search."+str(pop)+"."+str(modelName)+".LL.output.txt","w")
param_names_str='\t'.join(str(x) for x in param_names)
scaled_param_names_str='\t'.join(str(x) for x in scaled_param_names)
header=param_names_str+"\t"+scaled_param_names_str+"\ttheta\tNanc_given\tLL_model\tLL_data\tmodelFunction\tsampleSize\texpectedSFS_fold_Theta1\tobservedSFS_folded" # add additional parameters theta, log-likelihood, model name, run number and rundate
# set Nanc externally from past runs for each population
outputFile.write(header)
outputFile.write("\n")
# function to get the exp SFS and LL based on parameters YOU provide

def provideParams_2EpochModel(fs,Nanc,nu,T):
    # get sample size from sfs
    ns= fs.sample_sizes
    # get pts from sample size
    pts_l = [ns[0]+5,ns[0]+15,ns[0]+25]
    # get the expected sfs for this set of parameters:
    model=func_ex([nu,T],ns,pts_l)
    # get the LL of model
    ll_model = dadi.Inference.ll_multinom(model, fs)
    # also get the LL of the data to itself (best possible ll)
    ll_data=dadi.Inference.ll_multinom(fs, fs)
    # Note Nanc is not calculated from the SFS, it is set externally based on past runs (could change that if I wanted )
    theta = dadi.Inference.optimal_sfs_scaling(model, fs)
    # Set Nanc without theta (maybe? see how this works)
    nu_scaled_dip=nu*Nanc
    T_scaled_gen=T*2*Nanc
    # fold exp sfs
    model_folded=model.fold()
    # note use of sfs.tolist() has to have () at the end
    # otherwise you get weird newlines in the mix
    output=[nu,T,nu_scaled_dip,T_scaled_gen,theta,
 Nanc,ll_model,ll_data,func.func_name,ns[0],model_folded.tolist(),fs.tolist()] # put all the output terms together
    output='\t'.join(str(x) for x in output)
    return(output)


# run the function on the grid of all parameter pairs:
for params in grid:
    output=provideParams_2EpochModel(fs=fs, Nanc=Nanc,nu=params['nu'],T=params['T'])
    outputFile.write(output)
    outputFile.write("\n")

outputFile.close()

###### exit #######
sys.exit()
