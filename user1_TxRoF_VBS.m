%____________________________________________________________________
%
%                    Custom Component for MATLAB
%          Automatically generated from VBS template
%
% Name         : user1_TxRoF
% Author       : DOCENTE
% Cration Date : Thu Aug 04 17:55:41 2022
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
%
% - Output signals
%
% SenalTx :: double vector [num_samples 1]
%   electrical signal SenalTx time domain samples
%
%
%
%____________________________________________________________________

% Write MATLAB code here

s = rng(211);
PuntosFFT = 2^19;        % Puntos FFT
TamanoSubbanda = 100;     % Tamaño de las sub-bandas, debe ser mayor a 1
NumeroSubbanda = 100;    % Número de sub-bandas
OffsetSubbanda = PuntosFFT/2-TamanoSubbanda*NumeroSubbanda/2; % Separación entre sub-bandas
LongFiltro = 43;      % Longitud del filtro
AtenuacionLobulo = 50;     % Atenuación del lóbulo latera, en decibelios

BitsporSubportadora = 2;   % Bits por subportadora, modulación M-QAM. 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM

FiltroDolphC = chebwin(LongFiltro, AtenuacionLobulo); %Creación del filtro Dolph-Chebyshev
qamMapper = comm.RectangularQAMModulator('ModulationOrder', ...
    2^BitsporSubportadora, 'BitInput', true, ...
    'NormalizationMethod', 'Average power'); %Modulador M-QAM
VectorDatos = zeros(BitsporSubportadora*TamanoSubbanda, NumeroSubbanda);%Creacion vector de datos
SenalTx = complex(zeros(PuntosFFT+LongFiltro-1, 1));%Creación señal UFMC

TxSimb=[];%Vector para registro de simbolos 
BitsTx=[];%Vector para bits en transmisión

for IndiceSubbanda = 1:NumeroSubbanda

    BitsEntrada = randi([0 1], BitsporSubportadora*TamanoSubbanda, 1); %Bits de datos por sub-banda
    SimbolosEntrada = qamMapper(BitsEntrada);%Símbolos por sub-banda
    VectorDatos(:,IndiceSubbanda) = BitsEntrada; % Concatenación de bits en un solo vector
    TxSimb=[TxSimb SimbolosEntrada];%Símbolos transmitidos
    save BitsTx.txt VectorDatos -ascii %Registros de bits de transmisión
    
    % Empaquetamiento de datos en OFDM
    Desplazamiento = OffsetSubbanda+(IndiceSubbanda-1)*TamanoSubbanda; %Desplazamiento entre sub-bandas
    SimbolosOFDM = [zeros(Desplazamiento,1); SimbolosEntrada; ...
                     zeros(PuntosFFT-Desplazamiento-TamanoSubbanda, 1)];%Obtención de símbolos OFDM
    SalidaIFFT = ifft(ifftshift(SimbolosOFDM));%Operación IFFT

    FiltroBanda = FiltroDolphC.*exp( 1i*2*pi*(0:LongFiltro-1)'/PuntosFFT* ...
                 ((IndiceSubbanda-1/2)*TamanoSubbanda+0.5+OffsetSubbanda+PuntosFFT/2)); %Diseño filtro con desplazamiento
    SalidaFiltro = conv(FiltroBanda,SalidaIFFT);% Filtrado con Dolph-Chebyshev
    SenalTx = SenalTx + SalidaFiltro;%Senal UFMC a transmitir
end

UFMC_real=real(SenalTx)';%Obtención parte real de la señal UFMC
UFMC_imag=imag(SenalTx)';%Obtención parte imaginaria de la señal UFMC

SenalPRBS=PRBS([0 1 0 1 0 1 1 ],[7 6]);  %Creación de la señal PRBS para sincronismo
SenalSincronismo =SenalPRBS*max(abs(SenalTx))*1.5;   %Amplitud para diferenciar a la señal PRBS
Divisibilidad=zeros(21,1)'; %Garantizar divisibilidad para 8
Amplitud=80;%Factor para incrementar la amplitud de la señal a transmitir a OptSim
SenalUFMC_Tx=Amplitud*[SenalSincronismo UFMC_real UFMC_imag Divisibilidad]; % Concatenación de señales
Relleno=zeros(1,100e3); %Vector de relleno de ceros
SalidaUFMC=[Relleno Relleno SenalUFMC_Tx Relleno]; %Senal con relleno de ceros

NumeroMuestras=num_samples;%Número de muestras de OptSim
DiferenciaLongitud=NumeroMuestras-length(SalidaUFMC); %Diferencia entre la cantidad de muestras y la longitud de la señal a transmitir
SenalTx=[SalidaUFMC zeros(1,DiferenciaLongitud)];%Compensación de longitud

save('datosTx.mat')%Registro del workspace
SenalTx=SenalTx';%Envio de la señal UFMC a OptSim mediante la interfaz "SenalTx"
%____________________________________________________________________
%
% End of file
%____________________________________________________________________
