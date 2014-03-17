classdef Band <handle
    properties(Constant)
        
    end
    
    properties (Hidden)
        timestamps
        nrBlocks
        isContinous
        
    end
    
    properties
        dir
        dataFile
        eventsFile =[]
        nrSamples
        sampleFreq
        data=[]
        adaptsdev=[]
        adaptenv=[]
        tvector=[]
        fvector=[]
        tevents=[]
        eventind=[]
        %         tspikes=[]
        %         spbinsize=[]
        %         binspikes=[]
        thresh=[]
        nChannels=1
        Channels=1
        ampGain=1
        powbands=[]
        powspec=[]
        pspecerr=[]
        spgram=[]
        
        pl=[] %current plot
        
        params=[] %for spectral computations
        headerInfo % acquisition information
        breadcrumbs=cell(1)
        file_type=[]
        argum=[]
        
    end
    
%============================== CONSTRUCTOR ===============================
    methods
        
        function wave = Band(type,varargin)
            import hp.*
            wave.file_type=type;
            wave.argum=varargin;
            
            switch type
                case 'cheetah'
                    datafile=varargin{1};
                    wave.dataFile=datafile;
                    [wave.timestamps,wave.nrBlocks,wave.nrSamples,...
                        wave.sampleFreq,wave.isContinous,wave.headerInfo]...
                        =getRawCSCTimestamps(datafile);
                    [~,dat] = getRawCSCData(datafile, 0, wave.nrSamples, 2 );
                    clear timestamp_dummy; % timestamp read with getRawCSCTimestamps(dataFile) is throwing errors; override.
                    
                    %--extract voltage scaling from headerInfo
                    scale_string=wave.headerInfo{16};
                    if  ~all(scale_string(1:11)=='-ADBitVolts')
                        error('-ADBitVolts not found')
                    else
                        wave.data=str2num(scale_string(13:end))*dat;
                    end
                    
                    %%% time grid %%%
                    
                    wave.tvector=wave.t_vector(wave.sampleFreq,wave.nrSamples);
                    
                    %%%%event times%%%
                    
                    ts=wave.tvector(1:512:length(wave.tvector));
                    
                    if size(varargin,2) > 1
                        eventsfile=varargin{2};
                        events = getRawTTLs(eventsfile);
                        evn=events(2:end-1,1);
                        wave.eventsFile=eventsfile;
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
                    
                    dat= LoadBinary(str.FileName,str.Channels,str.nChannels,...
                        str.method, str.intype, str.outtype, str.Periods);
                    
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
                    
                    %======================================================
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
            wave.breadcrumbs{1}='%start';
            
        end
