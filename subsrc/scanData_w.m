function scanData_w(src,event)
self = src.UserData;
[data,ts]     = read(src,src.ScansAvailableFcnCount,"OutputFormat","Matrix");
global count_samp
count_samp = count_samp + numel(ts);
global BufferDaqSignal
BufferDaqSignal = [BufferDaqSignal(numel(ts)+1:end,:);[ts,data]];
%% Write
data = [ts, data]' ;
fwrite(self.para.fid,data,'double');
end