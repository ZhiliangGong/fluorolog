function v0 = voluadd( v )
%add up the volumes added during a titration experiment
%   Zhiliang Gong, 2014-07-26

v0 = zeros(size(v));
for k = 1:length(v);
    v0(k) = sum(v(1:k));
end

end