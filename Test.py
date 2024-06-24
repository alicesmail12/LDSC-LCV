#!/usr/bin/env python
import argparse
import logging
import pandas as pd
import numpy as np

# Make parser arguments
parser = argparse.ArgumentParser()
parser.add_argument('--sumstatsFile', default=None, type=str,help="Input filename.")
parser.add_argument('--outFile', default=None, type=str,help="Output filename.")
parser.add_argument('--logFile', default=None, type=str,help="Log filename.")
parser.add_argument('--sep', default=None, type=str,help="Separators in GWAS file: enter t for tsv or c for csv.")

# Replacement colnames
replacements = {'POSITION': ['POS','POSITION', 'LOCATION', 'BASE_PAIR_LOCATION', 'BP', 'BASE_PAIR'],
                'CHROMOSOME': ['CHR', 'CHROMOSOME']}

# Genome build maps
GRCh37Map = {
    'rs4771033': 27413269,
    'rs13081502': 19980368,
    'rs7317527': 83642981,
    'rs445925': 45415640,
    'rs7721244': 71643025
}

GRCh38Map = {
    'rs4771033': 26839132,
    'rs13081502': 19938876,
    'rs7317527': 83068846,
    'rs445925': 44912383,
    'rs7721244': 72347198
}


# Functions


def get_genome_build(sumstats):
    '''
    Get genome build of GWAS
    '''
    sumstatsDict = sumstats.set_index('SNP').to_dict()['POSITION']

    # Create dictionary from SNP:Pos
    matching = dict(set(GRCh37Map.items()).intersection(sumstatsDict.items()))

    # Check genome build 
    if len(matching) > 0:
        genomeBuild = 'GRCh37'
    else:
        genomeBuild = None

    matching = dict(set(GRCh38Map.items()).intersection(sumstatsDict.items()))
    if len(matching) > 0:
        genomeBuild = 'GRCh38'

    # Get manually
    if genomeBuild is None:
        print('Cannot detect genome build')
        genomeBuild = input("Please enter genome build (GRCh37 or GRCh38): ")

    if genomeBuild not in ['GRCh37', 'GRCh38']:
        print('Invalid genome build. Must be GRCh37 or GRCh38')
        
    return genomeBuild

    

def remove_MHC(args):
    '''
    Check genome build and remove SNPs in MHC region
    '''

    # Set up logging
    header = "\n*********************************************************************\n"
    header += f"Removing MHC region for {args.sumstatsFile}\n"
    header += "*********************************************************************\n"
    logging.basicConfig(filename=(args.logFile + ".log"), encoding='utf-8', level=logging.INFO, format='%(message)s')
    logging.info(header)
    
    # Read file
    logging.info('Reading GWAS file')
    if args.sep == 't':
        sumstats = pd.read_csv(args.sumstatsFile, sep='\t')
    if args.sep == 'c':
        sumstats = pd.read_csv(args.sumstatsFile, sep=',')
    logging.info(f'   {len(sumstats)} SNPs read')
    logging.info('GWAS file head:')
    logging.info(sumstats.head())

    # Make col names upper case
    logging.info('Standardising GWAS colnames')
    sumstats.columns = sumstats.columns.str.upper()

    # Standardise chr & pos colnames
    sumstats.rename(columns={rep:key for key, values in replacements.items() for rep in values}, inplace=True)

    # Standardise rsID colnames
    for column in sumstats:
        col = sumstats[column].astype(str).str.cat().upper()
        if 'RS' in col:
            sumstats = sumstats.rename({column: 'SNP'}, axis=1)
    GWASlen = len(sumstats)

    # Remove SNPs with no rsID
    logging.info('Removing SNPs with no rsID')
    sumstats = sumstats[sumstats['SNP'].notna()]
    GWASNAlen = len(sumstats)
    logging.info(f'   {GWASlen - GWASNAlen} SNPs with no rsID')

    # Get genome build
    logging.info('Identifying genome build')
    genomeBuild = get_genome_build(sumstats)
    logging.info(f'   Genome Build: {genomeBuild}')

    logging.info('Removing SNPs in MHC region')
    # Remove for GRCh37
    if genomeBuild == 'GRCh37':
        sumstatsRm = sumstats.loc[(sumstats['CHROMOSOME'] == 6) & (sumstats['POSITION']>28477797) & (sumstats['POSITION']<33448354)]

        # Remove SNPs
        sumstats = sumstats[~sumstats['SNP'].isin(sumstatsRm['SNP'])]
        GWASrmlen = len(sumstats)
        logging.info(f'   {GWASNAlen - GWASrmlen} SNPs removed')
    
    # Remove for GRCh38
    if genomeBuild == 'GRCh38':
        sumstatsRm = sumstats.loc[(sumstats['CHROMOSOME'] == 6) & (sumstats['POSITION']>28510120) & (sumstats['POSITION']<33480577)]

        # Remove SNPs
        sumstats = sumstats[~sumstats['SNP'].isin(sumstatsRm['SNP'])]
        GWASrmlen = len(sumstats)
        logging.info(f'   {GWASNAlen - GWASrmlen} SNPs removed')

    # Save to file
    logging.info('Saving file')
    sumstats.to_csv(args.outFile + ".csv")
    logging.info("\n*********************************************************************\n")
    

# Call function
if __name__ == '__main__':
    remove_MHC(parser.parse_args())
    
