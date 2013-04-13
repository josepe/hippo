         function  out=Sevent_reshape(in,winlength)
         %winlength in seconds
            import hp.*
            % deltaT [tmin tmax] in seconds
            % default tmin = 0 ; tmax = in(end)
            out=in;
            len=length(out.tvector(:));
            %assumes not two spikes in a sample point (dependent on Fs
            % returns sparse matrix
            %assumes not two spikes in a sample point (dependent on Fs)
            sp=sparse(out.events(:),1,1,len,1);
            %reshape
 

            % data in seconds
            % create sparse matrix @ Fs sampling rate
            
            
            samplesperwin=floor(winlength*out.sampleFreq);
            nwins=floor(len/samplesperwin);
            usespikes=sp(1:nwins*samplesperwin);
            usetime=in.tvector(1:nwins*samplesperwin);
            out.events=reshape(usespikes,samplesperwin,nwins);
            out.tvector=reshape(usetime,samplesperwin,nwins);
          end