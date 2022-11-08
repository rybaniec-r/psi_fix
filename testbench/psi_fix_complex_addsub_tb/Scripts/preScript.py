import sys
sys.path.append("../../../model")
import numpy as np
from psi_fix_pkg import *
from psi_fix_complex_addsub import psi_fix_complex_addsub
from matplotlib import pyplot as plt
import scipy.signal as sps
import os

STIM_DIR = os.path.dirname(os.path.abspath(__file__)) + "/../Data"
RAND_SAMPLES = 10000

PLOT_ON = False

try:
    os.mkdir(STIM_DIR)
except FileExistsError:
    pass

#############################################################
# Simulation
#############################################################
inAFmt = psi_fix_fmt_t(1, 0, 15)
inBFmt = psi_fix_fmt_t(1, 0, 15)
outFmt = psi_fix_fmt_t(1, 0, 15)

sigRot = np.exp(2j*np.pi*np.linspace(0, 1, 360))*0.99
sigRamp = np.linspace(0.5, 0.9, 360)
sigRandA = (np.random.rand(RAND_SAMPLES)+1j*np.random.rand(RAND_SAMPLES))*2-1-1j
sigRandB = (np.random.rand(RAND_SAMPLES)+1j*np.random.rand(RAND_SAMPLES))*2-1-1j

sigA = np.concatenate((sigRot, sigRamp, sigRandA))
sigB = np.concatenate((sigRamp, sigRot, sigRandB))

sigAI = psi_fix_from_real(sigA.real, inAFmt, err_sat=False)
sigAQ = psi_fix_from_real(sigA.imag, inAFmt, err_sat=False)
sigBI = psi_fix_from_real(sigB.real, inAFmt, err_sat=False)
sigBQ = psi_fix_from_real(sigB.imag, inAFmt, err_sat=False)

addsub = psi_fix_complex_addsub(inAFmt, inBFmt, outFmt, psi_fix_rnd_t.round, psi_fix_sat_t.sat)
addResI, addResQ = addsub.Process(sigAI, sigAQ, sigBI, sigBQ, 1)
subResI, subResQ = addsub.Process(sigAI, sigAQ, sigBI, sigBQ, 0)

#############################################################
# Write Files for Co sim
#############################################################
np.savetxt(STIM_DIR + "/input.txt",
           np.column_stack((psi_fix_get_bits_as_int(sigAI, inAFmt),
                            psi_fix_get_bits_as_int(sigAQ, inAFmt),
                            psi_fix_get_bits_as_int(sigBI, inBFmt),
                            psi_fix_get_bits_as_int(sigBQ, inBFmt))),
           fmt="%i", header="ai aq bi bq")
np.savetxt(STIM_DIR + "/output_add.txt",
           np.column_stack((psi_fix_get_bits_as_int(addResI, outFmt),
                            psi_fix_get_bits_as_int(addResQ, outFmt))),
           fmt="%i", header="result-I result-Q")


np.savetxt(STIM_DIR + "/output_sub.txt",
           np.column_stack((psi_fix_get_bits_as_int(subResI, outFmt),
                            psi_fix_get_bits_as_int(subResQ, outFmt))),
           fmt="%i", header="result-I result-Q")

#############################################################
# Plot (if required)
#############################################################
if PLOT_ON:
    plt.figure()
    plt.plot(addResI, addResQ)
    plt.figure()
    plt.plot(addResI, 'b')
    plt.plot(addResQ, 'r')
    plt.show()