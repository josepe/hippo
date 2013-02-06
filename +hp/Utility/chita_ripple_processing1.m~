function out=chita_ripple_processing1(params)
% carga datos a matlab desde formato neuralynx
% 
% outputs en segundos
% out.times tiempos de 
% out.t_events
% out.dataSamples datos
% out.sampleFreq

% parameters estructura:
% params.dir directorio archivo de eventos y datos
% params.eventfile directorio y nombre del archivo de eventos
% params.datafile directorio y nombre de archivo de datos

datafile=[params.dir '/' params.datafile];
eventfile=[params.dir '/' params.eventfile];

%cargar metadatos de header
[timestamps,nrBlocks,nrSamples,sampleFreq,isContinous,headerInfo]=getRawCSCTimestamps(datafile);

%cargar datos
[timestamps,dataSamples] = getRawCSCData( params.datafile, 0, nrSamples, 2 );

%cargar eventos
events = getRawTTLs(eventfile);
%se eliminan la segunda columna y el primer y ?ltimo elemento de la primera
evn=events(2:end-1,1);

% crear vector tiempos de muestreo
times=0:1/sampleFreq:(length(dataSamples)-1)/sampleFreq;
out.times=times';
ts=times([1:512:length(times)]);
out.t_events=interp1(timestamps',ts',evn);
out.dataSamples=dataSamples;
out.sampleFreq=sampleFreq;