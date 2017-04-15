%function to fit fluorolog data and obtain binding fractions with an unbound spectrum
%but without using a total bound spectrum
%Zhiliang Gong, 11/4/2012
%modified on 11/5/2012

function t = fluofit2(t)

colors = 'kgbrcmykgbrcmy';%color spectrum for plotting
U = t.aSR(:,1);%unbound spectrum
t_fit = zeros(size(t.aSR));%fitted data
t_fit(:,1) = t.aSR(:,1);%fitting not necessary for the first spectrum
t_fit(:,end) = t.aSR(:,end);%fitting not necessary for the last spectrum
[n,m] = size(t.aSR);
bm = 0.5:0.01:1;
chi2 = zeros(size(bm));

for j = 1:length(bm)
    B = (t.aSR(:,end) - (1 - bm(j))*U)/bm(j);
    b = 0:0.01:bm(j);
    temp = B*b+U*(1-b);    
    for i = 2:(m-2)
        x2 = min(sum(((temp - repmat(t.aSR(:,i),1,length(b))).^2)./((repmat(t.SRstd(:,i),1,length(b))).^2)))/(n-1-1);
        chi2(j) = chi2(j) + x2;
    end
end
t.chi2 = chi2/(m-2);