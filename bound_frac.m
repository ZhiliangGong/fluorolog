function [ ad ] = bound_frac( d ,bnd_spec)
%Function to analyze fluorescent spectra titration series
%For use with Fluor_reduce output and assumes bnd and unbnd spectra are
%last and first spectra of structure respectively


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define bound and unbound spectra:
bnd = d.mdata_SR(:,bnd_spec);
ubnd = d.mdata_SR(:,1);


wvl = d.wvl;

%Generate plot of unbound and bound:
ub = figure();
plot(wvl, bnd,'o','MarkerSize', 6);
hold on;
plot(wvl, ubnd,'or','MarkerSize', 6);
pause


legend('100nM Unbound',strcat('100nM Bound -',num2str(d.lipid_con(end)),'uM'));
xlabel('Wavelength (nm)')
ylabel('Signal Normalized Intensity (counts/sec)');

%Define ratio of bnd to ubnd for use in this plot:
ad.bu_ratio = max(bnd)/max(ubnd);


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
b_inc = 0:.01:1;

for m = 1:length(d.lipid_con)
    
    
for j = 1:length(b_inc)
    
    test_spectra = b_inc(j)*bnd + (1-b_inc(j))*ubnd;
    resid_sqr = (test_spectra - d.mdata_SR(:,m)).^2;
    
  
        
     chi_sqr(j) = sum(resid_sqr);
        
   
    
end

ind = find(chi_sqr == min(chi_sqr));
ad.bnd_frac(m) = b_inc(ind);
ad.fit_spec(:,m) = ad.bnd_frac(m)*bnd + (1-ad.bnd_frac(m))*ubnd;
ad.min_chi(m) = min(chi_sqr);

h = figure;

plot(wvl, d.mdata_SR(:,m),'ok','MarkerSize',6);
hold on;
plot(wvl, ad.fit_spec(:,m),'r','LineWidth', 1.5)

xlabel('Wavelength (nm)')
ylabel('Signal Normalized Intensity (counts/sec)');
legend('Data', strcat('Fit - ', 'chi =', num2str(ad.min_chi(m))));
pause

close(h);

end

figure;
ad.ps_percent = input('Input vesicle PS %');
plot(d.lipid_con*ad.ps_percent,ad.bnd_frac,'o','MarkerSize',6);
xlabel('PS concentration (uM)')
ylabel('% of max bound')

    
    
end


