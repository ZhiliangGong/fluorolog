classdef Fluorolog < handle
    
    properties
        
        rawdata
        rawSpectra
        n_back
        
        wl
        spectra
        
        bnd
        ubnd
        conc
        bndFracs
        b_max
        b_min
        kd
        
        comment
        
    end
    
    methods
        
        function this = Fluorolog(letter, n_range, n_back)
            
            if nargin == 1
                n_range = [];
                n_back = [];
            end
            
            files = this.getDataFileNames(letter, n_range);
            n = length(files);
            
            for i = 1 : n
                
                this.rawdata{i} = importdata(files{i});
                
                if i == 1
                    this.wl = this.rawdata{i}.data(:, 1);
                    this.rawSpectra = zeros(length(this.wl), n);
                end
                
                this.rawSpectra(:, i) = this.rawdata{i}.data(:, 2);
                
            end
            
            if isempty(n_back)
                
                this.n_back = 1;
                
            end
            
            this.subtractBackground();
            
        end
        
        function subtractBackground(this)
            
            [m, n] = size(this.rawSpectra);
            this.spectra = zeros(m, n - 1);
            
            k = 1;
            for i = 1 : n
                if i ~= this.n_back
                    this.spectra(:, k) = this.rawSpectra(:, i) - this.rawSpectra(:, this.n_back);
                    k = k + 1;
                end
            end
            
        end
        
        function fitBoundFractions(this, ubnd, bnd)
            
            if nargin > 1
                this.ubnd = ubnd;
                if nargin > 2
                    this.bnd = bnd;
                end
            end
            
            if isempty(this.ubnd)
                this.ubnd = this.spectra(:, 1);
            end
            
            if isempty(this.bnd)
                this.bnd = this.spectra(:, end);
            end
            
            n = this.num();
            this.bndFracs = zeros(1, n);
            
            factor = max(this.ubnd);
            ubnd_norm = this.ubnd / factor;
            bnd_norm = this.bnd / factor;
            
            norm_factor = max(this.spectra(:, this.n_back));
            
            for i = 1 : n
                spectrum = this.spectra(:, i) / norm_factor;
                this.bndFracs(i) = this.linearCombination(spectrum, ubnd_norm, bnd_norm);
            end
            
        end
        
        function kdFit(this, ub_kd)
            
            this.fitBoundFractions();
            
            if nargin > 1
                ub = [ub_kd, 1];
            else
                ub = [Inf, 1];
            end
            lb = [1e-6, 0];
            
            if isempty(this.conc)
                error('input the concentartons');
            else
               fitFun = @(p) (this.conc ./ (this.conc + p(1)) - this.bndFracs * p(2));
               options = optimoptions('lsqnonlin', 'display', 'off');
               paras = lsqnonlin(fitFun, [1e-6, 1], lb, ub, options);
               this.kd = paras(1);
               this.b_max = paras(2);
            end
            
        end
        
        % plot
        
        function h = plotSpectra(this, sel)
            
            n = size(this.spectra, 2);
            if nargin == 1
                sel = 1 : n;
            end
            
            legends = cell(1, numel(sel));
            
            figure;
            h = gca;
            hold on;
            k = 1;
            for i = sel
                ydata = this.spectra(:, i);
                ydata(ydata < 0) = 0;
                plot(this.wl, ydata, this.lineSpec(k), 'linewidth', 2.4, 'markersize', 8);
                legends{k} = num2str(i);
                k = k + 1;
            end
            hold off;
            
            xlabel('Wavelength (nm)','fontsize',16);
            ylabel('Fluorescence Intensity (a.u.)','fontsize',16);
            legend(legends);
            set(gca,'fontsize',14);  
            
        end
        
        function plotBoundFractions(this)
            
            figure;
            plot(this.conc, this.bndFracs, '-s', 'markersize', 12, 'linewidth', 2.4);
            xlabel('Concentration', 'fontsize', 16);
            ylabel('Bound Fraction', 'fontsize', 16);
            set(gca, 'fontsize', 14, 'ytick', [0 0.5 1]);
            
        end
        
        function plotKdFit(this)
            
            figure;
            plot(this.conc, this.bndFracs * this.b_max, 's', 'markersize', 12, 'linewidth', 2.4);
            hold on;
            
            fineConc = linspace(min(this.conc), max(this.conc), 100);
            fineBoundFrac = fineConc ./ (fineConc + this.kd);
            
            plot(fineConc, fineBoundFrac, '-', 'linewidth', 2.4);
            
            xlabel('Concentration', 'fontsize', 16);
            ylabel('Bound Fraction', 'fontsize', 16);
            title(['Kd = ', num2str(this.kd)]);
            set(gca, 'fontsize', 14, 'ylim', [0 1], 'ytick', [0 0.5 1]);
            
        end
        
        % utility
        
        function n = num(this)
            
            n = size(this.spectra, 2);
            
        end
        
        function b = realBoundFractions(this)
            
            b = (this.b_max - this.b_min) * this.bndFracs + this.b_min;
            
        end
        
    end
    
    methods (Static)
        
        function files = getDataFileNames(letter, n_range)
            
            letter = upper(letter);
            path = pwd;
            
            if nargin == 1 || isempty(n_range)
                
                k = 1;
                name = strcat(letter,' (',sprintf('%02d',k),')_Graph.dat');
                while exist(fullfile(path, name), 'file')
                    k = k + 1;
                    name = strcat(letter,' (',sprintf('%02d',k),')_Graph.dat');
                end
                n_range = 1 : k - 1;
                files = Fluorolog.getDataFileNames(letter, n_range);
                
            else
                
                files = cell(1, length(n_range));
                for i = n_range
                    files{i} = fullfile(path, strcat(letter, ' (', sprintf('%02d', n_range(i)), ')_Graph.dat'));
                end
                
            end
            
        end
        
        function spec = lineSpec(n)
            
            cs = Fluorolog.colors;
            ss = Fluorolog.symbols;
            
            colorInd = mod(n, length(cs));
            symbolInd = floor(n / length(cs)) + 1;
            
            color = Fluorolog.cycle(colorInd, cs);
            symbol = Fluorolog.cycle(symbolInd, ss);
            
            spec = [color, symbol];
            
        end
        
        function c = color(n)
            
            cs = Fluorolog.colors;
            index = mod(n, length(cs));
            if index == 0
                index = length(cs);
            end
            
            c = cs(index);
            
        end
        
        function s = symbol(n)
            
            ss = Fluorolog.symbols;
            index = mod(n, length(ss));
            if index == 0
                index = length(ss);
            end
            s = ss(index);
            
        end
        
        
        function bound_frac = linearCombination(spec, ubnd, bnd)
            
            spec(spec < 0) = 0;
            bnd(bnd < 0) = 0;
            ubnd(ubnd < 0) = 0;
            
            options = optimoptions('lsqnonlin', 'display', 'off');
            fitFun = @(b) (b * bnd + (1 - b) * ubnd - spec);
            bound_frac = lsqnonlin(fitFun, 0, 0, 1, options);
            
        end
        
        % utility
        
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

