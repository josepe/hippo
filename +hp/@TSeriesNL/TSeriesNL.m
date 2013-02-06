classdef TSeriesNL < hp.TSeries
    
    
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
        function tseries = TSeriesNL(obj)
            tseries=tseries@hp.TSeries(obj);       
        end
        
        
    end % methods
    
%     methods (Static)
%         
%         out=clone_resample(in,newfreq) %clone object at a different sampling frequency
%         out=subsample(in,newfreq)
%         out=prosoverlap(in,len,doverlap)
%         plot_events(in)
%         
%     end
    
    
end  % classdef