%do a chi^2 fiting of miltiple fluorolog spectra which include a
%bound spectrum and a trial bound fraction for the last one
%Zhiliang Gong, 11/05/2012

function tdata = fluofit4(tdata)

colors = 'kgbrcmykgbrcmy';
U = tdata.aSR(:,1);%unbound spectrum to be the first one
x = input('Enter the trial bound fraction of the last spectrum: ');
B = (tdata.aSR(:,end)-(1-x)*U)/x;%bound spectra

b = 0:0.01:x;%fitting steps
[n,m] = size(tdata.aSR);
k = length(b);
chi_sq = zeros(k,m-2);%reduced chi^2 value

for i = 1:k
    temp = b(i)*B+(1-b(i))*U;
    chi_sq(i,:) = sum((tdata.aSR(:,2:(m-1))-repmat(temp,1,m-2)).^2./(tdata.SRstd(:,2:(m-1))).^2);
end
chi_sq = chi_sq/(n-1-1);%calculate the reduced chi^2 values

figure;
plot(b,chi_sq,'.','color','r');
xlabel('bound fraction');
ylabel('reduced chi^2 value');
title('Chi^2 value - bound fraction relation');

S = zeros(n,m-2);
rchi_sq = min(chi_sq);%minimum reduced chi^2 values for each fitting spectrum
bind_frac = zeros(1,m);
bind_frac(1) = 0;
bind_frac(end) = x;

tdata.rchi_sq = rchi_sq;%add reduced chi^2 to data structure
for i = 1:(m-2)
    j = find(rchi_sq(i)==chi_sq(:,i));
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