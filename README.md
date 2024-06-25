# LDSC & LCV
### 1. Removing MHC region
RemoveMHC.py detects the genome build of a GWAS & removes the MHC region. RemoveMHC.py can be used with the following commands, where RemoveMHC.py is in the directory DIR, and GWAS files are in DIR/GWASFiles:

```shell
WORKING=/Users/File/DIR/

$WORKING/RemoveMHC.py \
--sumstatsFile $WORKING/GWASFiles/GWAS_2.txt \
--sep s \
--N 403506 \
--logFile $WORKING/Logs/PPPMHClog \
--outFile $WORKING/GWASFiles/PPPMHC     


```

### 2. Standardising GWAS
### 3. Heritability & Genetic Correlation
### 4. LCV
