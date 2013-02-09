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

            events = getRawTTLs(eventsFile);
            [wave.timestamps,wave.nrBlocks,wave.nrSamples,wave.sampleFreq,wave.isContinous,wave.headerInfo]=getRawCSCTimestamps(dataFile);
            [wave.timestamps,wave.data] = getRawCSCData(dataFile, 0, wave.nrSamples, 2 );
            
            %%% time grid %%%
            wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
            
            %%%%event times%%%
            evn=events(2:end-1,1);
            ts=wave.tvector(1:512:length(wave.tvector));
            wave.tevents=interp1(wave.timestamps',ts',evn);            
            
            %% data files %%
            wave.dir=pwd;
            wave.dataFile=dataFile;
            wave.eventsFile=eventsFile;

        end
        
        function out=clone_resampleR(in,newfreq)
            import hp.*
            out=in;
            out.data=Band.subsample(in,newfreq);
            leng=length(out.data);
            out.tvector=Band.t_vector(newfreq,leng);
            out.nrSamples=leng;
            out.sampleFreq=newfreq; 
        end
        
        function clone_resampleRR(in,newfreq)
            import hp.*
            
            in.data=Band.subsample(in,newfreq);
            leng=length(in.data);
            in.tvector=Band.t_vector(newfreq,leng);
            in.nrSamples=leng;
            in.sampleFreq=newfreq;
        end
        
    end % methods
    
    methods (Static)
        
        out=clone_resample(in,newfreq) %clone object at a different sampling frequency
        out=subsample(in,newfreq)
        out=prosoverlap(in,len,doverlap)
        
        function t=t_vector(sampfreq,N)
            t=0:1/sampfreq:(N-1)/sampfreq;
        end
        
        plot_events(in)
        
    end
    
    
end  % classdef