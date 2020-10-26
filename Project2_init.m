C = 1500; %The carrying capacity; currently based on nothing
num_years = 10; %The number of years over which we would like to model
pop0 = 1000; %The starting population

k = [2.118, 4.218, 4.26]; %These are the reproduction rates for years 1-4
d = [0.814, 0.919, 0.818]; %These are the death rates for years 0-3; d4 is 100%

x = zeros(4,num_years); %This will be our vector for storing population in each year
x(1,1) = pop0;

%This is our calculation loop; the first term is the hardest, but it is
%simply based on a logistical model. The rest of them are the previous
%years population minus the death rate of that age group
for i = 2:num_years
    x(1,i) = (k(1)*x(2,i-1) + k(2)*x(3,i-1) + k(3)*x(4,i-1));
    x(2,i) = x(1,i-1)*(1-d(1));
    x(3,i) = x(2,i-1)*(1-d(2));
    x(4,i) = x(3,i-1)*(1-d(3));
    
    test = C - (x(1,i) + x(2,i) + x(3,i) + x(4,i)); %This will tell us if our population is over the carrying capacity
end

t = 1:num_years;
plot(t,x(1,:) + x(2,:) + x(3,:) + x(4,:)); %This is the total population
hold on
plot(t,x(1,:)); %This is the total population
plot(t, x(2,:));
plot(t, x(3,:));
plot(t, x(4,:));

legend('Total Population', 'Year 0', 'Year 1', 'Year 2', 'Year 3');
xlabel('Time (years)');
ylabel('Population (lizards)');

saveas(gcf,'carrying.png');
hold off