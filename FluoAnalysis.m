function s = FluoAnalysis( s )
%The control panel of fluorescence data gathered from Fluorolog-3 analysis.
%   shows all the available options for the current data set

if nargin == 0
    disp('You did not enter a data set.');
    disp('Press 0 if this is an error;');
    disp('Or press 1 to import a data set.');
    x = input('Choose: ');
    switch x
        case 0
            s = input('s = ');
        case 1
            s = comgetdata;
        otherwise
            disp('No such choice!');
    end
end

choice = 7; %initialize the choice, outside the range.
while choice ~= 0
    disp('-----------------------------Menu----------------------------------');
    disp('1-----------add experimental conditions and parameters to data set;');
    disp('2----------------------------------add blanked spectra to data set;');
    disp('3-----------add average spectra and standard deviation to data set;');
    disp('4-------------plot all the average spectra together with errorbars;');
    disp('5----------------------plot the bound and unbound spectra together;');
    disp('6----------------------------------------------------plot the fits;');
    disp('7-------------------------------------------plot the binding curve;');
    disp('0-------------------------------------------------------------quit.');
    choice = input('Choose: ');
    switch choice
        case 1
            s = addpara(s);
        case 2
            s = addnet(s);
        case 3
            s = addavgstd(s);
        case 4
            comdraw(s);
        case 5
            r = max(s.aSR(:,end))/max(s.aSR(:,1));
            plot(s.wl,s.aSR(:,1),'b',s.wl,s.aSR(:,end),'r','LineWidth',2.4);
            xlabel('wavelength (nm)','FontSize',12);
            ylabel('S/R counts','FontSize',12);
            title_string = strcat(s.comments, 'Max_{bound}/Max_{unbound} = ', sprintf('%.2f', r));
            title(title_string, 'FontSize', 12);
            legend('unbound spectrum','bound spectrum');
        case 6
            choice = input('Use existing saturation spectrum (Y/N): ', 's');
            if choice == 'Y' || choice == 'y'
                B = input('Enter the variable name of the unit bound spectrum: ');
                s = fluofit(s, B);
            else
                bound_ind = input('Index of the bound spectra (enter 0 if the last one): ');
                if bound_ind == 0
                    s = fluofit(s);
                else
                    s = fluofit(s, s.aSR(:, bound_ind)/mean(s.pcons)); %specify the unit bound spectra
                end
            end
        case 7
            plot(s.PS*s.lcons,s.b,'o','LineWidth',2.4,'MarkerSize',12);
        otherwise
            continue;
    end
end    

end

