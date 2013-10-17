classdef Band <handle
    properties(Constant)
       
    end
    
    properties (Hidden)
        timestamps
        nrBlocks
        isContinous
        headerInfo
    end
    
    properties
        dir
        dataFile
        eventsFile =[]
        nrSamples
        sampleFreq
        data=[]
        tvector=[]
        fvector=[]
        tevents=[]
        tspikes=[]
        spbinsize=[]
        binspikes=[]
        
        nChannels=1
        Channels=1
        ampGain=1
        powspec=[]
        pspecerr=[]
        spgram=[]
        
        pl=[] %current plot
        
        params=[]
    end
    
    methods
        %%Constructor
        function wave = Band(type,varargin)
            import hp.*
            
            switch type
                case 'cheetah'
                    dataFile=varargin{1};
                    wave.dataFile=dataFile;
                    [wave.timestamps,wave.nrBlocks,wave.nrSamples,wave.sampleFreq,wave.isContinous,wave.headerInfo]=getRawCSCTimestamps(dataFile);
                    [wave.timestamps,wave.data] = getRawCSCData(dataFile, 0, wave.nrSamples, 2 );
                    
                    %%% time grid %%%

                    wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
                    
                    %%%%event times%%%
                    
                    ts=wave.tvector(1:512:length(wave.tvector));
                    
                    if size(varargin,2) > 1
                        eventsFile=varargin{2};
                        events = getRawTTLs(eventsFile);
                        evn=events(2:end-1,1);
                        wave.eventsFile=eventsFile;
                        wave.tevents=interp1(wave.timestamps',ts',evn); 
                    end
                    
                case 'crcns'
                    %varargin{1} data structure
                    %varargin{2} sample frequency
                    %varargin{3} amplifier gain
                    
                    str=varargin{1};
                    wave.dataFile= str.FileName;
                    wave.Channels=str.Channels;
                    wave.nChannels=str.nChannels;
                    method=str.method;
                    intype=str.intype;
                    outtype=str.intype;
                    Periods=str.Periods;
                    %Resample=str.Resample;
                    
                    dat= LoadBinary(str.FileName,str.Channels,str.nChannels, str.method, str.intype, str.outtype, str.Periods);
                   
                    wave.data=double(dat')./2^15*200; %VERIFICAR FORMULA
                   
                    wave.sampleFreq=varargin{2};
                    
                    
                    if ~isempty(varargin{3})
                        wave.ampGain=varargin{3};
                    else wave.ampGain=1000;
                    end
                    
                    wave.nrSamples= size(wave.data,1);
                    wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
                    
                case'event_times_from_csv'  %%develop for spike times as events
                    if varargin < 2 
                        error('missing sampling frequency')
%                     else if varargin >2 error('too many arguments')
%                     
%                     else
%                     
%                         tspikes
                    end
             %   case 'events_from_dat'
                        
                        
                        
                case'spike_csv'  %%develop for spike times as events
                    wave.dataFile=varargin{2};
                    wave.sampleFreq=varargin{3};
                    op=importdata(wave.dataFile);
                    wave.tspikes=op.data;
                    if nargin >3
                        deT=varargin{4};
                        detin=deT(1);
                        deten=deT(2);
                        indices= wave.tspikes>detin & wave.tspikes<deten;
                        wave.tspikes=wave.tspikes(indices);
                    else
                        detin=0;
                        deten=wave.tspikes(end);
                    end
                    wave.tvector=detin:1/wave.sampleFreq:deten;
                    

%                 case'mat'  %load from mat file
%                     wave.dataFile=varargin{2};
%                     eval('wave.data= varargin{3}');
%                     wave.sampleFreq=varargin{4};
%                     wave.nrSamples= size(wave.data,2);
%                     wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
                    
                    %==============================================================%
                case 'ch' %load from variable in workspace
                    wave.dataFile='workspace';
                    wave.data=varargin{1};
                    wave.sampleFreq=varargin{2};
                    wave.nrSamples= size(wave.data,2);
                    wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
                    

                case 'branch'
                    % Copy all non-hidden properties.
                    this=varargin{1};
                    p = properties(this);
                    for i = 1:length(p)
                        wave.(p{i}) = this.(p{i});
                    end                   
            end
            
            
            wave.dir=pwd;
            
        end
        
        %% methods%%
        function out=clone(in)
            out=hp.Band.copy(in);
        end
        
        function str=sp(in)
            str.data=in.data;
            str.Fs=in.sampleFreq;
            str.type='vector';
            str.SPTIdentifier.type='Signal';
            str.SPTIdentifier.version='1.0';
            str.lineinfo.color= [0 0 1];
            str.lineinfo.linestyle= '-';
            str.lineinfo.columns=1;
            str.label=in.dataFile;
        end
    
            
        
        function setParams(in,params)
            in.params=params;
            in.params.Fs=in.sampleFreq;
        end
        
        function resetPl(in)
            in.pl=[];
        end
        
        
        function pspectrum(this,params)
            if nargin==2
                this.params=params;
            end 
                this.params.Fs=this.sampleFreq;
                [this.powspec,this.fvector,this.pspecerr]=mtspectrumc(this.data,this.params);
        end
        
        function plot(this,range)
            if nargin ==2
                hp.Band.Splot_data(this,range);
            else
                hp.Band.Splot_data(this);
            end
        end
        
        function plotSpec(this,lg)
            if nargin==2
                hp.Band.Splot_spect(this,lg);
            else
                hp.Band.Splot_spect(this);
            end
        end
        
        function resample(this,newfreq)
            hp.Band.Sresample(this,newfreq) ;
        end
        
        function cut(this,cut)
            hp.Band.Scut(this,cut);
        end
        
        function reshape(in,winlength)
            hp.Band.Sreshape(in,winlength);
        end
        
        function indices(in,times)
            hp.Band.index(in,times);
        end
        
        function removelines(in,freqs,Q)
            hp.Band.Sremovelines(in,freqs,Q);
        end
        
        function bandpass(in,pass)
            hp.Band.SbandpassBW8(in,pass);
        end
        
        function highpass(in,stop)
            hp.Band.ShighpassBW8(in,stop);
        end
        
        function lowpass(in,stop)
            hp.Band.SlowpassBW8(in,stop);
        end
        function hdfilter(in,Hd)
            hp.Band.Hdfilter(in,Hd);
        end
        
        
            
        
        
        
        
       
    end % methods
    
    methods (Static)
        
        out=Sresample(in,newfreq) %clone object at a different sampling frequency
        out=Sprosoverlap(in,len,doverlap)
        out=Scut(in,cut)
        out=Sreshape(in,winlength)
        out=Sindices(in,times);
        out=Sremovelines(in,freqs,Q)
        out=SbandpassBW8(in,pass)
        out=ShighpassBW8(in,stop)
        out=SlowpassBW8(in,stop)
        out=Hdfilter(in,Hd)
        
        out=Seventimes_to_series(times,Fs,deltaT) %temporal, modificar
              
        
        out=addchannel(in,data)
        new = copy(this)
        
        out=Sspikes2binnedData(in,binsize)
        
        function ind=index(in,times)
            in=interp1(in.tvector,(1:length(in.tvector))',times);
            ind=round(in);
        end
        
        function t=t_vector(sampfreq,N)
            t=(0:1/sampfreq:(N-1)/sampfreq)';
        end
        
        Splot_events(in)
        Splot_data(in,range)
        Splot_spect(in,lg)
        
    end %Static methods
    
    
end  % classdef