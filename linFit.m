function x = linFit(x,wl_range) %fit the bound fractions of different spectra
            b0 = 0:0.01:1;
            n = size(x.s,2);
            
            if nargin == 2
                i = (wl_range(1)-x.wl(1))/2+1;
                j = length(x.wl)-(x.wl(end)-wl_range(2))/2;
            elseif nargin == 1
                i = 1;
                j = length(x.wl);
            else
                error('check arguments');
            end
            
            bnd0 = x.bnd(i:j);
            ubnd0 = x.ubnd(i:j);
            fits = bnd0*b0+ubnd0*(1-b0);
            x.b = zeros(1,n);
            
            figure;
            for k = 1:n
                chi2sum = sum(((repmat(x.s(i:j,k),1,101) - fits)).^2);
                good_n = find(min(chi2sum)==chi2sum);
                x.b(k) = (good_n-1)/100;
                plot(x.wl(i:j),x.s(i:j,k),'o',x.wl(i:j),bnd0*b0(good_n)+ubnd0*(1-b0(good_n)));
                hold on;
            end
            hold off;
end