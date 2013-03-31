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
        eventsFile
        nrSamples
        sampleFreq
        data
        tvector
        tevents

    end
    
    methods
        %Constructor
        function wave = Band(dataFile,eventsFile)
            import hp.*
            
            
            [wave.timestamps,wave.nrBlocks,wave.nrSamples,wave.sampleFreq,wave.isContinous,wave.headerInfo]=getRawCSCTimestamps(dataFile);
            [wave.timestamps,wave.data] = getRawCSCData(dataFile, 0, wave.nrSamples, 2 );
            
            %%% time grid %%%
            wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
            
            %%%%event times%%%
            
            ts=wave.tvector(1:512:length(wave.tvector));
            
            if nargin > 1
                events = getRawTTLs(eventsFile);
                evn=events(2:end-1,1);
                wave.eventsFile=eventsFile;
                wave.tevents=interp1(wave.timestamps',ts',evn);
                
            else
                wave.eventsFile=[];
                wave.tevents=[];
                
            end
            
            %% data files %%
            wave.dir=pwd;
            wave.dataFile=dataFile;
                
        end 
       
    end % methods
    
    methods (Static)
        
        out=resample(in,newfreq) %clone object at a different sampling frequency
        out=prosoverlap(in,len,doverlap)
        out=cut(in,cut)
        out=reshape(in,winlength)
        out=indices(in,times);
        
        function ind=index(in,times)
            in=interp1(in.tvector,(1:length(in.tvector))',times);
            ind=round(in);
        end
        
        function t=t_vector(sampfreq,N)
            t=(0:1/sampfreq:(N-1)/sampfreq)';
        end
        
        plot_events(in)
        plot_data(in)
        
    end %Static methods
    
    
end  % classdef