# BONITA-Python3 tutorial

_Authors: Mukta G. Palshikar and Jiayue Meng_

**For a demonstration of the BONITA pipeline, see the below tutorial. The instructions in this README file cover all anticipated use cases.**

This tutorial demostrates the BONITA pipeline for rule inference and pathway analysis on a previously published RNA-sequencing dataset from peripheral blood mononuclear cells from infants with mild or severe respiratory syncitial virus. A set of 37 KEGG pathways that are modulated by RSV infection are used for pathway analysis. All the required files are provided in the Tutorials folder.

__Dataset published in:__

> Mariani TJ, Qiu X, Chu C, Wang L, **Thakar J**, Holden-Wiltse J, Corbett A, Topham DJ, Falsey AR, Caserta MT, Walsh EE. Association of Dynamic Changes in the CD4 T-Cell Transcriptome With Disease Severity During Primary Respiratory Syncytial Virus Infection in Young Infants. J Infect Dis. 2017 Nov 15;216(8):1027-1037. https://doi.org/10.1093/infdis/jix400. PMID: 28962005; PMCID: PMC5853440.

# Installation

Please note that BONITA is designed for use with distributed computing systems. Necessary SLURM commands are included. If users are having trouble translating to PBS or other queueing standards for their computing environment, please contact Juilee Thakar at Juilee_Thakar@urmc.rochester.edu

## Create a conda environment to run BONITA

Use a terminal, or an Anaconda Prompt for the following:

1. Create a conda environment using the provided YML file

```conda env create –name BONITA --file platform_BONITA.yaml```

2. Activate the BONITA environment

```activate BONITA```

3. Check that the BONITA environment is available and correctly installed:

```conda info --envs```


## Install BONITA

You can download and use BONITA in one of two ways:
1. Download a zipped folder containing all the files you need (github download link in green box above and to the right)
2. Clone this git repository in the folder of your choice using the command 

```git clone https://github.com/YOUR-USERNAME/YOUR-REPOSITORY```

Next, the C code must be compiled using the make file. Simply type make while in the BONITA folder.
```make```

Now you have a fully functional distribution of BONITA! Time to gather your data and get started. 

# Usage

We provide the following files to test the BONITA pipeline, in the Tutorials folder:

* __rsv.extreme.phenotype.CD4.tophat.rpm.filtered.20150310.txt__: omics data as a plaintext table with the first row containing a holder for gene symbol column then sample names and subsequent rows containing gene symbol in first column and column-normalized abundance measures in other columns. 
* __filtered.c2.cp.kegg.v3.0.symbols.gmt__: gmt file with list of KEGG pathways to be considered
* __CD4_matrix.txt__: matrix of conditions with each line representing a sample and the first column containing the names of the samples and subsequent columns describing 1/0 if the sample is part of that condition or not. 
* __diffFile.txt__: list of contrasts you would like to run with each contrast on a single line

There are three main steps in BONITA: prepare pathways for rule inference, rule inference, and pathway analysis. The preparation step requires internet access to access the KEGG API. 

## Step 1: Pathway preparation

BONITA needs omics data, gmt file, and an indication of what character is used to separate columns in the file. For example, a traditional comma separated value file (csv) would need BONITA input "-sep ,". Since tab can't be passed in as easily, a -t command will automatically flag tab as the separator. The commands are below:

```python pathway_analysis_setup.py -t -gmt 'filtered.c2.cp.kegg.v3.0.symbols.gmt' --data 'rsv.extreme.phenotype.CD4.tophat.rpm.filtered.20150310.txt'```

## Step 2: Rule inference

Simply run the script find_rules_pathway_analysis.sh which will automatically submit appropriate jobs to SLURM queue:

```bash find_rules_pathway_analysis.sh```

## Step 3: Pathway Analysis

To accomplish this, the proper inputs must be provided to pathway_analysis_score_pathways.py. The `cleaup.sh` script will automatically put output of rule inference step into correct folders. 

```bash cleanup.sh```

Then run the pathway analysis script:

```python pathway_analysis_score_pathways.py -t 'rsv.extreme.phenotype.CD4.tophat.rpm.filtered.20150310.txt' 'CD4_matrix.txt' 'diffFile.txt'```
