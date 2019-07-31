#!/usr/bin/python

# To read the lmSiteDos.dat file ... and then write
# the atom contributions in different txt files..

# Author : SK
# Date: 9 April 2014

import os
import sys
from datetime import date
import numpy as np
from numpy import *
import math
import copy

print "Current directory is:", os.getcwd()
#print "File to be processed:", sys.argv
#sys.stderr.write('Warning: \n')

atom=raw_input('Enter the total number of atoms is your simulation cell:\n')
#atom=2
atoms=int(atom)
print 'no. of atoms are: ', atoms

#ispin=1
spin=raw_input('Enter the spin: no-spin -->1 : with spin --> 2\n')
ispin=int(spin)
print 'Entered spin is:', ispin

# open dat file
filee = open('lmSiteDos.dat','r')

#data_content = filee.readlines() #[3:ndospt]

# E s p_y p_z p_x 3d_xy 3d_yz 3d_z2 3d_xz 3d_x2y2 f1 f2 f3 f4 f5 f6 f7 

for j in range(atoms):
	#3 lines
	ln1=filee.readline()
	ln2=filee.readline()
	l=ln2.split()
	print l[1], l[2], l[3], l[5]
	ndospts=int(l[3])
	ln3=filee.readline()	

	if ispin == 1:	
		energy = np.zeros(ndospts)
	
		s = np.zeros(ndospts)
	
		p_y = np.zeros(ndospts);p_z = np.zeros(ndospts);p_x = np.zeros(ndospts)

		d_xy = np.zeros(ndospts);d_yz = np.zeros(ndospts);d_z2 = np.zeros(ndospts);\
		d_xz= np.zeros(ndospts);d_x2y2= np.zeros(ndospts)

		for i in range(ndospts):

			line=filee.readline()			
			split_data = line.split()	

			energy[i]=float(split_data[0])
			
			s[i] = float(split_data[1])
		
			p_y[i] = float(split_data[2]);p_z[i] = float(split_data[3]);\
			p_x[i] = float(split_data[4])	
			
			d_xy[i] = float(split_data[5]);	d_yz[i] = float(split_data[6]);\
			d_z2[i] = float(split_data[7]);	d_xz[i] = float(split_data[8]);\
			d_x2y2[i] = float(split_data[9])

			#For Check: correct
			#print energy[i], s[i], p_y[i] , p_z[i], p_z[i], d_xy[i], d_yz[i],\
			#d_z2[i], d_xz[i], d_x2y2[i]

#		a=l[5]
#		print energy
#		print "s", type(energy)
#		a = open("atom_" + str(j) + ".dat", 'w+')	

		stacking=np.vstack((energy, s, p_y, p_z, p_x, d_xy, d_yz, d_z2, d_xz, d_x2y2))
#		print stacking
#		.T for getting column form of data
		savetxt("atom_" + str(j+1) + ".dat",stacking.T, fmt='%9.5f')

#		summing arrays elements (i.e. sum of 'py,pz,px',' dxy ..') to get p_total d_total and so on ..
		p_sum = (p_y + p_z + p_x)
		d_sum = (d_xy + d_yz + d_z2 + d_xz + d_x2y2)
#		print 'psum', p_sum
		stacking_pd_sum=np.vstack((energy, p_sum, d_sum))
		savetxt("atom_" + str(j+1) + "_pd_sum.dat",stacking_pd_sum.T, fmt='%9.5f')

		seclline=filee.readline()
		lastline=filee.readline()	
