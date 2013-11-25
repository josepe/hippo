function dataout=Sremovelines(datain,freqsin,freqscut,gap,surround)

dataout=datain;
%todos las variables en 
%calcular gap en n?mero de muestras
df=freqsin(2)-freqsin(1);
npoints_gap=floor(gap/df);
npoints_surround=floor(surround/df);


%extract indices from frequencies
indices=interp1(freqsin(:),(1:length(freqsin(:)))',freqscut);
ind=round(indices);



for i=1:length(ind)
    %cleave%

    % fill gaps, interpolating
    indices_extern=[ind(i)-npoints_surround:ind(i)-npoints_gap ind(i)+npoints_gap:ind(i)+npoints_surround];
    indices_intern=(ind(i)-npoints_gap+1:ind(i)+npoints_gap-1);
    
    data_corrected= interp1(indices_extern,datain(indices_extern),indices_intern,'linear');
    dataout((ind(i)-npoints_gap+1:ind(i)+npoints_gap-1))=data_corrected;
end