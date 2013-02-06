
classdef DataCreatorCsv < hp.DataCreator
   
    methods 
        function tseries=createData(dataFile)
            
            import hp.*
            tseries.nrSamples=size(tseries.data,2);
            tseries.tvector=t_vector(tseries.sampleFreq,tseries.nrSamples);
            tseries.dir=pwd;
            tseries.dataFile=dataFile; 
        end
    end
end
