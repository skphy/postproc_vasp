# expand tab to space in .f90 file
expand -t 8 postproc_DOSCAR.f90 > postproc_DOSCAR_.f90


# sum of 3 rd and 4th column in a file:

awk -F" " '{x+=$3;y+=$4;print}END{print "Total "x,y}' atom1_.out

OR

awk '{x+=$1;print}END{print x}' atom1_.out     <--- will print the total of first column.

#remove files starting from OSZ*

  find . -type f -name "OSZ*"  -exec rm -f {} \;

 

  OR

  

  find . -name "filename" -exec rm -f {} \;

 

#remove directory starting from OSZ*

  find . -type d -name "OSZ*"  -exec rm -d {} \;


#find a specific dir and remove contents of that dir:

find . -type d -name 'rlx'  -exec find {} -mindepth 1 -delete \;


##python :

#how to change list entruies ...

 a[:] = [x*3 for x in a]

 

#awk_match_nubmber_n_print_that_line

for i in 3 7 11 15 18 22 26 30 36 37 41 48 49 53 60 61 65 72 73 77 ; do awk -v a=$i '$1==a {print}' FORCE.out | tee   >> FORCE_fixd.dat; done

#xmgrace, add two columns/rows of different files:

Go to DATA->transformation-> evaulate expression: first "duplicate" to create new data set (say G0.S5), then

type in Formula: s5.x=s1.y+s3.y  so this formula will add y column of set s1 and s3.

Similarly, s6.x=s1.x+s3.x for new set G0.S6

#Memory use: 

#1. cahce memory:  free -g

  for cleaning cahce:   autoclean or autoremove

#2. Hard disk menory usage: df -h

#3. wacth memory use : watch -n 1 free -m

#4. sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
