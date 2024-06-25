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

### 2. Standardising GWAS
### 3. Heritability & Genetic Correlation
### 4. LCV
