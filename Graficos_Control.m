%Obtención de los gráficos de control presentados
%Se deben cargar los archivos SenalElectrica.txt, EspectroElectrico.txt y
% EspectroElectrico.txt. En el caso de los archivos EspectroElectrico.txt y
% EspectroElectrico.txt se deben borrar las cabeceras de los archivos 

%% Señal eléctrica
clc
clear all 
close all
load 'SenalElectrica.txt'
t=(1:1:length(ufmcout))/10e4;
plot(t(1:128),ufmcout(1:128),'Color','#D95319');
hold on
plot(t(129:end),ufmcout1(200e3+128+1:end-100e3),'Color','#0072BD')
axis([-0.1 10.7 -1 1.7])
%title('Señal transmitida')
ylabel('Amplitud [V]')
xlabel('Tiempo [ns]')

%% Espectro eléctrico
clc
clear all
close all
load 'EspectroElectrico.txt' 

%% Obtención espectro eléctrico bilateral función psd_signal
psd_signal(EspectroElectrico,0.18e12,1);

%% Obtención espectro eléctrico bilateral
Fs=0.2e12;
[a,b]=pwelch(EspectroElectrico,[],[],[],Fs,'centered','power');
figure(2)
plot(b/1e9,(10*log10(a))+45)
axis([-25 25 -80 10])
xlabel('Frecuencia [GHz]')
ylabel('Potencia [dB]')
label = '1.9 [GHz]';
y1=xline(1.9,'--',label,'linewidth',1);
y1.LabelOrientation = 'horizontal';
y1.LabelVerticalAlignment='middle';
label1 = '-1.9 [GHz]';
y2=xline(-1.9,'--',label1,'linewidth',1);
y2.LabelOrientation = 'horizontal';
y2.LabelVerticalAlignment='middle';
y2.LabelHorizontalAlignment='left';

%% Obtención espectro eléctrico unilateral
[a,b]=pwelch(EspectroElectrico);
figure(3)
plot(b*32,10*log10(a))
axis([0 25 -80 10])
xlabel('Frecuencia [GHz]')
ylabel('Potencia [dB]')
label = '1.9 [GHz]';
y1=xline(1.9,'--',label,'linewidth',1);
y1.LabelOrientation = 'horizontal';
y1.LabelVerticalAlignment='middle';

%%  Espectro óptico
load 'EspectroOptico.txt'
fmin=1.90142365722656250e+002;
fmax=1.90246354370117190e+002;
f=linspace(fmin,fmax,801);
plot(f,EspectroOptico)
axis([fmin fmax -30 45])
xlabel('Frecuencia [THz]')
ylabel('Potencia [dB]')