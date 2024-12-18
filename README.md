# brickstudy

<p align="center">
    <img style="width: 35%; height: 35%" src="image011.png">
</p>

brickstudy is an open source collaborative python library for analysis of data related to sickle cell disease patients, including and especially the neuroradiology data.

brickstudy will include a main code library where the user can access the code.

The library is under construction.

Program Files
The core functions of brickstudy are in the folder "brickstudy".

Our guide to notebooks is under construction. To look around keep in mind the following distinction on folders:

notebooks:

These are a growing series of interactive notebooks that allow researchers to investigate questions about their own data

notebooks/experi:

This folder contains experimental work by core members of the BRICK team  Candace Makeda Moore,MD,  Melanie Bruinooge, MD and Aida Gebremeksel, MD)
Data sets:
The notebooks are configured to run on various datasets. Contact Melanie Bruinooge, MD (📫 m.bruinooge@erasmusmc.nl) to discuss any questions on data configuration for your datasets.

notebooks/teaching:

This folder contains teaching materials for learning the most basic basics of handling data.

A standardized dataset is under development.

### Documentation
Documentation is available at https://brickstudymasons.github.io/brickstudy/

### Supported Platforms

brickstudy is a pure Python package. Below is the list of
platforms that should work. Other platforms may work, but have had less extensive testing.
Please note that where
python.org Python or Anaconda Python stated as supported, it means
that versions 3.10 or 3.11 (depending on the release) are supported.

#### AMD64 (x86)

|                             | Linux     | Win       | OSX       |
|:---------------------------:|:---------:|:---------:|:---------:|
| ![p](etc/python-logo.png)   | Supported | Unknown   | Unknown   |
| ![a](etc/anaconda-logo.png) | Supported | Supported | Supported |


Installation with Anaconda/conda and/or mamba are the preffered methods. They are covered in the "Getting Started" section. 

### Getting started
Create and activate a virtual environment (see developer setup section for more details)
Install brickstudy package by running pip install brickstudy.
Getting Started
with the reccomended Conda setup
How to get the notebooks running? Assuming the raw data set and metadata is available. Note for non-conda installations see next sections.

Assuming you are using conda for package management:
Make sure you are in no environment:

```conda deactivate````
(optional repeat if you are in the base environment)

You can build on your base environment if you want, or if you want to not use option A, you can go below it (no environment)

Option A: Fastest option: In a base-like environment with mamba installed, you can install all Python packages required, using mamba and the environment.yml file.

The command for Windows/Anaconda/Mamba users can be something like:

```mamba env create -f environment.yml```

Option B: To work with the most current versions with the possibility for development: Install all Python packages required, using conda and the environment.yml file.

The command for Windows/Anaconda users can be something like:

```conda env create -f environment.yml```

Linux users can create their own environment by hand (use install_dev as in setup).

Make sure to enter your newly created environment.


Open a notebook (we use Jupyter notebooks) in the notebooks folder and interactively run the cells. You can use the command jupyter lab to open a browser window on the folders of notebooks. Note, if you run with an installed library import appropriately. The teaching notebooks can be used to understand how to use the package.