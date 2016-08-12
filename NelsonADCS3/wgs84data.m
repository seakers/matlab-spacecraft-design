function wgs84data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                function wgs84data
%% This script provides global conversion factors and WGS 84 constants
%% that may be referenced by subsequent MatLab script files and functions.
%% Note these variables are case-specific and must be referenced as such.
%%
%% The function must be called once in either the MatLab workspace or from a
%% main program script or function. Any function requiring all or some of the
%% variables defined must be listed in a global statement as follows,
%%
%%  global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ...
%%         EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
%%
%% in part or in its entirety. Order is not relevent. Case is.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       Originally written by Capt Dave Vallado
%%       Modified and Extended for Ada by Dr Ron Lisowski
%%       Extended from DFASMath.adb by Thomas L. Yoder, LtCol, Spring 00
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined

%%  Degrees and Radians
      Deg=180.0/pi;  					%% deg/rad
      Rad= pi/180.0; 					%% rad/deg

%%  Earth Characteristics from WGS 84 
      MU=398600.5; 						%% km^3/sec^2
      RE=6378.137; 						%% km
      OmegaEarth=0.000072921151467;     %% rad/sec
      SidePerSol=1.00273790935;  	    %% Sidereal Days/Solar Day
      RadPerDay=6.30038809866574;    	%% rad/day
      SecDay=86400.0;  					%% sec/day
      Flat=1.0/298.257223563;			%%
      EEsqrd=(2.0-Flat)*Flat;
      EEarth=sqrt(EEsqrd);
      J2= 0.00108263;
      J3=-0.00000254;
      J4=-0.00000161;

%%  Moon & Sun Characteristics from WGS 84 
      GMM= 4902.774191985;				%% km^3/sec^2
      GMS= 1.32712438E11; 				%% km^3/sec^2
      AU=  149597870.0;   				%% km

%%  HALFPI,PI2           PI/2, & 2PI in various names
      HalfPI= pi/2.0;
      TwoPI= 2.0*pi;

      Zero_IE  = 0.015;                 %% Small number for incl & ecc purposes
      Small    = 1.0E-6;                %% Small number used for tolerance purposes
      Undefined= 999999.1;
