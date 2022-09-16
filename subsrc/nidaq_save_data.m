%% post proc
global count_trl
global count_samp

num_ch = nidaq_recoder.get_num_ch;
name_data = nidaq_recoder.get_filename;
fid = fopen([name_data,'.bin'],'r');
data = fread(fid,[num_ch+1,Inf],'double')';
fclose(fid);
config = nidaq_recoder.get_config;
save(name_data,'data','count_samp','count_trl','config');