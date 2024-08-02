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
import openpyxl
import numpy as np
import scipy
from tempfile import TemporaryDirectory
import json
from unittest import TestCase, main
from sklearn.linear_model import LinearRegression

# foundation
from brickstudy.foundation import find_my_key
from brickstudy.foundation import show_neg_value_patients
from brickstudy.foundation import map_for_commas
from brickstudy.foundation import map_for_commas_if_all_strings
from brickstudy.foundation import check_and_print_commas



sample_tab_csv1 = "sample_synthetic_data/showable_standard.csv"

sample_excel = "sample_synthetic_data/example_excel.xlsx"


class TestTabDataCleaning(unittest.TestCase):


    def test_find_my_key(self):
        common_col = find_my_key(sample_excel)
        self.assertEqual(['row_key'], common_col)

    def test_show_neg_value_patients(self):
        sample_tab_csv1_read = pd.read_csv(sample_tab_csv1)
        returned = show_neg_value_patients(sample_tab_csv1_read, 0)
        self.assertEqual( len(returned[0]) + len(returned[1]), len(returned[0]))
    
    def test_map_for_commas(self):
        sample_tab_csv1_read = pd.read_csv(sample_tab_csv1)
        with_commas = map_for_commas(sample_tab_csv1_read)
        self.assertTrue(with_commas[0].map(lambda x: x is False).all().all())

    def test_map_for_commas_if_all_strings(self):
        sample_tab_csv1_read = pd.read_csv(sample_tab_csv1)
        with_commas = map_for_commas_if_all_strings(sample_tab_csv1_read)
        self.assertTrue(with_commas[0].map(lambda x: x is False).all().all())

    def test_check_and_print_commas(self):
        sample_tab_csv1_read = pd.read_csv(sample_tab_csv1)
        sample_with_comma = sample_tab_csv1_read.map(lambda x: str(x) + "," )
        count_sample_with = check_and_print_commas(sample_with_comma)
        expected_count = sample_tab_csv1_read.shape[0]* sample_tab_csv1_read.shape[1]
        self.assertEqual(count_sample_with, expected_count)

    


if __name__ == '__main__':
    unittest.main()