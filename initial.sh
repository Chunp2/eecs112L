#!/bin/bash

echo "Beginning initialization"


source pre_compule.csh

vcom -64 -f rtl.cfg

vlog -64 -sv -f tb.cfg

vopt -64 processorTb +acc=mpr -o processorTb_opt

vsim -64 -l simulation.log -do sim.do -c processorTb_opt

vsim -view waveform.wlf
