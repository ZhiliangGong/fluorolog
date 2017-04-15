classdef ManageTF
    %class to manage data of class TimFluo
    %   Zhiliang Gong, May 29, 2015
    
    properties
    end
    
    methods(Static)
        function plotFluo(a) %takes in a cell array of TimFluo
            if isa(a,'TimFluo')
                a = {a};
            end
            colors = 'krgbcmy';
            wl = a{1}.wl;
            figure;
            hold on;
            for i = 1:length(a)
                plot(wl,a{i}.s(:,1),'linewidth',2.4,'color',colors(i));
            end
            hold off;
            xlabel('Wavelength','fontsize',16);
            ylabel('Intensity (a.u.)','fontsize',16);
            set(gca,'fontsize',14,'XLim',[300 420],'XTick',[300 340 380 420]);
        end
    end
end