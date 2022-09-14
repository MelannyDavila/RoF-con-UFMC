clc
clear all
close all
%Cálculo EVM
load('datosTx.mat')%Carga de las variables de transmisión
load('datosRx.mat')%Carga de las variables de recepción
BitsporSubportadora=4;%Número de bits por subportadora, modulación M-QAM. 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM 
EVM_RMS=comm.EVM;%Creación del objeto comm.EVM
EVM_RMS.ReferenceSignalSource="Estimated from reference constellation";%Definición del diagrama de constelación de referencia
EVM_RMS.ReferenceConstellation=qammod(0:2^BitsporSubportadora-1,2^BitsporSubportadora,'UnitAveragePower',true);%Diagrama de constelación de referencia con 2^BitsporSubportadora estados
EVM1=EVM_RMS(SimbolosEqualizadosRx);%Calculo del EVM de los símbolos de recepción
disp(['El EVM de la señal de recepcion es: ',num2str(EVM1)])
disp(['Nota: se considera como referencia un diagrama de constelacion M-QAM, con M igual a ' num2str(2^BitsporSubportadora)])