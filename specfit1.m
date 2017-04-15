%function to fit lipid concentration titration binding data
%fitting the data to a one site specific binding model

function [new_b, x] = specfit1(b, s)

inc = 0.5:0.01:1;
normr = zeros(size(inc));
for k=1:length(inc)
    inc_b = b*inc(k);
    theta = inc_b./(1-inc_b);
    [~, S] = polyfit(s, theta, 1);
    normr(k) = S.normr;
end

x = inc(normr==min(normr));
new_b = b*x;

end