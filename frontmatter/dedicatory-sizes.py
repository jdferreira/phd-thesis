#!/usr/bin/env python3

import sys

no_lines = 11
start_line = 240.0
end_line = 98.66615

step = (start_line - end_line) / (no_lines - 1)

print("\\parshape={}".format(no_lines))
for i in range(no_lines):
    line_width = start_line - i * step
    indent = (start_line - line_width) / 2
    print("{:8.5f}pt {:8.5f}pt".format(indent, line_width))

