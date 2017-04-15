function nb = fitb( ps, b )
%fitb, find the best binding coefficients
%   fit the binding coefficients to a binding model
% ps is the [PS]
% b is the binding coefficients

if ps(1) == 0
    ps = ps(2:end);
    b = b(2:end);
end

dev = zeros(size(0.1:0.01:1));
k = 0;
for mb = 0.1:0.01:1
    k = k + 1;
    tempb = mb*b;
    P = polyfit(log(ps),log(1./(1-tempb)),1);
    dev(k) = sum((P(2)*ps + P(1) - log(1./(1-tempb))).^2);
end

figure;
plot(0.1:0.01:1,dev);
xlabel('Max bound fraction');
ylabel('deviation from binding model');
title('binding model fitting');
pause;
close;

[mindev, k] = min(dev) % k is the index of the optimal binding coefficient
nb = mb(k)*b;
P = polyfit(log(ps),log(1./(1-nb)),1);
figure;
plot(log(ps),log(1./(1-nb)),'o');
hold on;
plot(-1:0.01:2.5, P(2)*(-1:0.01:2.5) + P(1),'-r');
legend('data','fit');
hold off;
xlabel('[PS]/\muM');
ylabel('log(1/(1-b))');
title('binding model fitting');

end

