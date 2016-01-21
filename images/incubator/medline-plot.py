#!/usr/bin/env python3

import matplotlib
matplotlib.use('agg')

matplotlib.rc('text', usetex=True)
matplotlib.rc('font', family='sans-serif')
matplotlib.rc('text.latex', preamble=r"\usepackage{lmodern}")

import matplotlib.pyplot as plt
import math

def medline_stats():
    fig, ax = plt.subplots()
    fig.set_size_inches(5.5, 3.5)
    
    data = []
    curr = 0
    with open('medline-stats-new.txt') as f:
        for line in f:
            fields = line.rstrip('\n').split()
            x = int(fields[0])
            y = int(fields[1])
            curr += y
            
            if 1950 <= x <= 2015:
                data.append((x, curr))
    
    xs, ys = zip(*data)
    ys = [i / 1000000 for i in ys]
    ax.bar(xs, ys, 0.6, color='0.75', edgecolor='0.5', linewidth=0.5)
    
    trend_xs = xs
    trend_ys = [
        1.044240553e-39 * math.exp(4.618154648e-2*x)
        for x in trend_xs
    ]
    ax.plot(trend_xs, trend_ys, color='0', linewidth=2)
    
    ax.set_xlim((1945, 2020))
    ax.set_ylim((0, 26))
    
    ax.set_xlabel('Year')
    ax.set_ylabel('\# articles (in millions)')
    
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    
    ax.get_xaxis().tick_bottom()
    ax.spines['bottom'].set_linewidth(0.5)
    
    ax.tick_params(axis='y', which='both', length=0)
    ax.yaxis.grid(which='both', color='0.75', linestyle='-')
    
    ax.set_axisbelow(True)
    
    labels = list(range(1950, 2016, 5))
    ax.set_xticks([i + 0.3 for i in labels])
    ax.tick_params(axis='x', which='both', length=0)
    ax.set_xticklabels(labels, rotation=90)
    plt.tight_layout()
    
    plt.tight_layout()
    fig.savefig('../medline-stats.pdf')
    plt.close()


medline_stats()
