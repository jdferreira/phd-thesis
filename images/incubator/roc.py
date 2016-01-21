#!/usr/bin/env python3

import matplotlib
matplotlib.use('agg')

matplotlib.rc('text', usetex=True)
matplotlib.rc('font', family='sans-serif')
matplotlib.rc('text.latex', preamble=r"\usepackage{lmodern}")
matplotlib.rc('xtick', direction="out")
matplotlib.rc('ytick', direction="out")

import matplotlib.pyplot as plt

def to_floats(s):
    return tuple(float(i) for i in s.split())

with open('roc-hood3.txt') as f:
    hood3 = [to_floats(line.rstrip('\n')) for line in f]
with open('roc-hood4.txt') as f:
    hood4 = [to_floats(line.rstrip('\n')) for line in f]
with open('roc-simgic.txt') as f:
    simgic = [to_floats(line.rstrip('\n')) for line in f]

fig, ax = plt.subplots()
fig.set_size_inches(5, 5)

ax.yaxis.set_ticks_position('left')
ax.spines['left'].set_position(('outward', 8))
ax.spines['left'].set_linewidth(0.1)

ax.xaxis.set_ticks_position('bottom')
ax.spines['bottom'].set_position(('outward', 8))
ax.spines['bottom'].set_linewidth(0.1)

ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)

xs, ys = zip(*hood4)
ax.plot(xs, ys, linewidth=2, label="$\\mathrm{rel}_\\mathrm{Ferreira}(M=4)$")

xs, ys = zip(*hood3)
ax.plot(xs, ys, linewidth=2, label="$\\mathrm{rel}_\\mathrm{Ferreira}(M=3)$")

xs, ys = zip(*simgic)
ax.plot(xs, ys, linewidth=2, label="$\\mathrm{sim}_\\mathrm{GIC}$")

plt.legend(loc="lower right", frameon=False)

ax.set_xlabel('True Positive Rate')
ax.set_ylabel('False Positive Rate')
plt.tight_layout()
    
fig.savefig('../roc.pdf')
