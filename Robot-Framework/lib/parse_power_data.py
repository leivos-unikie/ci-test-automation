# SPDX-FileCopyrightText: 2022-2024 Technology Innovation Institute (TII)
# SPDX-License-Identifier: Apache-2.0

import pandas as pd
import logging
import matplotlib.pyplot as plt


def extract_time_interval(csv_file, start_time, end_time):
    columns = ['time', 'power']
    data = pd.read_csv(csv_file, names=columns)
    interval = data.query("{} < time < {}".format(start_time, end_time))
    interval.to_csv('power_interval.csv', index=False)
    return

def generate_graph(csv_file, test_name):
    data = pd.read_csv(csv_file)
    start_time = data['time'].values[0]
    end_time = data['time'].values[data.index.max()]
    plt.figure(figsize=(20, 10))
    plt.set_loglevel('WARNING')

    # Show only hh-mm-ss part of the time at x-axis ticks
    data['time'] = data['time'].str[11:19]

    plt.ticklabel_format(axis='y', style='plain')
    plt.plot(data['time'], data['power'], marker='o', linestyle='-', color='b')
    plt.yticks(fontsize=14)

    # Show full timestamps of the beginning and the end of the plotted time interval
    plt.suptitle(f'Device power consumption {start_time} - {end_time}', fontsize=18, fontweight='bold')

    plt.title(f'During "{test_name}"', loc='center', fontweight="bold", fontsize=16)
    plt.ylabel('Power (mW)', fontsize=16)
    plt.grid(True)
    plt.xticks(data['time'], rotation=45, fontsize=14)

    # Set maximum for tick number
    plt.locator_params(axis='x', nbins=40)

    plt.savefig(f'../test-suites/power_test.png')
    return

def mean_power(csv_file):
    columns = ['time', 'power']
    data = pd.read_csv(csv_file, names=columns)
    mean_value = data['power'].mean()
    return mean_value
