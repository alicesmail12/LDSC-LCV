#!/bin/bash

# Define working spaces
WORKING=/Users/alicesmail/Desktop/KCL/LCV
SOFTWARE=/Users/alicesmail/Desktop/KCL/LCV/ldsc

# Within working dir activate python 2.7 (required for LDSC)
cd $WORKING
CONDA_SUBDIR=osx-64 conda create -n py27 python=2.7                               
conda activate py27
conda config --env --set subdir osx-64         

# Clone LSDC software into working dir
cd $WORKING
git clone https://github.com/bulik/ldsc.git                
                                                    
# Activate LDSC
cd ldsc   
conda activate ldsc

# Check LDSC is working
./munge_sumstats.py -h

# Download GWAS summary statistics: T2D and BMI
wget http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90029001-GCST90030000/GCST90029024/GCST90029024_buildGRCh37.tsv -P $WORKING
wget http://ftp.ebi.ac.uk//pub/databases/gwas/summary_statistics/GCST90428001-GCST90429000/GCST90428119/GCST90428119.tsv.gz -P $WORKING

# Munge T2D GWAS
$SOFTWARE/munge_sumstats.py \
--out $WORKING/T2D \
--merge-alleles $WORKING/w_hm3.snplist \
--N 468298 \
--snp variant_id \
--sumstats $WORKING/GCST90029024_buildGRCh37.tsv 

# Munge BMI GWAS
$SOFTWARE/munge_sumstats.py \
--out $WORKING/BMI \
--merge-alleles $WORKING/w_hm3.snplist \
--N 342566 \
--snp rs_id \
--sumstats $WORKING/GCST90428119.tsv.gz

# Get genetic correlation between BMI & T2D
$SOFTWARE/ldsc.py \
--ref-ld-chr eur_w_ld_chr/ \
--out $WORKING/BMI_T2D \
--rg $WORKING/BMI.sumstats.gz,$WORKING/T2D.sumstats.gz \
--w-ld-chr eur_w_ld_chr/ 
