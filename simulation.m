% ------------------------------------------
% FILE   : simulation.m
% AUTHOR : Owen Dillon, The University of Sydney
% DATE   : 2024-08-21  Created
% ------------------------------------------
% PURPOSE
%   Simulate a clinical trial using minimization
% ------------------------------------------
% METHOD
%   We are following the simple method of Pocock and Simon doi:10.2307/2529712
%   Using the "weighted range method" where we want even spread between arms
%   and factors however we assign a low weight towards which hospital
%   patients come from (explained in encoding)
% ------------------------------------------
% ENCODING
%   Each patient is a 6 element vector with factors f1 to f6. We encode
%   each factor with numbers 0 to s-1 where s is the number of strata.
%   There is no particular reason to use numbers, could use letters etc.
%   this is just for compactness and does not imply ordering.
%   f1: age. 0 = under 70, 1 = over 70
%   f2: Chemotherapy. 0 = no chemo, 1 = chemo planned
%   f3: Immunotherapy. 0 = no immunotherapy, 1 = immunotherapy planned
%   f4: Smoker. 0 = smokes under 20 per day, 1=smokes over 20 per day
%   f5: BED (Biologically Equivalent Dose) lung dose. 0=under 100Gy, 1=over 100Gy
%   f6: Hospital. 0 = hospital 0, 1 = hospital 1, 2 = hospital 2
%   We tabulate data into table T. Each column of T is an arm. Rows are
%   number of patients in factor 1 strata 1, factor 1 strata 2, factor 2
%   strata 1, factor 2 strata 2 etc.
% ------------------------------------------
%% Initialise
close all; clear all;
n_pats = 160;
n_arms = 2;
n_factors = 6;
range_factors = [1;1;1;1;1;2];
weights = [1;1;1;1;1;1];      %the other factors are 10x more important than which hospital the patient is from
p = 0.8;    % we assign to minimized arm with probability p
%%
%data so far
A1 = [];
A2 = [];
A{1,1} = A1; A{1,2} = A2;
P = [];
T = zeros(sum(1+range_factors),n_arms);
T_random = T;       %pure randomisation for comparison
%%
for pp = 1:n_pats;
    % Enroll a new patient
    p_new = floor((range_factors+1).*rand(6,1));
    P = [P,p_new];
    t_new = 0*T(:,1);
    bal = zeros(1,n_arms);
    q = 0;
    for jj = 1:n_factors
        for kk = 1:range_factors(jj)+1
            q = q+1;
            for ll = 1:n_arms
                t_new(q) = sum(p_new(jj)==kk-1);
                if p_new(jj)==kk-1;
                    t = T(q,:); t(ll) = t(ll)+1;
                    bal(ll) = bal(ll)+weights(jj)*range(t);
                end
            end
        end
    end
    [m,arm] = min(bal);
    % perform randomisation
    roll = rand;
    if roll>p;
        indx = [1:n_arms]; indx(arm) = [];
        roll = ceil((n_arms-1)*rand);
        arm = indx(roll);
        %i.e. with probability 1-p we will instead randomize into a suboptimal arm
    end
    T(:,arm) = T(:,arm)+t_new;
    A{1,arm} = cat(2,A{1,arm},p_new);
    %pure randomisation recruitment for comparison
    roll = ceil(n_arms*rand);
    T_random(:,roll) = T_random(:,roll)+t_new;
end
%% Some visualisation
T_cell{1,1} = 'Minimisation';   T_cell{1,2} = ' ';    T_cell{1,3} = 'control';    T_cell{1,4} = 'intervention';    T_cell{1,5} = 'range';
T_cell{2,1} = 'age';    T_cell{2,2} = '<70';
T_cell{3,1} = ' ';    T_cell{3,2} = '>70';
T_cell{4,1} = 'chemo';  T_cell{4,2} = 'No';
T_cell{5,1} = ' ';  T_cell{5,2} = 'Yes';
T_cell{6,1} = 'immuno'; T_cell{6,2} = 'No';
T_cell{7,1} = ' '; T_cell{7,2} = 'Yes';
T_cell{8,1} = 'smoker'; T_cell{8,2} = 'No';
T_cell{9,1} = ' '; T_cell{9,2} = 'Yes';
T_cell{10,1} = 'lung BED';   T_cell{10,2} = '<100Gy';
T_cell{11,1} = ' ';  T_cell{11,2} = '>100Gy';
T_cell{12,1} = 'hospital';  T_cell{12,2} = 'RNSH';
T_cell{13,1} = ' ';  T_cell{13,2} = 'POW';
T_cell{14,1} = ' ';  T_cell{14,2} = 'LH';
T_cell_random{1,1} = 'Randomisation';
T_cell_random{1,2} = 'control';    T_cell_random{1,3} = 'intervention';    T_cell_random{1,4} = 'range';
T_cell_random{2,1} = ' ';T_cell_random{3,1} = ' ';T_cell_random{4,1} = ' ';
T_cell_random{5,1} = ' ';T_cell_random{6,1} = ' ';T_cell_random{7,1} = ' ';
T_cell_random{8,1} = ' ';T_cell_random{9,1} = ' ';T_cell_random{10,1} = ' ';
T_cell_random{11,1} = ' '; T_cell_random{12,1} = ' ';T_cell_random{13,1} = ' ';T_cell_random{14,1} = ' ';
for jj = 1:length(T(:,1));
    for kk = 1:n_arms
        T_cell{1+jj,2+kk} = T(jj,kk);
        T_cell_random{1+jj,1+kk} = T_random(jj,kk);
    end
    T_cell{1+jj,3+n_arms} = range(T(jj,:));
    T_cell_random{1+jj,2+n_arms} = range(T_random(jj,:));
end
TT = [T_cell,T_cell_random];
writecell(TT,'Simulation_Experiment_Summary.xls');

