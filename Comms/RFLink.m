function out = RFLink(mode,varargin)
% RFLink.m
% Use : out =
% RFLink('Margin/EbN0','Pt',0,'Gt',0,'Gr',0,'f',3e9,'L',0,'h',1000,'T',600,'Rb',1e6,'Eb/N0_min',12,'L_Impl',0,'eps_min',10)
% Margin = Eb/N0 - Eb/N0_min - L_impl
% Eb/N0 = Pt+Gt+Gr+20log(lambda/4*PI*R^2)+L-10log(k*T*Rb)
% 11 parameters: 10 inputs and 1 output
% Possible outputs: 
%                   1 - Margin/EbN0
%                   2 - PtdB/PtW
%                   3 - Gt/Dt
%                   4 - Gr/Dr
%                   5 - Rb/B
% NOTE : All inputs are in dB except for D, T, Rb.

k = 1.38e-23;

% if nargin ~= 23 || nargin ~= 20
%     disp(['error nargin = ' nargin]);
%     return
% end
%%Names = char(zeros((nargin-1)/2,1));
Values = zeros((nargin-1)/2,1);

for i = 2:2:nargin-1
    j = i/2;
    tmp = sprintf('%s',varargin{i-1}); 
    Names(j).name = tmp; 
    Values(j) = varargin{i};
end
epsmin = SearchParam('eps_min',Names,Values);

if strcmp(mode,'Margin/EbN0')
    % Inputs
    f = SearchParam('f',Names,Values);
    lambda = 3e8/f;
    Pt = SearchParam('Pt',Names,Values);
    Gt = SearchParam('Gt',Names,Values);
    if Gt == -1
        Dt = SearchParam('Dt',Names,Values);
        Gt = Diameter2Gain(Dt,f/1e9);
    end
    
    Gr = SearchParam('Gr',Names,Values);
    if Gr == -1
        Dr = SearchParam('Dr',Names,Values);
        Gr = Diameter2Gain(Dr,f/1e9);
    end
    

    h = SearchParam('h',Names,Values);
    if h == -1
        R = 1000*SearchParam('R',Names,Values);
    else
        R = CalcRange(h,epsmin);
    end
    
    L = SearchParam('L',Names,Values);
    T = SearchParam('T',Names,Values);
    Rb = SearchParam('Rb',Names,Values);
    EbN0_min = SearchParam('Eb/N0_min',Names,Values);
    L_Impl = SearchParam('L_Impl',Names,Values);
    
    % Internal calculations
    EbN0 = Pt+Gt+Gr+2*lin2dB(lambda/(4*pi*R))+L-lin2dB(k*T*Rb);
    
    % Output
    Margin = EbN0 - EbN0_min - L_Impl;
    out = Margin;
    
elseif strcmp(mode,'PtdB/PtW')
    f = SearchParam('f',Names,Values);
    lambda = 3e8/f;
    Gt = SearchParam('Gt',Names,Values);
    if Gt == -1
        Dt = SearchParam('Dt',Names,Values);
        Gt = Diameter2Gain(Dt,f/1e9);
    end
    Gr = SearchParam('Gr',Names,Values);
    if Gr == -1
        Dr = SearchParam('Dr',Names,Values);
        Gr = Diameter2Gain(Dr,f/1e9);
    end
 

    h = SearchParam('h',Names,Values);
    %Calculate R as a function of h
    if h == -1
        R = 1000*SearchParam('R',Names,Values);
        if R < 0
            R=1000*SearchParam('Dmax',Names,Values);
        end
    else
        R = CalcRange(h,epsmin);
    end

    L = SearchParam('L',Names,Values);
    T = SearchParam('T',Names,Values);
    Rb = SearchParam('Rb',Names,Values);
    EbN0_min = SearchParam('Eb/N0_min',Names,Values);
    Margin = SearchParam('Margin',Names,Values);
    L_Impl = SearchParam('L_Impl',Names,Values);

    % Internal calculations
    EbN0 = Margin + EbN0_min + L_Impl;
  
    % Output
    Pt = EbN0+lin2dB(k*T*Rb)-(Gt+Gr+2*lin2dB(lambda/(4*pi*R))+L);
    out = Pt;

