         function out=clone_resample(in,newfreq)
            import hp.*
            out=in;
            out.data=Band.subsample(in,newfreq);
            leng=length(out.data);
            out.tvector=Band.t_vector(newfreq,leng);
            out.nrSamples=leng;
            out.sampleFreq=newfreq;
        end