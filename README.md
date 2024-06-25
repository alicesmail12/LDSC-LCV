# LDSC & LCV
### 1. Removing MHC region
RemoveMHC.py detects the genome build of a GWAS & removes the MHC region. RemoveMHC.py can be used with the following commands, where RemoveMHC.py is in the directory Dir, and GWAS files are in Dir/GWASFiles:

```shell
WORKING=/Users/File/Dir/

$WORKING/RemoveMHC.py \
--sumstatsFile $WORKING/GWASFiles/GWAS.txt \
--sep s \
--logFile $WORKING/Logs/GWASlog \
--outFile $WORKING/GWASFiles/GWASrmMHC    
```

Where:
- `--sumstatsFile` specifies the input GWAS file name
- `--outFile` specifies the name of the output tsv
- `--logFile` specifies the name of the log output
- `--sep` gives the GWAS file format: comma, tab or space-delimited

### 2. Standardising GWAS
The LDSC package standardises GWAS files. The following commands create an environment with the correct Python version to perform LDSC:
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

### 3. Heritability & Genetic Correlation
### 4. LCV
