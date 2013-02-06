function out=chita_ripple_filter(in,Hd)
%filtra senal in.dataSamples usando objeto objeto filtro Hd
 
out=in;
out.dataSamples=filtfilthd(Hd,in.dataSamples); %importante descargar funcion filtfilthd http://www.mathworks.com/matlabcentral/fileexchange/17061-filtfilthd
out.filt=Hd; %almacena filtro utilizado en estructura de salida