# MD run to calculate thermal expansion

#  Switch on EAM Al potential
read nial.txt

#  Set up some useful constants for this potential

calc  Ni=1
calc  Al=2
calc  MassNi=58.6943
calc  MassAl=26.982
eunit eV

#  Make box bigger to satisfy minimum image criterion
box 1 1 1

#dup  2  1 0 0
#dup  2  0 1 0
#dup  2  0 0 1
#write XMOL initial.xyz
scale A0 B0 C0

# sc can be used to scale to different volume (pressure)
bsave 10 boxlengths.dat
esave 10 energy.dat

# Give the particles masses
select type Ni
mass MassNi
select type Al
mass MassAl

# MATLAB supplies temperature, bulk modulus, time step, md steps

# scale sc
  write energy
  write box
  write nat
# write Vol
# Stress in ergs. Conv to ev: multiply with 6.241e11
  write stress