elseif strcmp(mode,'Gt/Dt')
    f = SearchParam('f',Names,Values);
    lambda = 3e8/f;
    Pt = SearchParam('Pt',Names,Values);
    Gr = SearchParam('Gr',Names,Values);
    T = SearchParam('T',Names,Values);
    if T==-1
        GainToNoise = SearchParam('GainToNoise',Names,Values);
        T=100;
        Gr=GainToNoise*T;
    else
        if Gr == -1
            Dr = SearchParam('Dr',Names,Values);
            Gr = Diameter2Gain(Dr,f/1e9);
        end
    end

    h = SearchParam('h',Names,Values);
    if h == -1
        R = 1000*SearchParam('R',Names,Values);
    else
        R = CalcRange(h,epsmin);
    end

    L = SearchParam('L',Names,Values);
    Rb = SearchParam('Rb',Names,Values);
    EbN0_min = SearchParam('Eb/N0_min',Names,Values);
    Margin = SearchParam('Margin',Names,Values);
    L_Impl = SearchParam('L_Impl',Names,Values);

    % Internal calculations
    EbN0 = Margin + EbN0_min + L_Impl;
  
    % Output
    Gt = EbN0+lin2dB(k*T*Rb)-(Pt+Gr+2*lin2dB(lambda/(4*pi*R))+L);
    if Gt < 0
        Gt = 0;
    end
    out = Gt;
    
elseif strcmp(mode,'Gr/Dr')
    f = SearchParam('f',Names,Values);
    lambda = 3e8/f;
    Pt = SearchParam('Pt',Names,Values);
    Gt = SearchParam('Gt',Names,Values);
    T = SearchParam('T',Names,Values);

    if Pt==-1
        EIRP = SearchParam('EIRP',Names,Values);
        Pt=10;
        Gt=EIRP-Pt;
    else
        if Gt == -1
            Dr = SearchParam('Dr',Names,Values);
            Gt = Diameter2Gain(Dr,f/1e9);
        end
    end
    if Gt == -1
        Dt = SearchParam('Dt',Names,Values);
        Gt = Diameter2Gain(Dt,f/1e9);
    end

    h = SearchParam('h',Names,Values);
    if h == -1
        R = 1000*SearchParam('R',Names,Values);
    else
        R = CalcRange(h,epsmin);
    end

    L = SearchParam('L',Names,Values);
    Rb = SearchParam('Rb',Names,Values);
    EbN0_min = SearchParam('Eb/N0_min',Names,Values);
    Margin = SearchParam('Margin',Names,Values);
    L_Impl = SearchParam('L_Impl',Names,Values);
    
    % Internal calculations
    EbN0 = Margin + EbN0_min + L_Impl;
  
    % Output
    Gr = EbN0+lin2dB(k*T*Rb)-(Pt+Gt+2*lin2dB(lambda/(4*pi*R))+L);
    if Gr < 0
        Gr = 0;
    end
    out = Gr;

elseif strcmp(mode,'Rb/B')
    
    f = SearchParam('f',Names,Values);
    lambda = 3e8/f;
    Pt = SearchParam('Pt',Names,Values);
    Gt = SearchParam('Gt',Names,Values);
    if Gt == -1
        Dt = SearchParam('Dt',Names,Values);
        Gt = Diameter2Gain(Dt,f/1e9);
    end
    Gr = SearchParam('Gr',Names,Values);
    if Gr == -1
        Dr = SearchParam('Dr',Names,Values);
        Gr = Diameter2Gain(Dr,f/1e9);
    end

    h = SearchParam('h',Names,Values);
    if h == -1
        R = 1000*SearchParam('R',Names,Values);
    else
        R = CalcRange(h,epsmin);
    end

    L = SearchParam('L',Names,Values);
    T = SearchParam('T',Names,Values);
    EbN0_min = SearchParam('Eb/N0_min',Names,Values);
    Margin = SearchParam('Margin',Names,Values);
    L_Impl = SearchParam('L_Impl',Names,Values);
    
    % Internal calculations
    EbN0 = Margin + EbN0_min + L_Impl;
    
    tmp= Pt+Gt+Gr+2*lin2dB(lambda/(4*pi*R))+L-EbN0; % tmp = 10*log10(k*T*Rb);
    
    % Output
    Rb = dB2lin(tmp)/(k*T);
    out = Rb;
  
else
    disp('error: Possible modes are Margin/EbN0, PtdB/PtW, Gt/Dt, Gr/Dr and Rb/B');
    return
end

return


