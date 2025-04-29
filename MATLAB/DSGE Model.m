% Date Created: 27 October 2024
% Created By: Hareem Fatima

% Combined Open Economy GK Model
% Calculates steady-state parameters and results
% Case 1: Betta = 0.99

clc; clear all; close all;

%% 1. Parameter Definitions

% Combined Open Economy GK Model
% Calculates steady-state parameters and results
% Case 1: Betta = 0.99

clc; clear all; close all;

%% 1. Parameter Definitions

% Setting parameters
betta   =   0.99;           % Discount rate
sig     =   1;              % Intertemporal elasticity of substitution
hh      =   0.815;          % Habit formation parameters
chi0    =   3.4;            % Starting value for the labor utility weight
varphi  =   0.276;          % Inverse Frisch elasticity of labor supply       
zetta   =   7.2;            % Elasticity of marginal depreciation wrt the utilization rate

lambda0  =  0.3815;          % Starting value divertable fraction 
omega0   =  0.002;           % Starting value of proportional starting up funds
theta   =   0.97155955;     % The survival probability

alfa    =   0.33;           % Capital share
delta   =   0.025;          % Depreciation rate
G_over_Y=   0.2;            % Government expenditures over GDP
eta_i   =   1.728;          % Elasticity of investment adjustment cost

% Retail firms
epsilon =   4.167;          % Elasticity of substitution between goods
gam     =   0.779;          % Calvo parameter
gam_P   =   0.241;          % Price indexation parameter

% Monetary Policy parameters
rho_i   =   0.;             % Interest rate smoothing parameter
kappa_pi=   1.5;            % Inflation coefficient
kappa_y =   -0.5/4;         % Output gap coefficient

% Shocks
sigma_ksi   =   0.05;       % Size of the capital quality shock
rho_ksi     =   0.66;       % Persistence of the capital quality shock
sigma_a     =   0.01;       % Size of the TFP shock
rho_a       =   0.95;       % Persistence of the TFP shock
sigma_g     =   0.01;       % Size of the government expenditure shock
rho_g       =   0.95;       % Persistence of the government expenditure shock
sigma_Ne    =   0.01;       % Wealth shock
sigma_i     =   0.01;       % Monetary policy shock
rho_shock_psi=  0.66;       % Persistence of the CP shock
sigma_psi   =   0.072;      % Size of the CP shock

% Targeted moments
L_mom    =   1/3;           % Steady-state labor supply
RkmR_mom =   0.01/4;        % Steady-state premium
phi_mom  =   4;             % Steady-state leverage

% Credit policy parameters
kappa      =   10;          % Credit policy coefficient
tau        =   0.001;       % Costs of credit policy

% Starting values for some steady-state values
L0      =   L_mom;
K0      =   9.5;            % Initial value of capital (steady state)

%% 5. Calculate Results
% Use the solved parameters to compute other variables (e.g., capital, output)
% Calculating steady-state values
K = K0;    % Set steady-state capital (you may adjust if needed)
L = L0;    % Set steady-state labor (you may adjust if needed)

Y   =   K^alfa * L^(1-alfa);  % Steady-state output
G   =   G_over_Y * Y;         % Government expenditure
I   =   delta * K;            % Investment
C   =   Y - I - G;            % Consumption
Pm  =   (epsilon - 1) / epsilon; % Price markup
R   =   1 / betta;            % Interest rate
Rk  =   Pm * alfa * Y / K + 1 - delta; % Return on capital
RkmR = Rk - R;                % Premium over the interest rate

%% 3. Model Specification
% Define equations for the system
f_mom = @(chi) [ 
    chi * L0^varphi - (1 - betta * hh) * ((1 - hh) * L0)^(-sig);  % Labor supply equation
    (alfa * K0^(alfa-1) * L0^(1-alfa) + 1 - delta - 1 / betta);    % Return to capital equation
    % Add other equations as necessary
];

%% 4. Solve for Steady State
options = optimset('Display', 'iter');  % Show iteration details
[chi_sol, fval, exitflag] = fsolve(f_mom, chi0, options);  % Solve for chi

% Check if solution is successful
if exitflag > 0
    fprintf('Steady state found:\n');
    fprintf('chi = %f\n', chi_sol);
else
    error('Failed to find a steady state.');
end

% Display results
fprintf('Steady-state results:\n');
fprintf('Output (Y) = %f\n', Y);
fprintf('Consumption (C) = %f\n', C);
fprintf('Interest rate (R) = %f\n', R);

% Steady-State Results
% chi = 4.2416;        % Calibrated parameter
% Y = 1.006880          % Output
% C = 0.568004;          % Consumption
% R = 1.0101;          % Interest rate


% Open a file to write LaTeX code
fileID = fopen('steady_state_table.tex', 'w');

% Write LaTeX table code
fprintf(fileID, '\\begin{table}[h!]\n');
fprintf(fileID, '\\centering\n');
fprintf(fileID, '\\begin{tabular}{@{}ll@{}}\n');
fprintf(fileID, '\\toprule\n');
fprintf(fileID, '\\textbf{Variable} & \\textbf{Value} \\\\\n');
fprintf(fileID, '\\midrule\n');
fprintf(fileID, 'Calibrated Parameter ($\\chi$) & %.4f \\\\\n', chi_sol);
fprintf(fileID, 'Output ($Y$) & %.4f \\\\\n', Y);
fprintf(fileID, 'Consumption ($C$) & %.4f \\\\\n', C);
fprintf(fileID, 'Interest Rate ($R$) & %.4f \\\\\n', R);
fprintf(fileID, '\\bottomrule\n');
fprintf(fileID, '\\end{tabular}\n');
fprintf(fileID, '\\caption{Steady-State Results from the Open Economy GK Model.}\n');
fprintf(fileID, '\\label{tab:steady_state_results}\n');
fprintf(fileID, '\\end{table}\n');

% Close the file
fclose(fileID);