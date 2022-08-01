# DNA_Best_Practices
All processing &amp; analyses from raw fastq files to analyses &amp; figures are contained in the above scripts.

Processing of all raw fastq files was done on a cluster through dada2, which was run in R. After denoising with dada2, ASV taxonomy was initially assigned using SILVA v138.

Below is described how I installed all programs to run the above scripts. 
#### This is written step-by-step for absolute beginners.

### 0) Access your cluster
First you need to sign into your cluster. If you are from UCSB and have an account with Pod, use the following command (replace "USERNAME" with whatever you're username is) and then type in your password when prompted. If you are not using campus wifi, you will have to use the campus VPN to be able to access the cluster.

```{bash}
ssh USERNAME@pod.cnsi.ucsb.edu
```

If you are using a Mac, you can type the above command (and all following commands) into Terminal. If you are using a PC, it is easiest if you download MobaXterm (https://mobaxterm.mobatek.net/download.html) and treat that as your "terminal". From this you can have a "local" terminal window where you access your own personal computer and a terminal where you ssh into your cluster. For almost all commands you will want to be writing them in your terminal window connected to the cluster, but if you are uploading/downloading files from or onto your local computer, those commands should be run in your local terminal.

### 1) Install conda 
This install conda section is copy/pasted directly from Fabian Wittmers (https://github.com/BIOS-SCOPE/PhyloAssigner_python_UCSB)

if you have conda already installed, e.g. if you used it to install a pipline like Qiime2 through conda, you can move on to step 2).

Download the installer for linux from: https://docs.conda.io/en/latest/miniconda.html#linux-installers

How? 
One easy way of achieving this can be the tool wget. Log into your linux machine / cluster. 
Most clusters do have 'wget' pre-installed, so this line should work if you just copy-paste it: 

```{bash}
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
```

This will download a file called 'Miniconda3-py39_4.12.0-Linux-x86_64.sh' into whatever directory you are currently in. 
Next, install conda:

```{bash}
bash Miniconda3-py39_4.12.0-Linux-x86_64.sh
```

After you have finished the installation process (you can press yes whenever conda asks you something during this), you should see "(base)" at the beginning of your commandline handle. If not, log out and in again. If you still don't see the "(base)" at the beginning of the command-line, try:

```{bash}
source ~/.bashrc
conda activate base
```

Now you should have conda installed and activated on your system. Conda is called a 'package manager', it does handle all the annoying parts of installing a bioinformatics tool on your machine for you, so you don't have to worry about all of PhyloAssigners dependencies and having to make sure that they have been installed with the correct version and path, etc.

### 2) Installing R and dada2 on the cluster
An updated R version (>=4.0) is available through the conda-forge channel, so first add the channel.
```{bash}
conda config --add channels conda-forge
```

We are going to install R through conda-forge and not through the default channel, so we need to set its priority over the default channel.
NOTE: You can undo this change by setting strict priority to the default channel as described a bit further below.
```{bash}
conda config --set channel_priority strict
```

Check whether an updated R version is added in the conda search space or not.
```{bash}
conda search r-base
```

Now, it is always a good practice (recommoned here) to create a new conda environment, which will help to debug the package-specific and compatibility issues without disrupting the base environment.
You can change the name to anything you want, here I have named it after the version of R I am installing (R4.1.3)
```{bash}
conda create -n R4.1
```

Let's activate the newly create conda environment.
```{bash}
conda activate R4.1
```

And finally install the R package.
```{bash}
conda install -c conda-forge r-base
```

To reset the default conda channel, run the following
```{bash}
conda config --set channel_priority true
conda update --all
```

To confirm that the default conda channel has been restored (should say channel_priority: flexible)
```{bash}
conda config --describe channel_priority
```

And finally, to start R in the command line, simply type "R" and enter, and you should run R.

Now we need to install the necessary packages. Namely, DADA2, since that is the primary reason we are running R on a cluster. You may have to change the BiocManager version to whatever is current. This may take several minutes.

```{r}
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("dada2", version = "3.14")
```

Now you're ready to start running dada2 on the cluster
