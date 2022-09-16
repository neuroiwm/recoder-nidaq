function config = config_daq
%%% write experiment config here
config = struct;

%%% sampling rate
config.Fs = 10000;

%%% set channel for illuminance sensor and EMG
ch_illum = 0;
ch_emg_rt = 1;
ch_emg_lt = 2;
config.list_ch_input = [ch_illum;ch_emg_rt;ch_emg_lt];
config.num_ch = numel(config.list_ch_input);
config.legend_ch = {'Illuminance sensor';'Right EMG';'Left EMG'};

%%% internal settings for input
config.load_time = 0.2*config.Fs;
config.terminal_config = 'SingleEnded';%'Differential';%

end



