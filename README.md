# brickstudy

brickstudy is an open source collaborative python library for analysis of data related to pediatric hematology patients, including and especially the neuroradiology data.

Brick will include a main code library where the user can access the code.

The library is under construction.

Program files
The core functions of brick are in the folder brick.

Our guide to notebooks is under construction. To look around keep in mind the following distinction on folders:

researcher_interface:

These are a growing series of interactive notebooks that allow researchers to investigate questions about their own data

open_work:

This folder contains experimental work by core members of the BRICK team (Drs Candace Makeda Moore, Melanie Bruinooge and Aida Gebremeksel)
Data sets
The notebooks are configured to run on various datasets. Contact Dr. Melanie Bruinooge( 📫 m.bruinooge@erasmusmc.nl) to discuss any questions on data configuration for your datasets.

A standardized dataset is under development.


Supported Platforms
 Below is the list of platforms that should work. Other platforms may work, but have had less extensive testing. Please note that where python.org Python or Anaconda Python stated as supported, it means that versions 3.10 or 3.11 (depending on the release) are supported.

AMD64 (x86)
Linux	Win	OSX
p	Supported	Unknown	Unknown
a	Supported	Supported	Supported
Installation for all supported platforms
Installation with Anaconda/conda and/or mamba are the preffered methods. They are covered in the "Getting Started" section. If you wish to install with pip:

Create and activate a virtual environment (see developer setup section for more details)
Install brick package by running pip install brick.
Getting Started
with the reccomended Conda setup
How to get the notebooks running? Assuming the raw data set and metadata is available. Note for non-conda installations see next sections.

Assuming you are using conda for package management:
Make sure you are in no environment:

conda deactivate
(optional repeat if you are in the base environment)

You can build on your base environment if you want, or if you want to not use option A, you can go below it (no environment)

Option A: Fastest option: In a base-like environment with mamba installed, you can install all Python packages required, using mamba and the environment.yml file.
If you do not have mamba installed you can follow instructions here

The command for Windows/Anaconda/Mamba users can be something like:

mamba env create -f environment.yml
Option B: To work with the most current versions with the possibility for development: Install all Python packages required, using conda and the environment.yml file.

The command for Windows/Anaconda users can be something like:

conda env create -f environment.yml
Linux users can create their own environment by hand (use install_dev as in setup).

Make sure to enter your newly created environment.

Option C: In the future in theory if you want to work, but never develop (i.e. add code), as a conda user with a stable (released) version create an empty environment, and install there:

Create a blank environment with python pinned to 3.10 (assuming version < 0.1.0):

conda create -n blank python=3.10
Install within the blank environment

  conda activate blank
  conda install -c conda-forge -c brick brick jupyter ipympl
Open a notebook (we use Jupyter notebooks) in researcher_interface folder and interactively run the cells. You can use the command jupyter notebook to open a browser window on the folders of notebooks. Note, if you run with an installed library import appropriately. The basic_emg_analysis notebook can be used to understand how to use the package.