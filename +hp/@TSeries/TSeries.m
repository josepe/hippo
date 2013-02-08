classdef TSeries < handle
    
    
    properties (Abstract)
        dir
        dataFile
        nrSamples
        sampleFreq
        data
        tvector
        
    end
    
    methods 
        %Constructor
        function tseries = TSeries(obj)

        end
        
        
    end % methods
    
    methods (Abstract)
        
         out=clone_resample(in,newfreq) %clone object at a different sampling frequency
         %out=subsample(in,newfreq)        
    end
    
    
end  % classdef