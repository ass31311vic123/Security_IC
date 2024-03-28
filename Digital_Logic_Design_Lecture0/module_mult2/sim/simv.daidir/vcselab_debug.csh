#!/bin/csh -f

cd /home/m112/m112061622/secureic/Digital_Logic_Design_Lecture0/module_mult2/sim

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/usr/cad/synopsys/vcs/2022.06/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

