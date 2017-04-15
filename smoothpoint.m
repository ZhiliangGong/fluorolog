function [ x ] = smoothpoint( x, w, n )
%function to smooth out spikes in SR signal of the Fluorolog-3 data
%   linear extrapolation
%7/26/2014, Zhiliang Gong

%m is the wavelength at which the data point should be smoothed
%n is the index of the spectrum of interest
if length(w) ~= length(n)
    
    disp('m and n must be the same length');
    
else
    
    for k = 1:length(w)
        
        x.nSR((w(k)-x.wl(1))/2+1,n(k)) = mean([x.nSR((w(k)-x.wl(1))/2,n(k)),x.nSR((w(k)-x.wl(1))/2+2,n(k))]);
        
    end
    
end

end

