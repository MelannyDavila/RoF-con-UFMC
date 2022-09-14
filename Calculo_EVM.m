clc
clear all
close all
%C�lculo EVM
load('datosTx.mat')%Carga de las variables de transmisi�n
load('datosRx.mat')%Carga de las variables de recepci�n
BitsporSubportadora=4;%N�mero de bits por subportadora, modulaci�n M-QAM. 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM 
EVM_RMS=comm.EVM;%Creaci�n del objeto comm.EVM
EVM_RMS.ReferenceSignalSource="Estimated from reference constellation";%Definici�n del diagrama de constelaci�n de referencia
EVM_RMS.ReferenceConstellation=qammod(0:2^BitsporSubportadora-1,2^BitsporSubportadora,'UnitAveragePower',true);%Diagrama de constelaci�n de referencia con 2^BitsporSubportadora estados
EVM1=EVM_RMS(SimbolosEqualizadosRx);%Calculo del EVM de los s�mbolos de recepci�n
disp(['El EVM de la se�al de recepcion es: ',num2str(EVM1)])
disp(['Nota: se considera como referencia un diagrama de constelacion M-QAM, con M igual a ' num2str(2^BitsporSubportadora)])