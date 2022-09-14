clc
clear all
close all
% C�lculo del BER
BitsTx=load('BitsTx.txt');%Carga del archivo de bits de transmisi�n
BitsRx=load('BitsRx.txt');%Carga del archivo de bits de recepci�n
BitsporSubportadora=4;%N�mero de bits por subportadora, modulaci�n M-QAM. 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM 
BitsTx=reshape(BitsTx,((BitsporSubportadora*100)*100),1);%Reorganizaci�n de los bits de transmisi�n en un solo vector
[numero,tasa]=biterr(BitsTx,BitsRx);%C�lculo del BER
disp(['El numero de bits errados: ',num2str(numero)])
disp(['El BER del sistema es: ',num2str(tasa)])