         function  out=reshape(in,winlength)
         %winlength in seconds
            import hp.*
            out=in;
            len=length(out.data(:));
            samplesperwin=floor(winlength*out.sampleFreq);
            nwins=floor(len/samplesperwin);
            usedata=in.data(1:nwins*samplesperwin);
            usetime=in.tvector(1:nwins*samplesperwin);
            out.data=reshape(usedata,samplesperwin,nwins);
            out.tvector=reshape(usetime,samplesperwin,nwins);
          end