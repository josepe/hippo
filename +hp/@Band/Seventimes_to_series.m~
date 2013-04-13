         function  out=Seventimes_to_series(times,Fs,deltaT)
         %winlength in seconds
            import hp.*
            % deltaT [tmin tmax] in seconds
            % default tmin = 0 ; tmax = in(end)
            % returns sparse matrix
            samples=round(times*Fs); %assumes not two spikes in a sample point (dependent on Fs)
            out=sparse(samples,1,1,ceil(deltaT(2)*Fs),1);
            %reshape
            out=reshape(out,
 
          
            
%             out=in;
%             len=length(out.data(:));
%             samplesperwin=floor(winlength*out.sampleFreq);
%             nwins=floor(len/samplesperwin);
%             usedata=in.data(1:nwins*samplesperwin);
%             usetime=in.tvector(1:nwins*samplesperwin);
%             out.data=reshape(usedata,samplesperwin,nwins);
%             out.tvector=reshape(usetime,samplesperwin,nwins);
          end