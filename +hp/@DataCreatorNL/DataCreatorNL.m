
classdef DataCreatorNL
    
    
    
    
    methods
        

        function tseries=DataCreatorNL(dataFile,eventsFile)
            tseries=createData(dataFile,eventsFile);
             
            function tseries=createData(dataFile,eventsFile)
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
        
       
        
    end
    
end %classdef
