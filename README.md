# BONITA-Python3

BONITA was originally written in Python 2 and tested with Python 2-compatible packages. This version of the packages ports BONITA to Python 3 and has significant improvements in speed. We encourage users to use this actively-maintained version of the package going forward. 

BONITA- Boolean Omics Network Invariant-Time Analysis is a package for the inference of Boolean rules and pathway analysis on omics data. It can be applied to help uncover underlying relationships in biological data. Please see our [publication](https://doi.org/10.1371/journal.pcbi.1007317) for more information. 

Authors: _[Rohith Palli](https://github.com/rpalli), [Mukta G. Palshikar](https://github.com/mgp13) and Juilee Thakar_

**BONITA ported to Python 3 by [Mukta G. Palshikar](https://github.com/muktapalshikar) and [Jiayue Meng](https://github.com/JiayueMeng)**

**For a demonstration of the BONITA pipeline, see the tutorial in Tutorials/BONITA_pipeline_tutorial.md. The instructions in the current README file cover all anticipated use cases.**

**Maintainer**: Please contact Juilee Thakar at Juilee_Thakar@urmc.rochester.edu

# Citation

We would appreciate the citation of our manuscript describing the original BONITA release, below, for any use of our code. 

Palli R, Palshikar MG, Thakar J (2019) Executable pathway analysis using ensemble discrete-state modeling for large-scale data. PLoS Comput Biol 15(9): e1007317. (https://doi.org/10.1371/journal.pcbi.1007317)

# Installation
BONITA is designed for use with distributed computing systems. Necessary SLURM commands are included. If users are having trouble translating to PBS or other queueing standards for their computing environment, please contact Juilee Thakar at Juilee_Thakar@urmc.rochester.edu

## Create a conda environment to run BONITA

Use a terminal, or an Anaconda Prompt for the following:

1. Create a conda environment using the provided YML file

```conda env create -–name=BONITA --file platform_BONITA.yaml```

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

You will need the following files to run BONITA:
* omics data as a plaintext table (csv, tsv, or similar) with the first row containing a holder for gene symbol column then sample names and subsequent rows containing gene symbol in first column and column-normalized (rpm or rpkm in transcriptomics) abundance measures in other columns. 
* gmt file with list of KEGG pathways to be considered (can be downloaded from msigdb)
* matrix of conditions with each line representing a sample and the first column containing the names of the samples and subsequent columns describing 1/0 if the sample is part of that condition or not. 
* list of contrasts you would like to run with each contrast on a single line

There are three main steps in BONITA: prepare pathways for rule inference, rule inference, and pathway analysis. All necessary files for an example run are provided in the Tutorials folder . The preparation step requires internet access to access the KEGG API. 

## Step 1: Pathway preparation

**See the bash script pathwayPreparation.sh for examples**

**This step requires internet access.** 

There are three ways to complete this process: 
1. on a gmt of human pathways
2. on all KEGG pathways for any organism, or
3. on a list of KEGG pathways for any organism

**Only Option 1 was used and tested in our manuscript. Caution should be exercised in interpreting results of other two methods. At a minimum, graphmls with impact scores and relative abundance should be examined before drawing conclusions about pathway differences.**

### Option 1: On a gmt of human pathways

BONITA needs omics data, gmt file, and an indication of what character is used to separate columns in the file. For example, a traditional comma separated value file (csv) would need BONITA input "-sep ,". Since tab can't be passed in as easily, a -t command will automatically flag tab as the separator. The commands are below:

comma separated: ```python pathway_analysis_setup.py -gmt Your_gmt_file -sep , --data Your_omics_data ```

tab separated: ```python pathway_analysis_setup.py -t  -gmt Your_gmt_file --data Your_omics_data```

### Option 2: On all KEGG pathways for any organism

BONITA needs omics data, organism code, and an indication of what character is used to separate columns in the file. For example, a traditional comma separated value file (csv) would need BONITA input "-sep ,". Since tab can't be passed in as easily, a -t command will automatically flag tab as the separator. A three letter organism code from KEGG must be provided (lower case). Example codes include mmu for mouse and hsa for human. The commands are below:
comma separated: ```python pathway_analysis_setup.py -org Your_org_code -sep , --data Your_omics_data ```

comma separated, human: ```python pathway_analysis_setup.py -org hsa -sep , --data Your_omics_data ```

comma separated, mouse: ```python pathway_analysis_setup.py -org mmu -sep , --data Your_omics_data ```

tab separated: ```python pathway_analysis_setup.py -t  -org Your_org_code --data Your_omics_data```

### Option 3: On a list of KEGG pathways for any organism
BONITA needs omics data, organism code, the list of pathways, and an indication of what character is used to separate columns in the file. For example, a traditional comma separated value file (csv) would need BONITA input "-sep ,". Since tab can't be passed in as easily, a -t command will automatically flag tab as the separator. A three letter organism code from KEGG must be provided (lower case). Example codes include mmu for mouse and hsa for human. The list of pathways must include the 5 digit pathway identifier, must be seperated by commas, and must not include any other numbers. An example paths.txt is included in the inputData folder. The commands are below:
comma separated: `python pathway_analysis_setup.py -org Your_org_code -sep , -paths Your_pathway_list --data Your_omics_data `

comma separated, human: ```python pathway_analysis_setup.py -org hsa -sep , -paths Your_pathway_list --data Your_omics_data ```

comma separated, mouse: ```python pathway_analysis_setup.py -org mmu -sep , -paths Your_pathway_list --data Your_omics_data ```

tab separated: ```python pathway_analysis_setup.py -t  -org Your_org_code -paths Your_pathway_list --data Your_omics_data```

## Step 2: Rule inference

Simply run the script find_rules_pathway_analysis.sh which will automatically submit appropriate jobs to SLURM queue:

```bash find_rules_pathway_analysis.sh```

## Step 3: Pathway Analysis

To accomplish this, the proper inputs must be provided to pathway_analysis_score_pathways.py. The `cleaup.sh` script will automatically put output of rule inference step into correct folders. 

```bash cleanup.sh```

Then run the pathway analysis script:

```python pathway_analysis_score_pathways.py Your_omics_data Your_condition_matrix Your_desired_contrasts -sep Separator_used_in_gmt_and_omics_data```

If your files are tab separated, then the following command can be used: ```python pathway_analysis_score_pathways.py -t Your_omics_data Your_condition_matrix Your_desired_contrasts```
