%function to fit fluororescence data with a binding model, a unbound
%spectrum and no bound spectrum
%Zhiliang Gong, 11/05/2012

function t = fluofit3(t)%t is the totally bound data

colors = 'kgbrcmykgbrcmy';%the color spectrum for plotting
U = t.aSR(:,1);%totally unbound data
bm = 0.5:0.01:1;
[n,m] = size(t.aSR);
B = (repmat(t.aSR(:,end),1,length(bm)) - U*(1-bm))./repmat(bm,n,1);%the collection of regenerated bound spectra
t.fits = zeros(n,m,length(bm));
