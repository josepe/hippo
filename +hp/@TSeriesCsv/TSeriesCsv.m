classdef TSeriesCsv < hp.TSeries
    
    
    properties 
        
        %Superclass properties
        dir
        dataFile
        nrSamples
        sampleFreq
        data
        tvector
    end
    
   
    

    methods
        

        function tseries=TSeriesCsv(csvFile)
            import hp.*
            
            tseries.nrSamples
            tseries.sampleFreq
           
            tseries.data = dataFile, 
            tseries.nrSamples;
            
            %%% time grid %%%
            tseries.tvector=t_vector(tseries.sampleFreq,tseries.nrSamples);
            
            %% data files %%
            tseries.dir=pwd;
            tseries.dataFile=dataFile;
            
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