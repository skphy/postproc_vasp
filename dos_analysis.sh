#!/bin/bash

echo "++---------------------------++"
echo "Total dos: "
echo "++---------------------------++"

ifort -o postproc_DOSCAR.x postproc_DOSCAR.f90
./postproc_DOSCAR.x
echo "Generating: TotalDos.dat and lmSiteDos.dat"

echo ""
echo "++---------------------------++"
echo "Projected dos: "
echo "++---------------------------++"
python atom_contributions.py
echo "Generating : atom_*_*.dat"