%==========================================================================
%============================== METHODS ===================================
        %__________________________________________________________________
        function out=clone(in)
            out=hp.Band.copy(in);
        end
        %__________________________________________________________________
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
        
        
        %__________________________________________________________________
        function setParams(in,params)
            in.params=params;
            in.params.Fs=in.sampleFreq;
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.setParams;';
            in.breadcrumbs{length(in.breadcrumbs)+1}=evalc('in.params');
            
        end
        
        function resetPl(in)
            in.pl=[];
        end
        
        %__________________________________________________________________
        function pspectrum(this,params)
            if nargin==2
                this.params=params;
                this.breadcrumbs{length(this.breadcrumbs)+1}=evalc('this.params');
            end
            this.params.Fs=this.sampleFreq;
            [this.powspec,this.fvector,this.pspecerr]=mtspectrumc(this.data,this.params);
            this.breadcrumbs{length(this.breadcrumbs)+1}='wave.pspectrum;';
            
        end
         function hilbert(this)
           
            this.data=hilbert(this.data);
            this.breadcrumbs{length(this.breadcrumbs)+1}='hilbert transformed';
            
        end
        %__________________________________________________________________
        function plot(this,range)
            if nargin ==2
                hp.Band.Splot_data(this,range);
            else
                hp.Band.Splot_data(this);
            end
        end
        %__________________________________________________________________
        function bandpow(this,frange,frange2)  %power concentration in band frange [flow fhigh]
            if nargin==3
                hp.Band.Sbandpow(this,frange,frange2);
                this.breadcrumbs{length(this.breadcrumbs)+1}='wave.bandpow';
                this.breadcrumbs{length(this.breadcrumbs)+1}=frange;
                this.breadcrumbs{length(this.breadcrumbs)+1}=frange2;
                
            else
                hp.Band.Sbandpow(this,frange);
                this.breadcrumbs{length(this.breadcrumbs)+1}='wave.bandpow';
                this.breadcrumbs{length(this.breadcrumbs)+1}=frange;
            end
        end
        
        %__________________________________________________________________
        function plotSpec(this,lg)
            if nargin==2
                hp.Band.Splot_spect(this,lg);
            else
                hp.Band.Splot_spect(this);
            end
        end
        %__________________________________________________________________
        function resample(this,newfreq)
            hp.Band.Sresample(this,newfreq) ;
            this.breadcrumbs{length(this.breadcrumbs)+1}='wave.resample';
            this.breadcrumbs{length(this.breadcrumbs)+1}=newfreq;
            
        end
        %__________________________________________________________________
        function cut(this,cut)
            hp.Band.Scut(this,cut);
            this.breadcrumbs{length(this.breadcrumbs)+1}='wave.cut';
            this.breadcrumbs{length(this.breadcrumbs)+1}=cut;
        end
        %__________________________________________________________________
        function cutpoints(this,tinitial,Npoints)
            hp.Band.Scutpoints(this,tinitial,Npoints);
            this.breadcrumbs{length(this.breadcrumbs)+1}='wave.cutpoints';
            this.breadcrumbs{length(this.breadcrumbs)+1}=tinitial;
            this.breadcrumbs{length(this.breadcrumbs)+1}=Npoints;
            
        end
        
        %__________________________________________________________________
        function reshape(in,winlength)
            hp.Band.Sreshape(in,winlength);
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.reshape';
            in.breadcrumbs{length(in.breadcrumbs)+1}=winlength;
        end
        %__________________________________________________________________
        function reshapePoints(in,numpoints)
            hp.Band.SreshapePoints(in,numpoints);
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.reshapePoints';
            in.breadcrumbs{length(in.breadcrumbs)+1}=numpoints;
        end
        %__________________________________________________________________
        function ind=indices(in,times)
            ind=hp.Band.index(in,times);
        end
        %__________________________________________________________________
        function np=npoints(in,tim,base)
            np=hp.Band.numpoints(in,tim,base);
        end
        %__________________________________________________________________
        
        function removelines(in,Q)
            out=in;
            for k=1:size(in.powspec,2)
                out.powspec(:,k)=hp.Band.Sremovelines(in.powspec(:,k),Q.freqsin,Q.freqscut,Q.gap,Q.surround);
            end
        end
        %__________________________________________________________________
        
        function bandpass(in,pass,order)
            if nargin>2
                hp.Band.SbandpassBW(in,pass,order);
            else
                hp.Band.SbandpassBW(in,pass);
            end
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.bandpass';
            in.breadcrumbs{length(in.breadcrumbs)+1}=pass;
        end
        
        %__________________________________________________________________
        
        function bandpassFIR(in,Flow,Fhigh,order)
           
            hp.Band.SbandpassFIReqripple(in,Flow,Fhigh,order);
            
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.bandpass FIR';
            in.breadcrumbs{length(in.breadcrumbs)+1}=[Flow Fhigh order];
        end 
          %__________________________________________________________________
        
        function FIRNum(in,Num)
           
            hp.Band.SFIRNum(in,Num);
            
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.FIRNum';
            in.breadcrumbs{length(in.breadcrumbs)+1}=[Num];
        end 
        
        %__________________________________________________________________
        function highpass(in,stop,order)
            if nargin>2
                hp.Band.ShighpassBW(in,stop,order);
            else
                hp.Band.ShighpassBW(in,stop);
            end
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.highpass';
            in.breadcrumbs{length(in.breadcrumbs)+1}=stop;
        end
        %__________________________________________________________________
        function lowpass(in,stop,order)
            if nargin>2
                hp.Band.SlowpassBW(in,stop,order);
            else
                hp.Band.SlowpassBW(in,stop);
            end
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.lowpass';
            in.breadcrumbs{length(in.breadcrumbs)+1}=stop;
            
        end
        %__________________________________________________________________
        function hdfilter(in,Hd)
            hp.Band.Hdfilter(in,Hd);
            in.breadcrumbs{length(in.breadcrumbs)+1}='wave.hdfilter';
            in.breadcrumbs{length(in.breadcrumbs)+1}=Hd;
        end
        
        %_________________________________________________________________
        function out=absamp(in)
            out=in;
            out.data=abs(in.data);
            in.breadcrumbs{length(in.breadcrumbs)+1}='rectify data';

        end
        
         %_________________________________________________________________
        function out=zscoret(in)
            out=in;
            out.data=zscore(in.data);
            in.breadcrumbs{length(in.breadcrumbs)+1}='rectify data';

        end
        
        %__________________________________________________________________
        
        function out=adaptSdev(in,Nsamples)
            out=in;
            
            if nargin>1
                out.adaptsdev=hp.Band.SadaptSdev(in.data,Nsamples);
            else
                out.adaptsdev=hp.Band.SadaptSdev(in.data);
            end
            
        end
        
        %__________________________________________________________________
        function setThres(in,thresvector)
            
            in.thresh=thresvector;
            in.breadcrumbs{length(in.breadcrumbs)+1}='setThres';
            
        end  
        
         %__________________________________________________________________
        function extractEvn(in)
            
                in.eventind=find(in.data>=in.thresh);
            in.breadcrumbs{length(in.breadcrumbs)+1}='extract events';
            
        end 
        
          %__________________________________________________________________
        function ind=index(in,times)
            id=interp1(in.tvector,(1:length(in.tvector))',times);
            ind=round(id);
        end
        
        %__________________________________________________________________
        function ind=findex(in,frecs)
            id=interp1(in.fvector,(1:length(in.fvector))',frecs);
            ind=round(id);
        end
        
    end % methods
    
   
    
%==========================================================================
%========================= static methods =================================
    methods (Static)
        
        out=Sresample(in,newfreq) %clone object at a different sampling frequency
        out=Sprosoverlap(in,len,doverlap)
        out=Scut(in,cut)
        out=Scutpoints(in,tinitial,Npoints)
        out=Sreshape(in,winlength)
        out=SreshapePoints(in,numpoints)
        
        
        out=Sindices(in,times)
        out=SbandpassBW(in,pass,order)
        out=ShighpassBW(in,stop,order)
        out=SlowpassBW(in,stop,order)
        
        sdev=SadaptSdev(dat,Nsamples)
        %sdev=SadaptEnv(dat,Nsamples)
        %implement
        out=SbandpassFIR(in,pass)
        out = SbandpassFIReqripple(in,Flow,Fhigh,order)
        out=ShighpassFIR(in,stop)
        out=SlowpassFIR(in,stop)
        out=SFIRNum(in,Num);
        
        
        
        out=Hdfilter(in,Hd)
        out=Sbandpow(in,frange,frange2)
        
        
        
        out=Seventimes_to_series(times,Fs,deltaT) %temporal, modificar
        
        
        out=addchannel(in,data)
        new = copy(this)
        
        out=Sspikes2binnedData(in,binsize)
        Splot_events(in)
        Splot_data(in,range)
        Splot_spect(in,lg)
        
       dataout=Sremovelines(datain,freqsin,freqscut,gap,surround)
        
      
        %__________________________________________________________________
        function np=numpoints_pow2(in,tim)
            % tim = maximum total time
            % np (highest power of 2 that yields a data segment of at most
            % tim secs
          
            np=2^(floor(log2((tim*in.sampleFreq))));
        end
        %__________________________________________________________________
        function t=t_vector(sampfreq,N)
            t=(0:1/sampfreq:(N-1)/sampfreq)';
        end
        
        
        
    end %Static methods
    
    
end  % classdef