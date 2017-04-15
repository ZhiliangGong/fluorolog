function tdata = fluofit(tdata, B, U)
%do a chi^2 fiting of a series fluorolog spectra either by specifying
%the unbound and/or the bound spectra of unit protein concentration (nM)
%or use the first spectrum as the default unbound while use the last
%spectrum as the default bound spectrum
%Zhiliang Gong, 9/4/2012
%Zhiliang Gong, 11/8/2012
%Zhiliang Gong, 11/19/2012
%Zhiliang Gong, 12/17/2012, adding the errors for bound fractions

colors = 'k-g-b-r-c-m-k.g.b.r.c.m.k+g+b+r+c+m+kogoborocomo';

b = 0:0.01:1;%bound fraction fitting steps
[n,m] = size(tdata.aSR);
chi2 = zeros(m, length(b));%reduced chi^2 values for each spectra and each fitting b

if nargin == 1%no bound and unbound spectra specified
    U = tdata.aSR(:,1)/tdata.pcons(1);%unit unbound spectrum to be the first spectrum
    B = tdata.aSR(:,end)/tdata.pcons(end);%unit bound spectra
elseif nargin == 2
    U = tdata.aSR(:,1)/tdata.pcons(1);%unbound spectrum unspecified
end

%calculating the chi sqaured values for each b value and each spectrum

ufits = B*b + U*(1-b); %generating all possible unit fits as columns

%calculating all chi squared values for each b as a row and each spectrum
%as a column
for i = 1:m
    fits = ufits*tdata.pcons(i);%converting fits to the right scale
    %if sum(tdata.SRstd(:,i)) > realmin %if standard deviations are calculated
        %chi2(i,:) = sum((fits - repmat(tdata.aSR(:,i),1,length(b))).^2./repmat(tdata.SRstd(:,i).^2,1,length(b)))/(n-1-1);
    %else
        chi2(i,:) = sum((fits - repmat(tdata.aSR(:,i),1,length(b))).^2)/(n-1-1); %error weighting not possible
    %end
end

for i = 1:m
    figure;
    plot(b, chi2(i,:));
    xlabel('bound fraction');
    ylabel('reduced \chi^2 value');
    s = strcat('\chi^2 - bound fraction relation. Lipid: ', sprintf('%02d',tdata.lcons(i)), '\muM');
    title(s);
    pause;
    close;
end

[min_chi2, ind] = min(chi2');
b = (ind-1)/100;

%the
b_low = zeros(size(b));
b_high = zeros(size(b));


tdata.chi2 = chi2;
tdata.min_chi2 = min_chi2;
tdata.b = b;

S = B*b + U*(1-b);%unit fits
S = S.*repmat(tdata.pcons,n,1);
%plotting
for i = 1:m
    figure;
    errorbar(tdata.wl,tdata.aSR(:,i),tdata.SRstd(:,i)/2,'o','color','b');
    hold on;
    plot(tdata.wl,S(:,i),'-','LineWidth',2,'color','r');
    xlabel('wavelength (nm)','FontSize',12);
    ylabel('S/R counts','FontSize',12);
    if isfield(tdata,'PS')
        s = strcat('Lipid: ', sprintf('%02d',tdata.lcons(i)), '\muM, Protein: ', sprintf('%02d',tdata.pcons(i)), 'nM, ', tdata.buffer, ', ', sprintf('%02d',tdata.PS*100),'% PS');
    else
        s = strcat('Lipid: ', sprintf('%02d',tdata.lcons(i)), '\muM, Protein: ', sprintf('%02d',tdata.pcons(i)), 'nM, ', tdata.buffer, ', ', sprintf('%02d',tdata.ps*100),'% PS');
    end
    title(s,'FontSize',12);
    fit_lg = strcat('fit, ', sprintf('%.0f', tdata.b(i)*100), '% bound');
    legend('data',fit_lg);
    hold off;
    pause;
    close;
end

end