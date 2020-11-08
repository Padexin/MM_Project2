%%Housekeeping
clear all
clc
close all

%%First, we will look at the age, female population, and female size 
data1 = [0, 495, 30.3;
        1,  92, 45.8;
        2,  11, 55.8;
        3,   2, 56.0];

clutch_size = 0.21*data1(:,3) - 7.5; %Get our clutch size from the given formula
clutch_size(1) = 0; %Hatchlings can't lay eggs

survival = data1(2:end, 2)./data1(1:end-1,2); %Survival rate is estimated from the table

%%Now we consider patch size, sandy area, F_a, S_j, S_a, and density of
%%population

data2 = [ 11.31,  4.80,  5.6, 0.12, 0.06,  58;
          35.54, 11.31,  6.6, 0.16, 0.10,  60;
         141.76, 51.55,  9.5, 0.17, 0.13,  75;
          14.65,  7.55,  4.8, 0.15, 0.09,  55;
          63.24, 20.12,  9.7, 0.17, 0.11,  80;
         132.35, 54.14,  9.9, 0.18, 0.14,  82;
           8.46,  1.67,  5.5, 0.11, 0.05,  40;
         278.26, 84.32, 11.0, 0.19, 0.15, 115];
     
totals = data2(:,1).*data2(:,6); %total populations in each patch = size*density
%IMPORTANT: I assumed that these totals were (close enough to) the carrying capacity of the patch


%We find the betas for F_a, S_j, S_a, and C via linear regression
%First, a look at the data vs. patch size and sandy area
scatter(data2(:,1) + data2(:,2), data2(:,3))
figure()
scatter(data2(:,1) + data2(:,2), data2(:,4))
figure()
scatter(data2(:,1) + data2(:,2), data2(:,5))

%The above 3 plots show a logarithmic relationship as far as I can tell
%Since the variables F_a, S_j and S_a seem to have logarithmic relationships, using logarithmic regression should provide decent models for them based on patch size.
X = [ones(8,1) data2(:,1:2)]
%predicting F_a: function is F_a = beta(2)*log(Patch Size) + beta(3)*log(Sandy Habitat) (since beta(1)=0)
y = data2(:,3)
beta_F = log(X)\y
%predicting S_j: function is S_j = beta(2)*log(Patch Size) + beta(3)*log(Sandy Habitat) (since beta(1)=0)
y = data2(:,4)
beta_S_j = log(X)\y
%predicting S_a: function is S_a = beta(2)*log(Patch Size) + beta(3)*log(Sandy Habitat) (since beta(1)=0)
y = data2(:,5)
beta_S_a = log(X)\y

figure()
scatter(data2(:,1) + data2(:,2), totals)
%This one looks linear


% beta_F = data2(:,3)\[ones(8,1),data2(:,1:2)]; %These three need to be fixed to reflect logarithmic relationship
% beta_S_j = data2(:,4)\[ones(8,1),data2(:,1:2)];
% beta_S_a = data2(:,5)\[ones(8,1),data2(:,1:2)];

beta_C = totals\[ones(8,1),data2(:,1:2)];


%%Next we will look at migration between patches. Specifically, we will
%%look at distance moved and probability of recapture
data3 = [ 50, 0.42;
         100, 0.25;
         200, 0.12;
         250, 0.02;
         300, 0.00;
         350, 0.01];
%Currently working on this
