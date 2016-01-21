#!/usr/bin/env python3

import matplotlib
matplotlib.use('agg')

matplotlib.rc('text', usetex=True)
matplotlib.rc('font', family='sans-serif')
matplotlib.rc('text.latex', preamble=r"\usepackage{lmodern}")

import matplotlib.pyplot as plt
import math

def pdb_stats():
    fig, ax = plt.subplots()
    fig.set_size_inches(5.5, 3.5)
    
    data = []
    curr = 0
    with open('pdb-stats.txt') as f:
        for line in f:
            fields = line.rstrip('\n').split()
            x = int(fields[0])
            y = int(fields[2])
            data.append((x, y))
    
    xs, ys = zip(*data)
    ys = [i / 1000 for i in ys]
    ax.bar(xs, ys, 0.6, color='0.75', edgecolor='0.5', linewidth=0.5)
    
    # # Exponential trend with linearly decaying exponent
    # k, m, b = 0.78381204484429345, -0.0047458845051429489, 0.48030313137331598
    # trend = [
    #     k / 1000 * math.exp(m * (x - 1972) * (x - 1972) + b * (x - 1972))
    #     for x in xs
    # ]
    # ax.plot(xs, trend, color='0', linewidth=2)
    
    # # Sigmoidal trend
    # L, k, x0 = 155.22876, 0.22066, 2010.83306
    # trend = [L / (1 + math.exp(-k * (x - x0))) for x in xs]
    # ax.plot(xs, trend, color='0', linewidth=2)
    
    # Regular exponential trend
    trend = [
        8.813665325E-134 * math.exp(1.544870016E-1*x)
        for x in xs
    ]
    ax.plot(xs, trend, color='0', linewidth=2)
    
    ax.set_xlim((1970, 2020))
    ax.set_ylim((0, 119))
    
    ax.set_xlabel('Year')
    ax.set_ylabel('\# PDB structures (in thousands)')
    
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    
    ax.get_xaxis().tick_bottom()
    ax.spines['bottom'].set_linewidth(0.5)
    
    ax.tick_params(axis='y', which='both', length=0)
    ax.yaxis.grid(which='both', color='0.75', linestyle='-')
    
    ax.set_axisbelow(True)
    
    labels = list(range(1975, 2016, 5))
    ax.set_xticks([i + 0.3 for i in labels])
    ax.tick_params(axis='x', which='both', length=0)
    ax.set_xticklabels(labels, rotation=90)
    plt.tight_layout()
    
    plt.tight_layout()
    fig.savefig('../pdb-stats.pdf')
    plt.close()


pdb_stats()
