function [ ad ] = bound_fracfull( d, bmax, plotopt)
%Function to analyze fluorescent spectra titration series
%For use with Fluor_reduce output and assumes bnd and unbnd spectra are
%last and first spectra of structure respectively

bnd = d.mbnd';
ubnd = d.mubnd';

wvl = d.wvl;

ps_percent = d.lipid_con;
%Define ratio of bnd to ubnd for use in this plot:
ad.bmax = bmax;
color = 'brkmgcybrkmgcybrkmgcybrkmgcybrkmgcybrkmgcy';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %Generate plot of all spectra in series
% ss = figure();
% 
% %Plot starting with high concentration data so legend is oriented properly
% plot(wvl,fliplr(d.mdata_SR),fliplr(d.std_SR))
% 
% for j = 1:length(d.lipid_con)
%     
%     lipid_context(j) = num2str(d.lipid_con(length(d.lipid_con)-j+1));
% 
% end
% 
% legend(lipid_context);
% 
% xlabel('Wavelength (nm)')
% ylabel('Signal Normalized Intensity (counts/sec)');
% title(strcat(t,' - b/u ratio = ', num2str(ad.bu_ratio)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Perform fitting of bnd/unbnd to extract % Bound

%First generate full range of values
b_inc = 0:.01:1.5;

for m = 1:length(d.lipid_con)
    
    ad.bnd_frac(m,1) = d.lipid_con(m);
    
    for q = 1:size(d.mdata_SR(1,:,m),2)
    
        for j = 1:length(b_inc)
            test_spectra = b_inc(j)*bnd + (1-b_inc(j))*ubnd;
            resid_sqr = (test_spectra - d.mdata_SR(:,q,m)).^2;
       
            chi_sqr(j) = sum(resid_sqr);
            
        end
        

        ind = find(chi_sqr == min(chi_sqr),1,'first');
        ad.bnd_frac(m,q+1) = b_inc(ind)/bmax;
        ad.fit_spec(:,q,m) = ad.bnd_frac(m,q+1)*bmax*bnd + (1-ad.bnd_frac(m,q+1)*bmax)*ubnd;
        
        
        if plotopt ==1
        figure(1);
        hold on;
        plot(wvl, d.mdata_SR(:,q,m),'ok','MarkerSize',6);
        plot(wvl, ad.fit_spec(:,q,m),'r','LineWidth', 1.5)
        
        if m==1
            legend('Data','Fit');
            xlabel('Wavelength (nm)')
            ylabel('Normalized Intensity (counts/sec)');
            title('Titration fitting');
        end
            
        pause
        end

            

            
            
    end



end

figure;
ad.ps_percent = ps_percent;
plot(ad.ps_percent,ad.bnd_frac(:,2:end),'o','MarkerSize',6);
xlabel('PS concentration (uM)')
ylabel('Bound fraction')
title('Bound fraction series')

ad.bnd = bnd;
ad.ubnd = ubnd;

f = ad.fit_spec(:,1,end)/max(ad.ubnd);
b = ad.bnd_frac(end,2);
u = ad.ubnd/max(ad.ubnd);

ad.mstr_b = (f - (1-b)*u)/b;
ad.mstr_u = u;
ad.bu_ratio = max(ad.mstr_b)/max(ad.mstr_u);
    
end


