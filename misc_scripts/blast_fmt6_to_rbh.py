#!/usr/local/bin/python3

# import
import argparse
import pandas as pd
import os
import sys
import errno

# basic info
__doc__ = '''
    This script was designed to screen
    reciprocal best hit gene pairs
    from BLAST format 6 results
    '''
__epilog__ = '''
    author : Matthew
    mail   : matthewhawking@outlook.com
    date   : 23 Mar 2022
    version: 0.2
    '''


def main():
    parser = argparse.ArgumentParser(
        description = __doc__,
        formatter_class = argparse.RawDescriptionHelpFormatter,
        epilog = __epilog__)
    parser.add_argument(
        '-s',
        help = 'species number, please type 1 or 2, required',
        dest = 'species',
        type = int,
        required = True)
    parser.add_argument("input")
    args = parser.parse_args()

    # read input and rename the column
    blast = pd.read_csv(args.input, header=None, sep = "\t")
    blast.columns = ['qaccver', 'saccver', 'pident', 
                    'length', 'mismatch', 'gapopen', 
                    'qstart', 'qend', 'sstart', 'send', 
                    'evalue', 'bitscore']

    # core selection
    if args.species == 1:
        blast = blast.query('qaccver != saccver')
    elif args.species == 2:
        pass
    else:
        print("please enter 1 or 2")
    
    # group by query accession number, and get top1 hit, 
    # alignment length should greater then 100
    best_hit = blast.groupby('qaccver').head(1).query('length > 100')
    
    # get gene pairs to screen
    gene_pairs = pd.DataFrame(
        best_hit, 
        columns=["qaccver","saccver"]
        ).values.tolist()
    
    rbh=set()
    for a, b in gene_pairs:
        if [b, a] in gene_pairs:
            rbh.add((a,b))
    # change rbh from set to list, make it changable
    rbh = list(rbh)
    # remove duplicated gene pairs
    for a,b in rbh:
        if (b, a) in rbh:
            rbh.remove((b, a))
    # output to stdout
    try:
        for a, b in rbh:
            print(f'{a}\t{b}')
    except IOError as e:
        if e.errno == errno.EPIPE:
        pass


if __name__=="__main__":
    main()
