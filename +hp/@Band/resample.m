         function out=resample(in,newfreq)
         import hp.*
            out=in;
            out.data=resample(in.data,newfreq,in.sampleFreq);
            leng=length(out.data);
            out.tvector=Band.t_vector(newfreq,leng);
            out.nrSamples=leng;
            out.sampleFreq=newfreq;
            
        end