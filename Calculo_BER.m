clc
clear all
close all
% Cálculo del BER
BitsTx=load('BitsTx.txt');%Carga del archivo de bits de transmisión
BitsRx=load('BitsRx.txt');%Carga del archivo de bits de recepción
BitsporSubportadora=4;%Número de bits por subportadora, modulación M-QAM. 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM 
BitsTx=reshape(BitsTx,((BitsporSubportadora*100)*100),1);%Reorganización de los bits de transmisión en un solo vector
[numero,tasa]=biterr(BitsTx,BitsRx);%Cálculo del BER
disp(['El numero de bits errados: ',num2str(numero)])
disp(['El BER del sistema es: ',num2str(tasa)])