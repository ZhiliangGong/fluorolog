function tdata = fluofit(tdata, B, U)
%do a chi^2 fiting of a series fluorolog spectra either by specifying
%the unbound and/or the bound spectra
%or use the first spectrum as the default unbound while use the last
%spectrum as the default bound spectrum
%Zhiliang Gong, 9/4/2012
%Zhiliang Gong, 11/8/2012

colors = 'k-g-b-r-c-m-k.g.b.r.c.m.k+g+b+r+c+m+';

b = 0:0.01:1;%bound fraction fitting steps
[n,m] = size(tdata.aSR);
chi2 = zeros(m, length(b));%reduced chi^2 values for each spectra and each fitting b

if nargin == 1%no bound and unbound spectra specified
    U = tdata.aSR(:,1);%unbound spectrum to be the first spectrum
    B = tdata.aSR(:,end);%bound spectra
elseif nargin == 2
    U = tdata.aSR(:,1);%unbound spectrum unspecified
end

%calculating the chi sqaured values for each b value and each spectrum
fits = B*b + U*(1-b); %generating all possible fits as columns

%calculating all chi squared values for each b as a row and each spectrum
%as a column
for i = 1:m
    chi2(i,:) = sum((fits - repmat(tdata.aSR(:,i),1,length(b))).^2./tdata.SRstd(:,i).^2)/(n-1-1);
end



figure;
plot(b,chi2,'.','color','r');
xlabel('bound fraction');
ylabel('reduced chi^2 value');
title('Chi^2 value - bound fraction relation');

S = zeros(n,m-2);
rchi_sq = min(chi2);%minimum reduced chi^2 values for each fitting spectrum
bind_frac = zeros(1,m);
bind_frac(1) = 0;
bind_frac(end) = 1;

tdata.rchi_sq = rchi_sq;%add reduced chi^2 to data structure
for i = 1:(m-2)
    j = find(rchi_sq(i)==chi2(:,i));
    bind_frac(i+1) = b(j(1));
    S(:,i) = b(j(1))*B+(1-b(j(1)))*U;
    figure;
    errorbar(tdata.wl,tdata.aSR(:,i+1),tdata.SRstd(:,i+1)/2,'o','color','b');
    hold on;
    plot(tdata.wl,S(:,i),'-','LineWidth',2,'color','r');
    xlabel('wavelength (nm)');
    ylabel('S/R');
    s = strcat('Lipid: ', sprintf('%02d',tdata.lcons(i+1)), 'uM, Protein: ', sprintf('%02d',tdata.pcons(i+1)), 'nM, Buffer:', tdata.buffer, ', PS Percentage: ', sprintf('%02d',tdata.ps*100),'%');
    title(s);
    legend('data','fit');
    hold off;
    pause;
end

tdata.aSR_fit = S;
tdata.bind_frac = bind_frac;

end