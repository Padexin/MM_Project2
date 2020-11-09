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
X = data2(:,1:2);
%predicting F_a: function is F_a = beta(2)*log(Patch Size) + beta(3)*log(Sandy Habitat) (since beta(1)=0)
y = data2(:,3);
beta_F = [ones(8,1),log(X)]\y;
%predicting S_j: function is S_j = beta(2)*log(Patch Size) + beta(3)*log(Sandy Habitat) (since beta(1)=0)
y = data2(:,4);
beta_S_j = [ones(8,1),log(X)]\y;
%predicting S_a: function is S_a = beta(2)*log(Patch Size) + beta(3)*log(Sandy Habitat) (since beta(1)=0)
y = data2(:,5);
beta_S_a = [ones(8,1),log(X)]\y;

figure()
scatter(data2(:,1) + data2(:,2), totals)
%This one looks linear

beta_C = ([ones(8,1),data2(:,1:2)]\totals)'; %Coefficients for carrying capacity

data3 = [13.66,  5.38;
         32.74, 11.91;
          1.39,  0.23;
          2.28,  0.76;
          7.03,  3.62;
         14.47,  4.38;
          2.52,  1.99;
          5.87,  2.49;
         22.27,  8.44;
         19.25,  7.58;
         11.31,  4.80;
         74.35, 19.15;
         21.57,  7.52;
         15.50,  2.82;
         35.54, 11.31;
          2.93,  1.15;
         47.21, 10.73;
          1.67,  0.13;
          9.80,  2.23;
         39.31,  7.15;
          2.23,  0.78;
          3.73,  1.02;
          8.46,  1.67;
          3.89,  1.89;
          1.33,  1.11;
          0.85,  0.79;
          8.75,  5.30;
          9.77,  6.22;
         13.45,  4.69];

F_a = [ones(29,1),log(data3)]*beta_F;
S_a = [ones(29,1),log(data3)]*beta_S_a;
S_j = [ones(29,1),log(data3)]*beta_S_j;
C = [ones(29,1),data3]*beta_C';

scatter(data3(:,1), F_a)
xlabel('Patch Size')
ylabel('Fertility')
saveas(gcf, 'F_a.png')

scatter(data3(:,1), S_a)
xlabel('Patch Size')
ylabel('Adult Survival Rate')
saveas(gcf, 'S_a.png')

scatter(data3(:,1), S_j)
xlabel('Patch Size')
ylabel('Juvenile Survival Rate')
saveas(gcf, 'S_j.png')

scatter(data3(:,1), C)
xlabel('Patch Size')
ylabel('Carrying Capacity')
saveas(gcf, 'C.png')

close all

%%Now we implement for the full population
%First we define the Leslie matrix for each population i
num_years = 50;
N = zeros(4, num_years, 29); %We will have 29 populations with 4 age groups
                                %that we keep track of for num_years, and
                                %we want an initial population of 1000
                                %lizards for each one
N(2,1,:) = 100;
L = zeros(4,4,29);
N_i = zeros(4,num_years);

for i = 1:29
    L(:,:,i) = [0        F_a(i) F_a(i) F_a(i);
            S_j(i)   0      0      0     ;
            0        S_a(i) 0      0     ;
            0        0      S_a(i) S_a(i)];
        %This is the Leslie matrix for each individual patch
        L_i = squeeze(L(:,:,i)); %It won't let me do 3D matrix multiplication
        
    for j = 2:num_years %We now want to run the simulation for each patch        
        N_i(:,j-1) = squeeze(N(:,j-1,i));
        %These are to make the following equation look a little less nasty;
        %also, squeeze() removes the third dimension, which is 1 by design
        N_i(:, j) = L_i*N_i(:,j-1) ; %Regular exponential growth model
        
        v = N_i(:,j)/sum(N_i(:,j)); %Percentage each age group is of total population
        
        %The following equation takes our exponential growth and implements
        %carrying capacity
        N(:,j,i) = N_i(:,j) + v.*sum(N_i(:,j))*((C(i) - sum(N_i(:,j)))/sum(N_i(:,j)));
    end
        clear N_i
        clear v
        clear L_i
end

%%Now we're going to plot the populations of min, max, mean, and median
%%patch sizes

plot(1:num_years, N(:,:,1))
legend('Year 0','1','2','3')
xlabel('Year')
ylabel('Population')
saveas(gcf,'mean.png')

plot(1:num_years, N(:,:,3))
legend('Year 0','1','2','3')
xlabel('Year')
ylabel('Population')
saveas(gcf,'min.png')

plot(1:num_years, N(:,:,12))
legend('Year 0','1','2','3')
xlabel('Year')
ylabel('Population')
saveas(gcf,'max.png')

plot(1:num_years, N(:,:,27))
legend('Year 0','1','2','3')
xlabel('Year')
ylabel('Population')
saveas(gcf,'median.png')

