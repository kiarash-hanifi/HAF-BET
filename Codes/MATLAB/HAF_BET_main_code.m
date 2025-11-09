clc; clear; close all

%% Isotherm Data
%%% Getting the desorption isotherm data
des = xlsread ('Isotherm.xlsx', 'Sheet1', 'A2:B100');
x = des(:,1);       % Pressure ratio (P/P0)
V = des(:,2);       % Volume adsorbed {cm^3/g}
 
%% Defining Physical Properties of the Adsorbate
%%% We chose N2 as the adsorbate; it is the most common used adsorbate
Vm = 3.468e-5;      % Liquid molar volume of N2 {m^3/mol}
gamma = 8.72e-3;    % Surface tension of liquid N2 {N/m}
theta = 0;          % Contact angle, assumed to be zero
R = 8.314;          % Gas constant {J/(mol.K)}
T = 77;             % Adsorption analysis temperature for N2 {kelvin}
a = 0.364;          % Kinetic diameter of N2 {nm}
 
%% Applying the BJH Method
%%% calculate the equilibrium pressures based on the chosen radii (set by N)
N = 1500;                 roots = zeros(N,2);
R_n = zeros(N,1);         r_k = zeros(N,2);
t = zeros(N,2);           t_r = zeros(N,1);
delta_r_p = zeros(N,1);   j=0;
aa=linspace(1,1.1,7);       bb=linspace(1.1,25,N-6);
for i= [aa(1:end-1) bb]
    j=j+1;
    %%% Halsey equation is used
    f = @(X) 0.354 * (5 / log(1/X))^(1/3) - ...
           2e+09 * Vm * gamma * cos(theta) ./ (R * T .* log(X))-i;
    x0 = 0.5;
    roots(j,1) = fsolve(f,x0);                          % Equilibrium pressure
    t(j,1) = 0.354 .* (5 ./ log(1./roots(j,1))).^(1/3); % Adsorbed film thickness
    roots(j,2)=i; % radii
    r_k(j,1) = -2e+09 * Vm * gamma * cos(theta) ...
            ./ (R * T .* log(roots(j,1)));              % Cappilary Radius
    if j>1
     roots(j-1,3) = (roots(j,2)+roots(j-1,2))/2; % Average r_p
     r_k(j-1,2) = (r_k(j,1)+r_k(j-1,1))/2;       % Average r_k
     t(j-1,2) = t(j,1)-t(j-1,1);                 % Delta t
     t_r(j-1,1) = (t(j-1,1)+t(j,1))/2;           % t_r
     delta_r_p(j-1,1) = roots(j,2)-roots(j-1,2); % Difference in radii
    end
end
R_n(1:N-1) = (roots(2:N,3) ./ (r_k(2:N,2) + t(1:N-1,2))).^2;
%%% Calculate real value for BJH constant (c)
c = zeros(N,N-1);
for j=1:N-1 % pore iteration
for i=1:N-1 % pressure iteration
    c(i,j) = (roots(j,3) - t_r(i,1)) ./ roots(j,3);
end
end
%%% Linear interpolation for finding V in equilibrium pressure
w=1;
roots(:,4)=interp1(x,V,roots(:,1)); % V(cm3/g) in the 4th column
roots(:,5) = roots(:,4).*0.001555; %
for i=2:length(roots)
    roots(i-1,6) = roots(i,5)-roots(i-1,5); % liq delta V {cm3/gr}
