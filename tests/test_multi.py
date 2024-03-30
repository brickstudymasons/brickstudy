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
from brickstudy.foundation import report_ranges



sample_tab_csv1 = "sample_synthetic_data/showable_standard.csv"
# where? 


class TestTabDataCleaning(unittest.TestCase):

    def test_report_ranges(self):
        data = pd.read_csv(sample_tab_csv1)
        data['ranges'] = data['gm_vol']
        sum = report_ranges(data)
        oc = data['gm_vol'].sum()

        self.assertEqual(sum, oc)
    


if __name__ == '__main__':
    unittest.main()