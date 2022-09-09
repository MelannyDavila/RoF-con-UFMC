%Obtenci�n de los gr�ficos de control presentados
%Se deben cargar los archivos SenalElectrica.txt, EspectroElectrico.txt y
% EspectroElectrico.txt. En el caso de los archivos EspectroElectrico.txt y
% EspectroElectrico.txt se deben borrar las cabeceras de los archivos 

%% Se�al el�ctrica
clc
clear all 
close all
load 'SenalElectrica.txt'
t=(1:1:length(ufmcout))/10e4;
plot(t(1:128),ufmcout(1:128),'Color','#D95319');
hold on
plot(t(129:end),ufmcout1(200e3+128+1:end-100e3),'Color','#0072BD')
axis([-0.1 10.7 -1 1.7])
%title('Se�al transmitida')
ylabel('Amplitud [V]')
xlabel('Tiempo [ns]')

%% Espectro el�ctrico
clc
clear all
close all
load 'EspectroElectrico.txt' 

%% Obtenci�n espectro el�ctrico bilateral funci�n psd_signal
psd_signal(EspectroElectrico,0.18e12,1);

%% Obtenci�n espectro el�ctrico bilateral
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

%% Obtenci�n espectro el�ctrico unilateral
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

%%  Espectro �ptico
load 'EspectroOptico.txt'
fmin=1.90142365722656250e+002;
fmax=1.90246354370117190e+002;
f=linspace(fmin,fmax,801);
plot(f,EspectroOptico)
axis([fmin fmax -30 45])
xlabel('Frecuencia [THz]')
ylabel('Potencia [dB]')