
#!/bin/bash

# Define working spaces
WORKING=/Users/alicesmail/Desktop/KCL/LCV

# Download GWAS summary statistics: T2D and BMI
wget http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90096001-GCST90097000/GCST90096926/GCST90096926_buildGRCh37.tsv.gz -P $WORKING/GWASFiles
wget http://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90267001-GCST90268000/GCST90267284/GCST90267284_buildGRCh37.tsv -P $WORKING/GWASFiles

# Remove MHC region
$WORKING/RemoveMHC.py \
--sumstatsFile $WORKING/GWASFiles/GCST90096926_buildGRCh37.tsv \
--sep t \
--logFile $WORKING/Logs/TeaMHClog \
--outFile $WORKING/GWASFiles/TeaMHC            

$WORKING/RemoveMHC.py \
--sumstatsFile $WORKING/GWASFiles/GCST90267284_buildGRCh37.tsv \
--sep t \
--logFile $WORKING/Logs/HeightMHClog \
--outFile $WORKING/GWASFiles/HeightMHC

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

# Munge T2D GWAS
$SOFTWARE/munge_sumstats.py \
--out $WORKING/TeaMHC \
--merge-alleles $WORKING/GWASFiles/w_hm3.snplist \
--N 434171 \
--snp SNP \
--sumstats $WORKING/GWASFiles/TeaMHC.tsv

# Munge BMI GWAS
$SOFTWARE/munge_sumstats.py \
--out $WORKING/HeightMHC \
--merge-alleles $WORKING/GWASFiles/w_hm3.snplist \
--N 283749 \
--snp SNP \
--sumstats $WORKING/GWASFiles/HeightMHC.tsv

# Get genetic correlation between BMI & T2D
$SOFTWARE/ldsc.py \
--ref-ld-chr $WORKING/eur_w_ld_chr/ \
--out $WORKING/Tea_Height \
--rg $WORKING/GWASFiles/TeaMHC.sumstats.gz,$WORKING/GWASFiles/HeightMHC.sumstats.gz \
--w-ld-chr $WORKING/eur_w_ld_chr/ 