#		print 'for atom no:', l[5]

	if ispin == 2:
		energy = np.zeros(ndospts)
	
		s_up = np.zeros(ndospts); s_dn = np.zeros(ndospts)
		
		p_y_up=np.zeros(ndospts);p_z_up=np.zeros(ndospts);p_x_up=np.zeros(ndospts)
		p_y_dn=np.zeros(ndospts);p_z_dn=np.zeros(ndospts);p_x_dn=np.zeros(ndospts)
		
		d_xy_up=np.zeros(ndospts);d_yz_up=np.zeros(ndospts);d_z2_up=np.zeros(ndospts);\
		d_xz_up=np.zeros(ndospts);d_x2y2_up=np.zeros(ndospts)
		d_xy_dn=np.zeros(ndospts);d_yz_dn=np.zeros(ndospts);d_z2_dn=np.zeros(ndospts);\
		d_xz_dn=np.zeros(ndospts);d_x2y2_dn=np.zeros(ndospts)
	
		for i in range(ndospts):
			line=filee.readline()			
			split_data = line.split()	
			energy[i]=float(split_data[0])
#			print "en:", energy[i]
#						
			s_up[i] = float(split_data[1])
			s_dn[i] = float(split_data[2])		
	
			p_y_up[i] = float(split_data[3]);p_z_up[i] = float(split_data[4]);\
			p_x_up[i] = float(split_data[5])	
			p_y_dn[i] = float(split_data[6]);p_z_dn[i] = float(split_data[7]);\
			p_x_dn[i] = float(split_data[8])		
			
			d_xy_up[i] = float(split_data[9]);d_yz_up[i] = float(split_data[10]);\
			d_z2_up[i] = float(split_data[11]);d_xz_up[i] = float(split_data[12]);\
			d_x2y2_up[i] = float(split_data[13])
	
			d_xy_dn[i] = float(split_data[14]);d_yz_dn[i] = float(split_data[15]);\
			d_z2_dn[i] = float(split_data[16]);d_xz_dn[i] = float(split_data[17]);\
			d_x2y2_dn[i] = float(split_data[18])
				
			print energy[i], s_up[i], s_dn[i], \
			p_y_up[i] , p_z_up[i], p_x_up[i],\
			p_y_dn[i] , p_z_dn[i], p_x_dn[i],\
			d_xy_up[i], d_yz_up[i], d_z2_up[i], d_xz_up[i], d_x2y2_up[i],\
			d_xy_dn[i], d_yz_dn[i], d_z2_dn[i], d_xz_dn[i], d_x2y2_dn[i],
			
		stacking_up=np.vstack((energy, s_up, p_y_up, p_z_up, p_x_up, d_xy_up, d_yz_up, \
		d_z2_up, d_xz_up, d_x2y2_up))
		stacking_dn=np.vstack((energy, s_dn, p_y_dn, p_z_dn, p_x_dn, d_xy_dn, d_yz_dn, \
		d_z2_dn, d_xz_dn, d_x2y2_dn))		

#		print "ssss"		

#		print stacking  
		savetxt("atom_" + str(j+1) + "_up.dat",stacking_up.T, fmt='%9.5f')  
		savetxt("atom_" + str(j+1) + "_dn.dat",stacking_dn.T, fmt='%9.5f')
		
#		summing arrays elements(i.e. sum of 'py_up,pz_up,px_up',' dxy_up ..') to get p-up_total 
#		d-up_total and so on ..
		p_sum_up = (p_y_up + p_z_up + p_x_up)
		d_sum_up = (d_xy_up + d_yz_up + d_z2_up + d_xz_up + d_x2y2_up)
		stacking_pd_sum_up=np.vstack((energy, p_sum_up, d_sum_up))
		savetxt("atom_" + str(j+1) + "_pd_sum_up.dat",stacking_pd_sum_up.T, fmt='%9.5f')	

#		similarly for down states
		p_sum_dn = (p_y_dn + p_z_dn + p_x_dn)
		d_sum_dn = (d_xy_dn + d_yz_dn + d_z2_dn + d_xz_dn + d_x2y2_dn)
		stacking_pd_sum_dn=np.vstack((energy, p_sum_dn, d_sum_dn))
		savetxt("atom_" + str(j+1) + "_pd_sum_dn.dat",stacking_pd_sum_dn.T, fmt='%9.5f')	
				
		seclline=filee.readline()
		lastline=filee.readline()	
#		print 'for atom no:', l[5]
	
print '\nClosing file .. in directroy', os.getcwd()
filee.close()			
print ' ...done'
	
