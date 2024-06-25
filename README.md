# LDSC & LCV
### References
1. LDSC: Bulik-Sullivan, B. K. et al. (2015) LD Score regression distinguishes confounding from polygenicity in genome-wide association studies. Nature Genetics, 47(3), 291–295. 
2. Genetic Correlation: Bulik-Sullivan, B. K. et al. (2015) An atlas of genetic correlations across human diseases and traits. Nature Genetics, 47, 1236–1241.

### 1. Removing MHC region
RemoveMHC.py detects the genome build of a GWAS & removes the MHC region. RemoveMHC.py can be used with the following commands, where RemoveMHC.py is in the directory Dir, and GWAS files are in Dir/GWASFiles:

```Shell
WORKING=/Users/File/Dir/

$WORKING/RemoveMHC.py \
--sumstatsFile $WORKING/GWASFiles/GWAS.txt \
--sep s \
--logFile $WORKING/Logs/GWASlog \
--outFile $WORKING/GWASFiles/GWASrmMHC    
```

Where:
- `--sumstatsFile` specifies the input GWAS file name
- `--sep` gives the GWAS file format: comma, tab or space-delimited
- `--outFile` specifies the name of the output tsv
- `--logFile` specifies the name of the log output

### 2. Standardising GWAS
The following commands create an environment with the correct Python version to perform LDSC:
```Shell
# Within working dir activate python 2.7 (required for LDSC)
cd $WORKING
CONDA_SUBDIR=osx-64 conda create -n py27 python=2.7                               
conda activate py27
conda config --env --set subdir osx-64         

# Clone LSDC software into working dir
cd $WORKING
git clone https://github.com/bulik/ldsc.git    

# Define software space
SOFTWARE=/Users/alicesmail/Desktop/KCL/LCV/ldsc

# Activate LDSC
cd ldsc   
conda env create --file environment.yml
conda activate ldsc
```

After LDSC is activated, one of the commands can be run to check it is working correctly: `./munge_sumstats.py -h`.
Then the munge_sumstats.py file can be run to standardise a GWAS:
```Shell
$SOFTWARE/munge_sumstats.py \
--sumstats $WORKING/GWASFiles/GWASrmMHC.tsv
--merge-alleles $WORKING/GWASFiles/w_hm3.snplist \
--out $WORKING/GWASFiles/GWASrmMHCMunge \
```
Where:
- `--sumstats` specifies the input GWAS file name
- `--merge-alleles` specifies the name of the LD scores file
- `--out` specifies the name of the output file

### 3. Heritability & Genetic Correlation
### 4. LCV
