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

RemoveMHC.py takes the flags:
- `--sumstatsFile` takes the input GWAS file name
- `--outFile` specifies the name of the output tsv
- `--logFile` specifies the name of the log output
- `--sep` gives the GWAS file format: comma, tab or space-delimited

>[!NOTE]
> If the genome position column in the GWAS file is not named 'POS', 'POSITION', 'LOCATION', 'BASE_PAIR_LOCATION', 'BP' or 'BASE_PAIR', RemoveMHC.py should be updated with the relevant column name. This is also true for the chromosome column, if it is not named 'CHR' or 'CHROMOSOME'.


### 2. Standardising GWAS
### 3. Heritability & Genetic Correlation
### 4. LCV
