########## Install fsc2: ######
# please install on hoffman2 or on your home mac
# If you use a PC please use hoffman2 or a virtual linux machine
# if you are not comfortable installing programs/using the command line, please be ready to just listen and take notes during the tutorial

############# on Hoffman ###############
# source of software: http://cmpg.unibe.ch/software/fastsimcoal2/
# Right click on "Linux 64 Bits" -- "Copy link location" to get link location 

#In Hoffman, cd into wherever you install software. For me it's ~/bin/
qrsh # for interactive node
wget http://cmpg.unibe.ch/software/fastsimcoal2/downloads/fsc26_linux64.zip
unzip fsc26_linux64.zip
cd fsc26_linux64
chmod +x fsc26
./fsc26 --h # should yield menu of parameters if install worked
########### NOTE THE PATH TO FSC26 -- you will need it for the exercises!

########### on home Mac ###########

# FSC has some compatibility issues with Macs now (very annoying!)
# From the fsc2 homepage:  "the plain version of fsc26 will not run on mac osX unless you have installed a recent version of gcc.
#This is because fsc26 is multithreaded and it uses intel's libraries based on openMP, which are not distributed anymore with recent versions of mac OSX.
#So to be able to run fsc26 on your mac, you need to first install a recent version of gcc"
#To do so, follow these steps:

#Download gcc-7.1-bin.tar.gz from https://sourceforge.net/projects/hpc/
#Open a terminal
# copy the downloaded file to your applications (or whereever you want to keep it)
cp ~/Downloads/gcc-7.1-bin.tar.gz /Applications/
#Extract the tar archive with the command 
gunzip gcc-7.1-bin.tar.gz
#Install gcc ver 7.1 in /usr/local with the command
sudo tar -xvf gcc-7.1-bin.tar -C /. --no-same-owner # will need to enter your password 
#### if you are a frequent GCC user and this will mess up your environment please be cautious and maybe use a conda environment ###

# then install fsc2:
# source of software: http://cmpg.unibe.ch/software/fastsimcoal2/
# Right click on "MacOSX Sierra" -- "Copy link location" to get link location 
# cd into wherever you install software. For me it's /Applications
wget http://cmpg.unibe.ch/software/fastsimcoal2/downloads/fsc26_mac64.zip
unzip fsc26_mac64.zip
cd fsc26_mac64
chmod +x fsc26
./fsc26 --h # should yield menu of parameters if install worked

########### NOTE THE PATH TO FSC26 -- you will need it for the exercises! (or add it to your path or as an alias if you are comfortable doing that) #######
