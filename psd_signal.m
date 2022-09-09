%Funcion para graficar la densidad de potencia espectral de una señal
%x muestras en tiempo
%fs frecuencia de muestreo en segundos
%R resistencia por defecto use 1 ohm para normalizar
function [Spdx,f] = psd_signal(x,fs,R)

f=-fs/2:fs/(length(x)-1):fs/2;
Z=(fftshift(fft(x))/(length(x)));
Spdx=10*log10((abs(Z).^2)/R*1000);
figure;
f=f/1e9;
plot(f,Spdx);
xlabel('Frecuencia [GHz]')
ylabel('Potencia [dBm]')
label = '1.9 [GHz]';
y1=xline(1.9,'--',label,'linewidth',1);
y1.LabelOrientation = 'horizontal';
y1.LabelVerticalAlignment='middle';
label1 = '-1.9 [GHz]';
y2=xline(-1.9,'--',label1,'linewidth',1);
y2.LabelOrientation = 'horizontal';
y2.LabelVerticalAlignment='middle';
y2.LabelHorizontalAlignment='left';
axis([-25 25 -110 -10])