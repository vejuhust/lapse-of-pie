#!/usr/bin/env python3

from os import listdir, makedirs
from os.path import join, dirname, abspath
from json import dump, dumps, loads
from re import compile, IGNORECASE
from datetime import datetime, timedelta
from time import time
from collections import OrderedDict
from shutil import copy2

photo_list_file = "photo_list.json"
photo_directory = r"/media/networkshare/stcsuz/lapsephoto"


def save_file(filename, data):
    with open(join(dirname(abspath(__file__)), filename), 'w') as outfile:
        dump(data, outfile)


def load_file(filename):
    with open(join(dirname(abspath(__file__)), filename), 'r') as infile:
        return loads(infile.read())


def load_directory_list(directory_name):
    name_list = listdir(directory_name)
    path_list = [
        join(directory_name, filename)
        for filename in name_list
        if filename.endswith('jpg') ]
    sorted(path_list)
    return path_list


def create_photo_list():
    photo_path_list = load_directory_list(photo_directory)
    save_file(photo_list_file, { "path": photo_path_list })


def load_photo_list():
    saved_data = load_file(photo_list_file)
    photo_path_list = saved_data["path"]
    return photo_path_list


date_pattern = compile(r"snap-(?P<year>\d*?)_(?P<month>\d*?)_(?P<day>\d*?)-(?P<hour>\d*?)_(?P<minute>\d*?)_(?P<second>\d*?)\.", IGNORECASE)
def parse_datetime(path):
    date_result = None
    date_match = date_pattern.search(path)
    if date_match:
        date_result = datetime(
            int(date_match.group("year")),
            int(date_match.group("month")),
            int(date_match.group("day")),
            int(date_match.group("hour")),
            int(date_match.group("minute")))
    return date_result


def combine_datetime_with_path_dict(path_list):
    combined_dict = OrderedDict()
    for path in path_list:
        date = parse_datetime(path)
        if date:
            combined_dict[date] = path
    sorted(combined_dict)
    return combined_dict


# 12:00, 12:03, 12:06 - three frames per day
def get_photo_series_1(date_first, date_last, path_dict):
    photo_series = []
    delta_offset = timedelta(0, 12 * 60 * 60)
    delta_day = timedelta(1, 0)
    delta_minute = timedelta(0, 60 * 3)
    current_date = date_first
    while (current_date <= date_last):
        current_datetime = delta_offset + datetime(current_date.year, current_date.month, current_date.day)
        for _ in range(3):
            if current_datetime in path_dict:
                photo_series.append(path_dict[current_datetime])
            current_datetime += delta_minute
        current_date += delta_day
    return photo_series


# 11:00, 11:30, 12:00, 12:30, 13:00 - five frames per day
def get_photo_series_2(date_first, date_last, path_dict):
    photo_series = []
    delta_offset = timedelta(0, 11 * 60 * 60)
    delta_day = timedelta(1, 0)
    delta_minute = timedelta(0, 60 * 30)
    current_date = date_first
    while (current_date <= date_last):
        current_datetime = delta_offset + datetime(current_date.year, current_date.month, current_date.day)
        for _ in range(5):
            if current_datetime in path_dict:
                photo_series.append(path_dict[current_datetime])
            current_datetime += delta_minute
        current_date += delta_day
    return photo_series


# Day1: 06:00, 06:01, Day2: 06:02, 06:03 - two frames per day from sunrise to sunset
def get_photo_series_3(date_first, date_last, path_dict, clock_start = 6, frame_per_day = 2):
    photo_series = []
    delta_start = timedelta(0, clock_start * 60 * 60)
    delta_day = timedelta(1, 0)
    delta_minute = timedelta(0, 60)
    current_date = date_first
    current_datetime = delta_start + datetime(current_date.year, current_date.month, current_date.day)
    while (current_date <= date_last):
        for _ in range(frame_per_day):
            if current_datetime in path_dict:
                photo_series.append(path_dict[current_datetime])
                current_datetime += delta_minute
        current_datetime += delta_day
        current_date = current_datetime.date()
    return photo_series


# Main - Begin
time_start = time() ###

print(photo_directory)
create_photo_list()

photo_path_list = load_photo_list()
print(len(photo_path_list))
datetime_path_dict = combine_datetime_with_path_dict(photo_path_list)
datetime_path_list = list(datetime_path_dict.items())


date_first = datetime_path_list[0][0].date()
date_last = datetime_path_list[-1][0].date()

print(date_first) ###
print(date_last) ###


photo_series = get_photo_series_3(date_first, date_last, datetime_path_dict)
print(len(photo_series)) ###
print(dumps(photo_series[:5], sort_keys=False, indent=2, ensure_ascii=False)) ###
print(dumps(photo_series[-5:], sort_keys=False, indent=2, ensure_ascii=False)) ###


photo_target_path = join(dirname(abspath(__file__)), "selected")
print(photo_target_path) ###
makedirs(photo_target_path, exist_ok=True)

for photo_source_path in photo_series:
    copy2(photo_source_path, photo_target_path)
    print(photo_source_path)


time_end = time() ###
print("\ntime costs: ", time_end - time_start)
# Main - End
