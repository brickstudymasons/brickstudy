# This needs an new intro

"""
Copyright 2024 Rotterdam University Medical Center.
Licensed under the Apache License, version 2.0. See LICENSE for details.
This file contains methods to deal with DICOMS.
Note the package will have an optional pydicom dependancy,
without it this module
has functions related to dicoms that will not work.

"""
# import libraries


import os
import glob
from abc import ABC, abstractmethod


from datetime import datetime, date

import pandas as pd
import SimpleITK as sitk
from functools import reduce
import numpy
from datetime import datetime, date
# import pydicom as dicom
import pandas as pd
import openpyxl
import skimage.io as io

# from pydicom.multival import MultiValue
# from pydicom.sequence import Sequence


def find_my_key(excel_book_name):
    """
    This function reads a multi-sheet excel file's sheets
    into pandas objects, and finds the common columns
    """
    # read Excel file with multiple sheets
    xls = pd.ExcelFile(excel_book_name)
    # get the list of sheet names
    sheet_names = xls.sheet_names
    excel_file = pd.read_excel(excel_book_name, sheet_name=sheet_names)
    sheet_list = []
    for sheet_name in sheet_names:
        sheet = excel_file[sheet_name]
        sheet_list.append(sheet)
    set_columns = []
    for listi in sheet_list:
        setcolumns_set = set(listi.columns)
        set_columns.append(setcolumns_set)
    result_set = set_columns[0]
    for set_specific in set_columns[1:]:
        common_columns = result_set.intersection(set_specific)
        common_columns = list(common_columns)

    return common_columns


def csv_my_excel(excel_book_name, keyname):
    """
    this function takes a multisheet excel and reads in the sheets
    into a csv
    """
    # read Excel file with multiple sheets
    xls = pd.ExcelFile(excel_book_name)
    # get the list of sheet names
    sheet_names = xls.sheet_names
    excel_file = pd.read_excel(excel_book_name, sheet_name=sheet_names)
    sheet_list = []
    for sheet_name in sheet_names:
        sheet = excel_file[sheet_name]
        sheet_list.append(sheet)
    df_merged = reduce(lambda left, right: pd.merge(
        left, right, on=keyname, how='outer'), sheet_list)
    df_merged.dropna(how='all', axis=1, inplace=True)
    return df_merged


# class PydicomDicomReader:
#     """Class for reading DICOM metadata with pydicom."""

#     exclude_field_types = (Sequence, MultiValue, bytes)
#     """
#     Default types of fields not to be included in the dataframe
#     produced from parsed DICOM files.
#     """

#     date_fields = ('ContentDate', 'SeriesDate', 'ContentDate', 'StudyDate')
#     """
#     Default DICOM tags that should be interpreted as containing date
#     information.
#     """

#     time_fields = ('ContentTime', 'StudyTime')
#     """
#     Default DICOM tags that should be interpreted as containing
#     datetime information.
#     """

#     exclude_fields = ()
#     """
#     Default tags to be excluded from genrated :code:`DataFrame` for any
#     other reason.
#     """

#     def __init__(
#             self,
#             exclude_field_types=None,
#             date_fields=None,
#             time_fields=None,
#             exclude_fields=None,
#     ):
#         """
#         Initializes the reader with some filtering options.
#         :param exclude_field_types: Some DICOM types have internal structure
#                                     difficult to represent in a dataframe.
#                                     These are filtered by default:
#                                     * :class:`~pydicom.sequence.Sequence`
#                                     * :class:`~pydicom.multival.MultiValue`
#                                     * :class:`bytes` (this is usually the
#                                       image data)
#         :type exclude_field_types: Sequence[type]
#         :param date_fields: Fields that should be interpreted as having
#                             date information in them.
#         :type date_fields: Sequence[str]

#         :param time_fields: Fields that should be interpreted as having
#                             time information in them.
#         :type time_fields: Sequence[str]
#         :param exclude_fields: Fields to exclude (in addition to those
#                                selected by :code:`exclude_field_types`
#         :type exclude_fields: Sequence[str]
#         """
#         if exclude_field_types:
#             self.exclude_field_types = exclude_field_types
#         if date_fields:
#             self.date_fields = date_fields
#         if exclude_fields:
#             self.exclude_fields = exclude_fields

#     def dicom_date_to_date(self, source):
#         """
#         Utility method to help translate DICOM dates to
#            :class:`~datetime.date`
#         :param source: Date stored as a string in DICOM file.
#         :type source: str
#         :return: Python date object.
#         :rtype: :class:`~datetime.date`
#         """
#         year = int(source[:4])
#         month = int(source[4:6])
#         day = int(source[6:])
#         return date(year=year, month=month, day=day)

#     def read(self, source):
#         """
#         This function allows reading of metadata in what source gives.
#         :param source: A source generator.  For extended explanation see
#                        :class:`~carve.Source`.
#         :type source: :class:`~carve.Source`
#         :return: dataframe with metadata from dicoms
#         :rtype: :class:`~pandas.DataFrame`
#         """

#         tag = source.get_tag()
#         columns = {tag: []}
#         colnames = set([])
#         excluded_columns = set([])
#         for key, parsed in source.items(dicom.dcmread):
#             for field in parsed.dir():
#                 colnames.add(field)
#                 val = parsed[field].value
#                 if isinstance(val, self.exclude_field_types):
#                     excluded_columns.add(field)
#         colnames -= excluded_columns
#         colnames -= set(self.exclude_fields)
#         for key, parsed in source.items(dicom.dcmread, os.path.basename):
#             columns[tag].append(key)
#             for field in colnames:
#                 val = parsed[field].value
#                 col = columns.get(field, [])
#                 if field in self.date_fields:
#                     val = self.dicom_date_to_date(val)
#                 # elif field in self.time_fields:
#                 #     val = self.dicom_time_to_time(val)
#                 elif isinstance(val, int):
#                     val = int(val)
#                 elif isinstance(val, float):
#                     val = float(val)
#                 elif isinstance(val, str):
#                     val = str(val)
#                 col.append(val)
#                 columns[field] = col
#         return pd.DataFrame(columns)
