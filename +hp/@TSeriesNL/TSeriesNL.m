classdef TSeriesNL < hp.TSeries
    
    
    properties 
        timestamps
        nrBlocks
        isContinous
        headerInfo
        tevents
        eventsFile
        dir
        dataFile
        nrSamples
        sampleFreq
        data
        tvector
    end
    
   
    

    methods
        

        function tseries=TSeriesNL(dataFile,eventsFile)
            
          
            import hp.*
            
            events = getRawTTLs(eventsFile);
            [tseries.timestamps,tseries.nrBlocks,tseries.nrSamples,tseries.sampleFreq,tseries.isContinous,tseries.headerInfo]=getRawCSCTimestamps(dataFile);
            [tseries.timestamps,tseries.data] = getRawCSCData(dataFile, 0, tseries.nrSamples, 2 );
            
            %%% time grid %%%
            tseries.tvector=t_vector(tseries.sampleFreq,tseries.nrSamples);
            
            %%%%event times%%%
            evn=events(2:end-1,1);
            ts=tseries.tvector(1:512:length(tseries.tvector));
            tseries.tevents=interp1(tseries.timestamps',ts',evn);
            
            %% data files %%
            tseries.dir=pwd;
            tseries.dataFile=dataFile;
            tseries.eventsFile=eventsFile;
            

            
        end
        
       
        
    end
    
end %classdef
        

    
%     methods (Static)
%         
%         out=clone_resample(in,newfreq) %clone object at a different sampling frequency
%         out=subsample(in,newfreq)
%         out=prosoverlap(in,len,doverlap)
%         plot_events(in)
%         
%     end