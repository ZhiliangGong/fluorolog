classdef FluorologArray < handle
    
    properties
        
        data
        
        conc
        bndFrac
        kd
        b_max
        
        ubnds
        bnds
        
    end
    
    methods
        
        function this = FluorologArray(varargin)
            
            n = length(varargin);
            flag = true;
            for i = 1 : n
                if ~ isa(varargin{i}, 'Fluorolog')
                    flag = false;
                end
            end
            
            if ~ flag
                error('All input arguments must be of class Fluorolog.');
            else
                this.data = cell(1, n);
                this.data = varargin;
            end
            
        end
        
        % basic operations
        
        function this = push(this, fluorolog, index)
            
            if nargin == 2 || isempty(index)
                index = this.length + 1;
            end
            
            newdata = cell(1, this.length + 1);
            sel = true(1, this.length + 1);
            sel(index) = false;
            newdata(sel) = this.data;
            newdata{index} = fluorolog;
            this.data = newdata;
            
        end
        
        function addUbnd(this, ubnd)
            
            this.ubnds = [this.ubnds, ubnd];
            
        end
        
        function addBnd(this, bnd)
            
            this.bnds = [this.bnds, bnd];
            
        end
        
        function unbound = unbound(this)
            
            unbound = mean(this.ubnds, 2);
            
        end
        
        % fitting
        
        function fitBoundFractions(this)
            
            bnd = this.meanBnd();
            ubnd = this.meanUbnd();
            
            fracs = zeros(1, this.length);
            
            for i = 1 : this.length
                fracs(i) = Fluorolog.linearCombination(this.data{i}.spectra(:, 1), ubnd, bnd);
            end
            
            this.bndFrac = fracs;
            
        end
        
        function fitKd(this)
            
            [this.kd, this.b_max] = Fluorolog.oneSiteSpecificFit(this.conc, this.bndFrac);
            
        end
        
        % utility
        
        function n = length(this)
            
            n = length(this.data);
            
        end
        
        function bnd = meanBnd(this)
            
            bnd = mean(this.bnds, 2);
            
        end
        
        function ubnd = meanUbnd(this)
            
            ubnd = mean(this.ubnds, 2);
            
        end
        
        function wl = wl(this, n)
            
            wl = this.data{1}.wl;
            if nargin == 2
                wl = wl(n);
            end
            
        end
        
        % plotting
        
        function overlay(this)
            
            this.plotFluorologArray(this.data);
            
        end
        
        function plotKdFit(this)
            
            figure;
            plot(this.conc, this.bndFrac * this.b_max, 's', 'markersize', 12, 'linewidth', 2.4);
            hold on;
            
            fineConc = linspace(min(this.conc), max(this.conc), 100);
            fineBoundFrac = fineConc ./ (fineConc + this.kd);
            
            plot(fineConc, fineBoundFrac, '-', 'linewidth', 2.4);
            
            xlabel('Concentration', 'fontsize', 16);
            ylabel('Bound Fraction', 'fontsize', 16);
            title(['Kd = ', num2str(this.kd)]);
            set(gca, 'fontsize', 14, 'ylim', [0 1], 'ytick', [0 0.5 1]);
            
        end
        
        function compareUbndBnd(this)
            
            ax = this.plotSpectrum(this.wl, this.meanUbnd);
            hold(ax, 'on');
            this.plotSpectrum(this.wl, this.meanBnd, ax);
            hold(ax, 'off');
            legend(ax, {'Unbound', 'Bound'});
            
        end
        
    end
    
    methods (Static)
        
        % plot
        
        function plotFluorologArray(arr, ax)
            
            if nargin == 1 || isempty(ax)
                figure;
                ax = gca;
            end
            
            hold(ax, 'on');
            legends = cell(1, length(arr));
            for i = 1 : length(arr)
                legends{i} = num2str(i);
                plot(ax, arr{i}.wl, arr{i}.spectra(:, 1), FluorologArray.lineSpec(i), 'linewidth', 2, 'markersize', 8);
            end
            hold(ax, 'off');
            xlabel(ax, 'Wavelength (nm)', 'fontsize', 16);
            ylabel(ax, 'Fluorescence Intensity (a.u.)', 'fontsize', 16);
            legend(ax, legends);
            set(ax,'fontsize', 14);
            
        end
        
        function ax = plotSpectrum(wl, spec, ax)
            
            if nargin == 2 || isempty(ax)
                figure;
                ax = gca;
            end
            
            plot(ax, wl, spec, 'linewidth', 2, 'markersize', 8);
            xlabel(ax, 'Wavelength (nm)', 'fontsize', 16);
            ylabel(ax, 'Fluorescence Intensity (a.u.)', 'fontsize', 16);
            set(ax,'fontsize', 14);
            
        end
        
        % utility
        
        function spec = lineSpec(n)
            
            cs = FluorologArray.colors;
            ss = FluorologArray.symbols;
            
            colorInd = mod(n, length(cs));
            symbolInd = floor(n / length(cs)) + 1;
            
            color = FluorologArray.cycle(colorInd, cs);
            symbol = FluorologArray.cycle(symbolInd, ss);
            
            spec = [color, symbol];
            
        end
        
        function elem = cycle(n, array)
            
            ind = mod(n, length(array));
            if ind == 0
                ind = length(array);
            end
            elem = array(ind);
            
        end
        
        % constants
        
        function colors = colors
            
            colors = 'kbrmcgy';
            
        end
        
        function symbols = symbols
            
            symbols = 'os^vd><ph';
            
        end
        
    end
    
end