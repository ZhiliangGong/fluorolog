classdef TimFluo < handle
    %Class for tryptophan fluorescence data
    %   designed for TIM protein binding to vesicles.
    %Zhiliang Gong, April 22, 2015
    
    properties
        wl %wavelength
        rd %raw data
        s %the singal
        v %volume
        ca %calcium concentration
        b %bound fractions
        bnd %bound spectrum
        ubnd %unbound spectrum
        xx %the caclium range used
        yy %the bound fraction used
        kd %the fitted kd
        bmax %bmax
        ca0 %the fitted solution residual calcium concentration
        bnd0 %the true bnd spectrum
        comment
    end
    
    methods
        %import and reduce data
        function x = TimFluo(X,n_range) %import the data
        %ns stores the # of the background, the unbound spectrum and the
        %bound spectrum
        
            %obtain the first file name and the last file name
            X = upper(X);
            
            switch nargin
                case 0
                    fname = uigetfile('*.dat','Select the file you want to import');
                    lname = uigetfile('*.dat','Select last data file in series');
                    if fname(1) ~= lname(1)
                        error('should be the same series!');
                    end
                case 1
                    fname = strcat(X,' (01)_Graph.dat');
                    k = 1;
                    name = strcat(X,' (',sprintf('%02d',k),')_Graph.dat');
                    while exist(fullfile(cd, name), 'file')
                         k = k + 1;
                         name = strcat(X,' (',sprintf('%02d',k),')_Graph.dat');
                    end            
                        lname = strcat(X,' (',sprintf('%02d',k-1),')_Graph.dat');
                case 2
                    if length(n_range) == 2
                        fname = strcat(X,' (',sprintf('%02d',n_range(1)),')_Graph.dat');
                        lname = strcat(X,' (',sprintf('%02d',n_range(2)),')_Graph.dat');
                    else
                        error('specify the first and last file number in a vector');
                    end
                otherwise
                    error('check argument for TrpFluo');
            end
            
            raw = importdata(fname);
            x.wl = raw.data(:,1);
            
            %import data
            index = regexp(fname,'(','once');
            fnum = str2double(fname(index+1:index+2));
            lnum = str2double(lname(index+1:index+2));
            int = fnum:lnum;            
            x.rd = zeros(length(x.wl),length(int));             
            for k = 1:length(int)
                name = strcat(fname(1:(length(fname)-13)),sprintf('%02d',int(k)),')_Graph.dat');
                raw = importdata(name); 
                x.rd(:,k) = raw.data(:,2);                
            end
        end
        
        function reduData(x,ca0,v0,ns) %import the data
        %ns stores the # of the background, the unbound spectrum and the
        %bound spectrum
        
            N = size(x.rd,2);
            
            if nargin >= 2
                x.ca = ca0;
                if nargin >= 3;
                    x.v = v0;
                    if nargin == 4
                        sel = [1:ns(1)-1 ns(1)+1:N];
                    else
                        ns = 1;
                        sel = 2:N;
                    end
                end
            end
            
            x.s = x.rd(:,sel) - x.rd(:,ns(1)*ones(1,N-1));
            
            if isvector(x.v) && length(x.v) == N-1;
                x.s = x.s.*repmat(x.v/1500,length(x.wl),1);
            end
            
            if nargin == 4
                x.ubnd = smooth(x.s(:,ns(2)-1));
                x.bnd = smooth(x.s(:,ns(3)-1));
            end
        end
        
        %fitting
        function linFit(x,wl_range) %fit the bound fractions of different spectra
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
        function kdFit(x,P0) %fit the Kd of the series
            %P0 contains bmax, kd, and Ca0
            if nargin == 1
                P0 = [1 100 5];
            end
            lb=[0.5 0 0];
            ub=[2 2 Inf];
            myfun = @(P) (P(1)*(x.xx+P(3))./(x.xx+P(3)+P(2))-x.yy);
            P = lsqnonlin(myfun,P0,lb,ub);
            x.yy = x.yy/P(1);
            temp_kd = P(1);
            options = optimoptions('lsqnonlin','display','off','maxiter',1e6);
            P = lsqnonlin(myfun,P0,lb,ub,options);
            x.bmax = P(1)*temp_kd;
            x.kd = P(2);
            x.ca0 = P(3);
            x.bnd0 = (x.bnd-(1-1/x.bmax)*x.ubnd)*x.bmax;
            
            figure;
            plot(x.xx,x.yy,'o','linewidth',2.4,'markersize',8);
            hold on;
            x0 = linspace(x.xx(1),x.xx(end),50);
            y0 = (x0+P(3))./(x0+P(3)+P(2));
            plot(x0,y0,'linewidth',2.4);
            hold off;
            xlabel('[Ca^{2+}] (mM)','fontsize',16);
            ylabel('Bound Fraction','fontsize',16);
            set(gca,'fontsize',14);
        end
        
        %plotting functions
        function plotSpec(x) %plot the spectrum
            colors = 'b-g-r-c-m-k-b.g.r.c.m.k.bogorocomoko';
            figure;
            hold on;
            for k = 1:size(x.s,2)
                plot(x.wl,x.s(:,k),colors((2*k-1):(2*k)),'linewidth',2.4,'markersize',8);
            end
            hold off;
            xlabel('Wavelength (nm)','fontsize',16);
            ylabel('Fluorescence Intensity (a.u.)','fontsize',16);
            set(gca,'fontsize',14,'xlim',[300 420],'xtick',[300 340 380 420]);            
        end
        function plotB(x) %plot the bound fractions
            figure;
            plot(x.ca,x.b,'o','markersize',8,'linewidth',2.4);
            xlabel('Ca^{2+} (\muM)','fontsize',16);
            ylabel('Bound Fraction','fontsize',16);
            set(gca,'fontsize',14);
        end
    end
    
end

