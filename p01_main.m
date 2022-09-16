%% p01_main.m
%%% Author: Seitaro Iwama
%%% 2022-09-16
%% initialization
addpath('subsrc')
nidaq_recoder = NIDAQRecoder;
nidaq_recoder = nidaq_recoder.find_daq;
nidaq_recoder = nidaq_recoder.set_config_daq;
%% make_gui
nidaq_gui = NIDAQGUI;



