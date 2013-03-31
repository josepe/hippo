classdef Band <handle
    properties(Constant)
       
    end
    
    properties (Hidden)
        timestamps
        nrBlocks
        isContinous
        headerInfo
    end
    
    properties
        dir
        dataFile
        eventsFile =[]
        nrSamples
        sampleFreq
        data
        tvector
        tevents=[]
        nChannels=1
        Channels=1
        ampGain=1

    end
    
    methods
        %Constructor
        function wave = Band(type,varargin)
            import hp.*
            
            switch type
                case 'cheetah'
                    dataFile=varargin{1};
                    wave.dataFile=dataFile;
                    [wave.timestamps,wave.nrBlocks,wave.nrSamples,wave.sampleFreq,wave.isContinous,wave.headerInfo]=getRawCSCTimestamps(dataFile);
                    [wave.timestamps,wave.data] = getRawCSCData(dataFile, 0, wave.nrSamples, 2 );
                    
                    %%% time grid %%%

                    wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
                    
                    %%%%event times%%%
                    
                    ts=wave.tvector(1:512:length(wave.tvector));
                    
                    if size(varargin,2) > 1
                        eventsFile=varargin{2};
                        events = getRawTTLs(eventsFile);
                        evn=events(2:end-1,1);
                        wave.eventsFile=eventsFile;
                        wave.tevents=interp1(wave.timestamps',ts',evn); 
                    end
                    
                case 'crcns'
                    %varargin{1} data structure
                    %varargin{2} sample frequency
                    %varargin{3} amplifier gain
                    
                    str=varargin{1};
                    wave.dataFile= str.FileName;
                    wave.Channels=str.Channels;
                    wave.nChannels=str.nChannels;
                    method=str.method;
                    intype=str.intype;
                    outtype=str.intype;
                    Periods=str.Periods;
                    %Resample=str.Resample;
                    
                    dat= LoadBinary(str.FileName,str.Channels,str.nChannels, str.method, str.intype, str.outtype, str.Periods);
                   
                    wave.data=double(dat')./2^15*200; %VERIFICAR FORMULA
                   
                    wave.sampleFreq=varargin{2};
                    
                    
                    if ~isempty(varargin{3})
                        wave.ampGain=varargin{3};
                    else wave.ampGain=1000;
                    end
                    
                    wave.nrSamples= size(wave.data,2);
                    wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
            end
            
            
            
            %% data files %%
            wave.dir=pwd;
            
        end
        
       
    end % methods
    
    methods (Static)
        
        out=resample(in,newfreq) %clone object at a different sampling frequency
        out=prosoverlap(in,len,doverlap)
        out=cut(in,cut)
        out=reshape(in,winlength)
        out=indices(in,times);
        out=removelines(in,freqs,Q)
        out=bandpassBW8(in,pass)
        out=highpassBW8(in,stop)
        out=lowpassBW8(in,stop)
        
        
        out=addchannel(in,data)
        
        function ind=index(in,times)
            in=interp1(in.tvector,(1:length(in.tvector))',times);
            ind=round(in);
        end
        
        function t=t_vector(sampfreq,N)
            t=(0:1/sampfreq:(N-1)/sampfreq)';
        end
        
        plot_events(in)
        plot_data(in,range)
        
    end %Static methods
    
    
end  % classdef