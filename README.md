# Minimization
 Simple matlab scripts for simulating and performing minimization for clinical trial allocation.

 Note that currently only simple weighted range minimisation without prior weighting is implemented as described in the seminal paper of Pocock and Simon [DOI ](https://doi.org/10.2307/2529712)
 
## How to use
These matlab scripts provide a simple example of how to perform minimisation. The scripts are extensively commented and easily adapted to other clinical trials.


The script "example.m" shows how to compute the minimisation allocation for 1 new patient. It is not particularly instructive on its own, but this is the script to adjust if you intend to apply minimisation in a trial.


The script "simulation.m" lets you simulate patient recruitment and allocation. It generates a patient cohort, and allocates each patient in order using minimisation and randomisation, then tallies up the trial statistics and exports to a spreadsheet. Should see pretty similar distribution between factors when minimisation is used, whereas simple randomisation can end up pretty unbalanced.
