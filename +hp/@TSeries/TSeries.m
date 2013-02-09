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
        
        function clone_resample(in,newfreq)
            import hp.*
            in.data=subsample(in,newfreq);
            leng=length(in.data);
            in.tvector=t_vector(newfreq,leng);
            in.nrSamples=leng;
            in.sampleFreq=newfreq;
        end
        
        
    end % methods
    
    
    
    
end  % classdef