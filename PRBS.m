function z=PRBSPrueba(init,g)
% 2^n-1-bit PRBS basada en condiciones iniciales
z=init; %Condición inicial [1 0 1 1 0 1 1]
n=length(init);% n=7, representa al polinomio generador g --> x^7+x^6+1 ejm:  g=[7 6] 
for i=(n+1):(2^n-1)%Lazo for para la creación de la señal PRBS
    q=z(i-g(1));
    q=xor(q,z(i-g(2)));
    z=[z q];%Señal PRBS obtenida
end