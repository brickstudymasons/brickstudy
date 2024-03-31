"""
Copyright 2023 Netherlands eScience Center and Amsterdam University Medical Center.
Licensed under the Apache License, version 2.0. See LICENSE for details.

This file contains tests for the cvasl library.
"""
#sanity tests for the  library


import unittest
import os
import subprocess
import pandas as pd
import numpy as np
import scipy
from tempfile import TemporaryDirectory
import json
from unittest import TestCase, main
from sklearn.linear_model import LinearRegression

# foundation
from brickstudy.foundation import find_my_key



sample_tab_csv1 = "sample_synthetic_data/showable_standard.csv"

sample_excel = "sample_synthetic_data/example_excel.xlsx"
# where? 


class TestTabDataCleaning(unittest.TestCase):


    def test_find_my_key(self):
        common_col = find_my_key(sample_excel)
        self.assertEqual(['row_key'], common_col)
    


if __name__ == '__main__':
    unittest.main()