end
%%% Calculate the volume of each pore
prod1 = zeros(N,1);
prod2 = zeros(N,1);
V_pj = zeros(N,1);
A_pj = zeros(1,N);
A_cj = zeros(N,1);
D = flip((triu(c,1))');  % the c values that are going to be used
for k=N-1:-1:2         % from bottom to top (largest pore to smallest)
    A_cj(k,1) = flip(A_pj(1:end-1)) * D(1:end, k);
    prod1(k,1) = roots(k-1,6).*R_n(k-1,1);
    prod2(k,1)= R_n(k-1,1).* t(k-1,2).* A_cj(k,1).*10^(-3);
    V_pj(k,1) = prod1(k,1) - prod2(k,1);
    A_pj(1,k) = 2*V_pj(k,1)./roots(k,3).*10^(3); % V_p{cm3/gr} & r{nm} -> A_pj{m2/gr}
end
%%% Calculate the average diameter
c_used = flip(D);
c_used(N,:) = zeros(1,N);
A_p = A_pj';
f_r = V_pj./sum(V_pj);
d = sum(2.*roots(:,3) .* f_r) / sum(f_r);
 
%% C(surface energy parameter) Calculation Based on AF-BET
Slope = zeros(20,1); Intercept = zeros(20,1);
R2 = [0.99 ; zeros(19,1)]; C = zeros(20,1);
m = 2; r = d/2/a;
while x(m) < 0.16
    XX(1:m) = x(1:m);
    Y(1:m) = (2 * r - 1) .* XX(1:m)' ./ (2 .* V(1:m));
    Preg_C = polyfit(XX(1:m),Y(1:m),1);
    Slope(m) = Preg_C(1);
    Intercept(m) = Preg_C(2);
    y_fit = polyval(Preg_C, XX(1:m));
    SS_res = sum((Y(1:m) - y_fit).^2);
    SS_tot = sum((Y(1:m) - mean(Y(1:m))).^2);
    R2(m) = 1 - (SS_res / SS_tot);
    C(m) = Slope(m) / Intercept(m) * ((r-1)/r);
    m = m + 1;
end
C_results = [C R2];
add_C = find(R2 == max(R2(find(x>0.08, 1,'first'):end)));
C_parameter = C(add_C);
Final_R2 = R2(add_C);
number_of_data_used = add_C;
 
%% Isotherm Creation for Each Pore
VP = zeros(N, N-1);
for j=1:N-2 % pore iteration
    for i=j+1:N-1 % pressure iteration
        VP(N-i,N-j) = V_pj(N-j,1) - roots(N-j-1,6) + ...
        10^-3.*sum(A_p(N-j+1:N,1).*(c_used(N-j+1:N,N-j-1))).*t(N-j-1,2) - ...
        10^-3.*A_p(N-j,1).* ((c_used(N-j,N-i:N-j-2) * t(N-i:N-j-2,2)));
    end
end
 
%% Apply the AF-BET Theory in Each Pore
R_cm = roots(:,3).*10^-7; a_cm = a*10^-7; n = floor(R_cm./a_cm);
Vads = VP;
A0 = 0; B0 = 0;
X = zeros(length(x),1);
P = zeros(1,length(n));
for z=3:length(n)-1
    i = (1:n(z))';
    for j=1:length(roots)-1
            A = sum ((2.*a_cm.*R_cm(z).*i-i.^2.*a_cm^2).*roots(j,1).^i./(R_cm(z)-i.*a_cm));
            B = sum (R_cm(z).*roots(j,1).^i./(R_cm(z)-i.*a_cm));
            X(j,z) = C_parameter.*A./(2.*(1+C_parameter.*B));
    end
    if z>5
        Count = 5;
    else
        Count = z-1;
    end
    Preg = polyfit(X(1:Count,z),Vads(1:Count,z),1);
    P(z) = Preg(1)/10^4; % SSA {m2/gr}
end
 
%% Illustration and Results
%%% Pore size distribution plot
figure(1)
plot(2.*roots(1:end-1,3),roots(1:end-1,6)./delta_r_p(1:end-1,1),'LineWidth',2)
ylabel('dV/dr(cm^3.gr^-^1.nm^-^1)')
xlabel('pore diameter(nm)')
%%% Linear regression plot for C calculation
figure(2)
plot(XX(1:add_C),Y(1:add_C),'or');
hold on;
plot(XX(1:add_C),Slope(add_C).*XX(1:add_C)+Intercept(add_C),'--b')
ylabel('(2r-1)x/2V')
xlabel('x')
%%% SSA and C in the output
clc
Total_Pore_Volume = sum(V_pj);
C = C_parameter
HAF_BET_SSA = sum(P)

