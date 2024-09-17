% ------------------------------------------
% FILE   : example.m
% AUTHOR : Owen Dillon, The University of Sydney
% DATE   : 2024-08-21  Created
% ------------------------------------------
% PURPOSE
%   Example script showing how different types of minimization can be
%   applied when assigning patients in clinical trials.
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
n_arms = 2;
n_factors = 6;
range_factors = [1;1;1;1;1;2];
weights = [1;1;1;1;1;0.1];      %the other factors are 10x more important than which hospital the patient is from
p = 0.8;    % we assign to minimized arm with probability p
%%
% Create example data so far
A1 = [[0;1;0;0;1;2],[1;0;0;1;1;0],[1;1;1;0;0;0]];
A2 = [[1;1;0;0;1;1],[0;0;0;1;1;2]];
%i.e. 3 patients in arm 1 2 patients in arm 2 so far
% tabulate the data so far
A{1,1} = A1; A{1,2} = A2;
T = [];
q = 0;
for jj = 1:n_factors
    for kk = 1:range_factors(jj)+1
        q = q+1;
        for ll = 1:n_arms
            t = A{1,ll}; t = t(jj,:);
            T(q,ll) = sum(t==kk-1);
        end
    end
end
%%
% Enroll a new patient
p_new = [0;0;1;1;0;2];  %under 70, no chemo, immuno, smoker, under 100Gy BED lung, hospital 2
% compute imbalance i.e. how would this patient change the table?
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
['Assign the new patient to arm ',num2str(arm)]








