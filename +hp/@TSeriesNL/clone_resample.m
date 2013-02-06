         function out=clone_resample(in,newfreq)
            out=in;
            out.data=Band.subsample(in,newfreq);
            leng=length(out.data);
            out.tvector=Band.t_vector(newfreq,leng);
            out.nrSamples=leng;
            out.sampleFreq=newfreq;
        end