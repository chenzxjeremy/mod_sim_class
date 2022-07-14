# run this with "xmd al.xm > output.dat"

#  Switch on EAM Al potential
read nbal.txt

#  Set up some useful constants for this potential
calc  Al=2
calc  MassAl=26.982
eunit eV

#  Form diamond unit cell
box 6 6 6

# Uncomment structure that you want
#read si_hcp.dat

dup  5  1 0 0
dup  5  0 1 0
dup  5  0 0 1

#  Scale to the unit cell length of FCC Al
scale A0 B0 C0

# sc can be used to scale to different volume (pressure)
# can come from input for MATLAB function

# Give the particles masses
select type Al
mass MassAl

# scale sc
  write energy
  write box
  write nat
# write Vol
# Stress in ergs. Conv to ev: multiply with 6.241e11
  write stress
  write particle
