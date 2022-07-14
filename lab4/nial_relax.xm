# run this with "xmd al.xm > output.dat"

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

# Uncomment structure that you want

#dup  2  1 0 0
#dup  2  0 1 0
#dup  2  0 0 1

#  Scale to the unit cell length of FCC Al
scale A0 B0 C0

# sc can be used to scale to different volume (pressure)
# can come from input for MATLAB function

# Give the particles masses
select type Ni
mass MassNi
select type Al
mass MassAl

# Set adiabtic simulation at starting temperature of 200K
clamp -1
itemp 200

#  Choose MD step size
dtime  1e-15

#  Equilibrate at 200K for 500 steps
   cmd 1

#  Quench for 500 steps
   quench 1000

# scale sc
  write energy
  write box
  write nat
# write Vol
# Stress in ergs. Conv to ev: multiply with 6.241e11
  write stress
