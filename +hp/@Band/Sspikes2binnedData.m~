         function  out=Sspikes2binnedData(in,binsize)
         if nargin==1
             binsize=1/in.sampleFreq;
         end
            out=in;
            out.sampleFreq=1/binsize;
            len=length(in.tvector(:));
            N=floor(len*binsize/in.samplefrequency);
            out.tvector=t_vector(out.sampfreq,N);
            
            len=length(out.tvector(:));
            sp=sparse(floor(out.tspikes(:)/out.sampleFreq),1,1,len,1);
            out.data=full(sp);
           
          end