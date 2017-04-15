%function to fit fluorolog data and obtain binding fractions with an unbound spectrum
%but without using a total bound spectrum
%Zhiliang Gong, 11/4/2012
%modified on 11/5/2012

function [bestb,totchi2] = fluofit6(t)

colors = 'kgbrcmykgbrcmy';%color spectrum for plotting
U = t.aSR(:,1);%unbound spectrum
t_fit = zeros(size(t.aSR));%fitted data
t_fit(:,1) = t.aSR(:,1);%fitting not necessary for the first spectrum
t_fit(:,end) = t.aSR(:,end);%fitting not necessary for the last spectrum
[n,m] = size(t.aSR);
bm = 0.5:0.01:1;


for j = 1:length(bm)
    B = (t.aSR(:,end) - (1 - bm(j))*U)/bm(j);
    b = 0:0.01:bm(j);
    for k = 1:length(b)
        model = B*b(k)+U*(1-b(k));
        
        for l = 2:(m-1)
            data = t.aSR(:,l);
            std = t.SRstd(:,l);
            
            %Measure Chi Squared value:
            chi2(k,l) = (1/(n-1))*sum((model-data).^2./std.^2);
            
        end
        
    end
    
        minchi2 = min(chi2);
    
        for l = 2:(m-1)
            
            %Measure Chi Squared value:
            ind = find(chi2(:,l)==min(chi2(:,l)));
            bestb(l) = b(ind);
            
        end
        
        totchi2(j) = sum(minchi2)/(m-2);  

end
t.chi2 = chi2/(m-2);