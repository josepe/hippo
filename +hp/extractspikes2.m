function out=extractspikes2(in,fs)

tiempo_rechazo = 2; %tiempo rechazo interspike para deteccion, 2ms

in=in-mean(in);
umbral=5*median(abs(in)/0.6745)


pos=find(abs(in)>umbral);

kk=1;
spikestamp=[];

stamp_anterior=0;

tpo_rechazo_pts = tiempo_rechazo / 1000 * fs;

for k=1:length(pos);
    valor=abs(in(pos(k)));
    anterior=abs(in(pos(k)-1));
    posterior=abs(in(pos(k)+1));
    
    if (valor>anterior)&&(valor>posterior)&&(pos(k)>(tpo_rechazo_pts+stamp_anterior))
        spikestamp(kk)=pos(k);
        kk=kk+1;
        stamp_anterior=pos(k);
    end
        
    %if (abs(s_ne(pos(k))/1000)>abs(s_ne(pos(k)-1)))&&(abs(s_ne(pos(k))/1000)>abs(s_ne(pos(k)+1)))
%     if ((s_ne(pos(k))/1000)>(s_ne(pos(k)-1)))&&((s_ne(pos(k))/1000)>(s_ne(pos(k)+1)))
%         spikestamp(kk)=pos(k);
%         kk=kk+1;
%     end    
end
out=spikestamp;

end