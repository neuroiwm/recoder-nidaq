classdef NIDAQRecoder
    
    
    properties
         %#ok<*PROP>
        data_acquisition
        input_daq
        list_daq
        idx_daq
        id_dev
        config = struct;
        para = struct;        
    end
    
    
    methods (Access = public)
        
        function self = NIDAQRecoder
            list_daq = daqlist;
            assert(~isempty(list_daq),'No NIDAQ found')
            self.list_daq = list_daq;
        end
        
        function self = find_daq(self)            
            if size(self.list_daq,1) == 1
                self.idx_daq = 1;
            else
                for i_daq = 1 : size(self.list_daq,1)
                    fprintf('%02d: %s\n',i_daq,self.list_daq{i_daq,2})
                end
                self.idx_daq = input('select DAQ e.g., 1->');
            end
            self.id_dev = self.list_daq{self.idx_daq,2};
            fprintf('%s was selected\n',self.id_dev);
        end
        
        function self = set_config_daq(self)
            self.config = config_daq;
        end
        
        function self = set_filename(self)
           self.para.filename = sprintf('recording_NIDAQ_%s',datestr(now,'yyyymmdd_HHMMSS'));
        end
        
        function filename = get_filename(self)
            filename = self.para.filename;
        end
        
        function num_ch = get_num_ch(self)
            num_ch = self.config.num_ch;
        end
        
        function config = get_config(self)
            config = self.config;
        end
    end
    
    
    methods (Access = public)
        
        function self = start_recording(self)
            fprintf('Start Recording\n')
            
            %%% initialize global
            global count_trl
            global time_trl
            global count_samp            
            count_trl = 0;
            time_trl = zeros(100,1); % make it large enough
            count_samp = 0;
            
            %%% set filename
            self = self.set_filename;
            
            %%% get config
            ch_input = self.get_ch_input;
            Fs = self.get_Fs;
            load_time = self.get_load_time;
            terminal_config = self.get_terminal_config;
            
            %%% set_daq
            data_acquisition = daq("ni");
            data_acquisition.Rate = Fs;
            data_acquisition.ScansAvailableFcnCount = load_time;
            
            input_daq = data_acquisition.addinput(self.id_dev,ch_input,'Voltage');
            for i_input=1:numel(input_daq)
                input_daq(i_input).TerminalConfig = terminal_config;
            end                        
            self.data_acquisition = data_acquisition;
            self.input_daq = input_daq;
            
            self = self.open_file;   
            self = self.add_listener;                              
        end
        
        function self = stop_recording(self)
            fprintf('Stop Recording\n')
            stop(self.data_acquisition)                        
            pause(0.3)
            self = self.close_file;
        end
        
        function self = start_trial(self)
            global count_samp
            global count_trl
            global time_trl
            count_trl = count_trl + 1;
            time_trl(count_trl) = count_samp;
            fprintf('Start Trial %02d \n',count_trl)
        end                      
    end
    
    
    methods (Access = private)
        
        function self = open_file(self)
            self.para.fid = fopen([self.para.filename,'.bin'],'w');
        end
        function self = close_file(self)
            self.para.fid = fclose(self.para.fid);
        end
        
        function self = add_listener(self)
            %%% start
            fcn_scan =  self.set_fcn_scan;
            disp('start');
            tic;
            self.data_acquisition.ScansAvailableFcn = fcn_scan;
            self.data_acquisition.UserData          = self;
            start(self.data_acquisition,"Continuous");
            pause(0.1)
        end        
    end
    
    
    methods (Access = private) %getter
        
        function ch_input = get_ch_input(self)
            ch_input = self.config.list_ch_input;
        end
        
        function Fs = get_Fs(self)
            Fs = self.config.Fs;
        end
        
        function load_time = get_load_time(self)
            load_time = self.config.load_time;
        end
        
        function terminal_config = get_terminal_config(self)
            terminal_config = self.config.terminal_config;
        end
    end
    
    
    methods (Static)
        
        function fcn_scan = set_fcn_scan
            fcn_scan = @(src,evt) scanData_w(src, evt);
        end
    end
end