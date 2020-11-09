%%Housekeeping
clear all
clc
close all


%Task 4
%the given histogram, assuming that the distance moved measurement is the lower bound for a given bar.

data3 = [ 50, 0.42;
         100, 0.25;
         150, 0.18;
         200, 0.12;
         250, 0.02;
         300, 0.00;
         350, 0.01];
         
% We are also given that there is a 0.1 percent chance of juvenile lizards migrating
% adult lizards do not migrate
pmigrate = [0.1, 0, 0, 0];

%unfortunately, there is no table giving the distances between patches, so I'll just work theoretically
% The below interpertation assumes no patches are closer than about 50 meters
%X = [ones(7,1) exp(-1.*data3(:,1))];
%y = [data3(:,2)];
%beta = X\y;
%This is garbage, probably due to the large size of X compared with the output.

%Transitioning the data to X/750, because that was the given maximum distance lizards migrated
%     THIS IS THE FINAL MODEL I UTILIZED, it is still wrong
% I made a false assumption that the data given was not a histogram, which lead to a model that works, but isn't an accurate depiction of anything
% I could create a probability density function that would tell me the probability of a lizard migrating a given distance, which would be more useful
% But said probability function would still not answer the question
%X = [ones(7,1) exp(-1.*(data3(:,1)./750))];
%y = [data3(:,2)];
%beta = X\y;

%The above seems to work well, but breaks down at about X=300
%modifying the data slightly to see if I can fix that
##data3 = [ 50, 0.42;
##         100, 0.25;
##         150, 0.18;
##         200, 0.12;
##         250, 0.02;
##         350, 0.01];
##X = [ones(6,1) exp(-1.*(data3(:,1)./750))];
##y = [data3(:,2)];
##beta = X\y
%This does not seem to have helped


%The Final formula is survival chance = beta(1) + e^(-Distance Between Patches/750)
%psurvive = [1 distance]*beta
