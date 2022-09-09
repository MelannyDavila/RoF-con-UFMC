%____________________________________________________________________
%
%                    Custom Component for MATLAB
%          Automatically generated from VBS template
%
% Name         : user1_RxRoF
% Author       : DOCENTE
% Cration Date : Thu Aug 04 19:00:22 2022
%
%____________________________________________________________________
%
%                  MATLAB base workspace variables
%
% - Simulation parameters
%
% sim_technique ::= 'VBS'
%   current simulation technique ('SPT'|'VBSp'|'VBS')
%
% runs :: double vector [runs_num 1]
%   run(s) of the current CCM instance execution
%
% lower_frequency :: double number
%   VBS lower bandwidth frequency expressed in THz
%
% center_frequency :: double number
%   VBS center bandwidth frequency expressed in THz
%
% upper_frequency :: double number
%   VBS upper bandwidth frequency expressed in THz
%
% is_opt_noise :: double number
%   flag indicating if the optical noise is simulated
%
% is_elt_noise :: double number
%   flag indicating if the electrical noise is simulated
%
% polarization_mode :: double number
%   polarization representation of the optical field
%   (1 = signal, 2 = double)
%
% start_valid_samples :: double number
%   instant when a measurement component should start measuring
%   expressed in ps
%
% stop_valid_samples :: double number
%   instant when a measurement component should stop measuring
%   expressed in ps
%
% delt_ps :: double number
%   time sampling step expressed in ps
%
% num_samples :: double number
%   number of signal samples in time domain
%
% time :: double vector [num_samples 1]
%   time sample values expressed in ps
%
% - Input signals
%
% SenalRx :: double vector [num_samples 1]
%   electrical signal SenalRx time domain samples
%
%
%
%
%____________________________________________________________________

% Write MATLAB code here

in_data=SenalRx; %Designaci�n de la se�al recibida a la variable in_data

in_datafft=fft(in_data); %Operaci�n FFT
in_datafft(1)=0; %Retiro de la componente de DC
in_data=real(ifft(in_datafft));%Operaci�n IFFT

PuntosFFT = 2^19;        % Puntos FFT
TamanoSubbanda = 100;     % Tama�o de las sub-bandas, debe ser mayor a 1
NumeroSubbanda = 100;    % N�mero de sub-bandas
OffsetSubbanda = PuntosFFT/2-TamanoSubbanda*NumeroSubbanda/2; % Separaci�n entre sub-bandas
LongFiltro = 43;      % Longitud del filtro
AtenuacionLobulo = 50;     % Atenuaci�n del l�bulo latera, en decibelios

BitsporSubportadora = 2;   % Bits por subportadora, modulaci�n M-QAM. 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM

FiltroDolphC = chebwin(LongFiltro, AtenuacionLobulo);%Creaci�n del filtro Dolph-Chebyshev

in_data = SenalRx(relleno+relleno+1:end-relleno-dif);%Retiro de la se�al de relleno de ceros
SenalReferencia=zeros(length(in_data),1);  %Se�al de referencia de longitud
SenalPRBS=2*PRBS([0 1 0 1 0 1 1 ],[7 6]); %Creaci�n de la se�al de sincronismo PRBS
SenalSincronizacion=[0 SenalPRBS]; %Se�al de sincronismo
SenalReferencia(1:length(SenalSincronizacion)) = SenalSincronizacion';%Creaci�n de un vector de longitud de la se�al PRBS
SenalRectificada= in_data- mean(in_data);%Rectificaci�n de la se�al
Y1 = fft(SenalRectificada);%Operaci�n FFT de la se�al rectificada
Y2 = fft(SenalReferencia);%Operaci�n FFT de la se�al rectificada
Y = ifft(Y1.*conj(Y2));%Operaci�n Conjugada entre la FFT de la se�al rectificada
[max1, nmax1] = max(abs(Y(1:(length(Y)/2))));%Obtenci�n de los m�ximos
SincronizacionSenal = circshift(in_data, [-nmax1+1 0]);%Rectificaci�n de la se�al

SenalUFMC_Rx=SincronizacionSenal(1:numCols);%Se�al UFMC en recepci�n

SenalUFMC1= SenalUFMC_Rx(length(SenalSincronizacion):length(SenalUFMC_Rx)-21); %Retiro de la se�al PRBS y de la se�al de divisibilidad

UFMC_real=SenalUFMC1(1:length(SenalUFMC1)/2)/Amp;%Obtenci�n parte real de la se�al UFMC
UFMC_imag=SenalUFMC1(length(UFMC_real)+1:length(SenalUFMC1))/Amp;%Obtenci�n parte imaginaria de la se�al UFMC
Rx_UFMC=UFMC_real+UFMC_imag*1i;%Construcci�n de la se�al UFMC

PaddedRx = [Rx_UFMC; zeros(2*PuntosFFT-numel(Rx_UFMC),1)];% Vector con doble de puntos de la FFT

SimbolosRx2 = fftshift(fft(PaddedRx));%Operaci�n FFT
SimbolosRx = SimbolosRx2(1:2:end);%Selecci�n de las muestras pares de la se�al

SimbolosSubportadoras = SimbolosRx(OffsetSubbanda+(1:NumeroSubbanda*TamanoSubbanda));%Selecci�n de las subportadoras de datos

RxFrec = [FiltroDolphC.*exp(1i*2*pi*0.5*(0:LongFiltro-1)'/PuntosFFT);zeros(PuntosFFT-LongFiltro,1)];%Desempaquetamiento OFDM
PrototipoFiltroFrec = fftshift(fft(RxFrec)); %Ecualizador zero-forcing
PrototipoFilteroInv = 1./PrototipoFiltroFrec(PuntosFFT/2-TamanoSubbanda/2+(1:TamanoSubbanda)); %Ecualizador zero-forcing

SimbolosRxMat = reshape(SimbolosSubportadoras,TamanoSubbanda,NumeroSubbanda);%Ordenamiento de los s�mbolos de recepci�n
EqualizadosMat = bsxfun(@times,SimbolosRxMat,PrototipoFilteroInv);%Ecualizaci�n por sub-banda, erradicaci�n de la distorsi�n del filtro
SimbolosEqualizadosRx = EqualizadosMat(:);%S�mbolos ecualizados

qamDemod = comm.RectangularQAMDemodulator('ModulationOrder', ...
    2^BitsporSubportadora, 'BitOutput', true, ...
    'NormalizationMethod', 'Average power');%Demodulador M-QAM

BitsRx = qamDemod(SimbolosEqualizadosRx);%Demodulaci�n de los simbolos
save BitsRx.txt BitsRx -ascii%Registro de los bits de recepci�n
save('datosRx.mat')%Registro del workspace

%____________________________________________________________________
%
% End of file
%____________________________________________________________________
