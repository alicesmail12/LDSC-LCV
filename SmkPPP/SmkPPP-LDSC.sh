#!/bin/bash

# Define working spaces
WORKING=/Users/alicesmail/Desktop/KCL/LCV

# Remove MHC region for PPP GWAS
$WORKING/RemoveMHC.py \
--sumstatsFile $WORKING/GWASFiles/PPP.txt \
--sep s \
--logFile $WORKING/Logs/PPPMHClog \
--outFile $WORKING/GWASFiles/PPPMHC            

# Remove MHC region for SmkInit GWAS
$WORKING/RemoveMHC.py \
--sumstatsFile $WORKING/GWASFiles/SmkInit.txt \
--sep t \
--logFile $WORKING/Logs/SmkMHClog \
--outFile $WORKING/GWASFiles/SmkMHC

# Within working dir activate python 2.7 (required for LDSC)
cd $WORKING
CONDA_SUBDIR=osx-64 conda create -n py27 python=2.7                               
conda activate py27
conda config --env --set subdir osx-64         

# Clone LSDC software into working dir
cd $WORKING
#git clone https://github.com/bulik/ldsc.git    

# Define software space
SOFTWARE=/Users/alicesmail/Desktop/KCL/LCV/ldsc

# Activate LDSC
cd ldsc   
conda env create --file environment.yml
conda activate ldsc

# Check LDSC is working
./munge_sumstats.py -h

# Munge PPP GWAS
$SOFTWARE/munge_sumstats.py \
--out $WORKING/GWASFiles/PPPMHC \
--merge-alleles $WORKING/GWASFiles/w_hm3.snplist \
--sumstats $WORKING/GWASFiles/PPPMHC.tsv

# Munge Smk GWAS
$SOFTWARE/munge_sumstats.py \
--out $WORKING/GWASFiles/SmkMHC \
--merge-alleles $WORKING/GWASFiles/w_hm3.snplist \
--snp SNP \
--sumstats $WORKING/GWASFiles/SmkMHC.tsv

# Get genetic correlation between BMI & T2D
$SOFTWARE/ldsc.py \
--ref-ld-chr $WORKING/eur_w_ld_chr/ \
--out $WORKING/Logs/SmkPPP \
--rg $WORKING/GWASFiles/PPPMHC.sumstats.gz,$WORKING/GWASFiles/SmkMHC.sumstats.gz \
--w-ld-chr $WORKING/eur_w_ld_chr/ 
