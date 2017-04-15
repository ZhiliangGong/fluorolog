%indofit.m
%fitting a series of titration data with a common data identifier
%not chi squared fitting!
%minimizing the squre of difference, which proves to be better.
function tdata = indofit(tdata,fit_range)
%wrote by Zhiliang Gong in 2013
%modified by Zhiliang Gong on 7/11/2014
%modified by Zhiliang Gong on 7/26/2014

colors = 'b-g-r-c-m-y-k-bogorocomoyoko';
b = (0:0.01:1);
n = size(tdata.nSR,2);

if nargin == 2
    
    i = (fit_range(1)-tdata.wl(1))/2+1;
    j = length(tdata.wl)-(tdata.wl(end)-fit_range(2))/2;
    
elseif nargin == 1
    
    i = 1;
    j = length(tdata.wl);
    
else
    
    disp('check arugments');
    
end

bnd = tdata.bnd(i:j);
ubnd = tdata.ubnd(i:j);
fits = bnd*b+ubnd*(1-b);

tdata.b = zeros(1,n);

figure;
for k = 1:n

    chi2sum = sum(((repmat(tdata.nSR(i:j,k),1,101) - fits)).^2);
    good_n = find(min(chi2sum)==chi2sum);
    tdata.b(k) = (good_n-1)/100;
    plot(tdata.wl(i:j),tdata.nSR(i:j,k),'o',tdata.wl(i:j),bnd*b(good_n)+ubnd*(1-b(good_n)))
    hold on;

end

hold off;

end