function tdata = addsrnk(tdata)
%add shrinked net data set
%Zhiliang Gong, 07/24/2012
%Zhiliang Gong, modified on 11/08/2012
%Zhiliang Gong, modified on 11/15/2012

tdata.nruns = tdata.runs;
colors = 'k-g-b-r-c-m-k.g.b.r.c.m.k+g+b+r+c+m+';
n_pos = 0;
sel = []; %indices of spectra to be selected

%getting the out vector which contains the indexes of the to-be-discarded
%net data sets
for i = 1:length(tdata.runs)
    figure; %graphing for a specific lipid concentration
    for j = 1:(tdata.runs(i))            
        n_pos = n_pos + 1;
        plot(tdata.wl,tdata.nSR(:,n_pos),colors((2*j-1):(2*j)));
        hold on;
    end
    hold off;
    if isfield(tdata,'ps')
        s = strcat('Lipid: ', sprintf('%02d',tdata.lcons(i)), 'uM, Protein: ', sprintf('%02d',tdata.pcons(i)), 'nM, ', tdata.buffer, ', ', sprintf('%02d',tdata.ps*100),'% PS');
    else
        s = strcat('Lipid: ', sprintf('%02d',tdata.lcons(i)), 'uM, Protein: ', sprintf('%02d',tdata.pcons(i)), 'nM, ', tdata.buffer, ', ', sprintf('%02d',tdata.PS*100),'% PS');
    end
    title(s);
    xlabel('wavelength (nm)');
    ylabel('S/R Intensity');
    legend('show');
    
    dtemp = input('Choose the graph(s) to be discarded (0 if none): ');
    if length(dtemp) == 1
        if dtemp == 0
            sel = [sel (n_pos-tdata.runs(i)+1):n_pos];
        else
            sel = [sel (n_pos-tdata.runs(i)+1):(n_pos-tdata.runs(i)+dtemp-1) (n_pos-tdata.runs(i)+dtemp+1):n_pos];
            tdata.nruns(i) = tdata.nruns(i) - 1;
        end
    else
        tdata.nruns(i) = tdata.nruns(i) - length(dtemp);
        dtemp = sort(dtemp);%arrange to-be-discarded spectra in increasing order
        for k = 1:length(dtemp)
            if k == 1
                sel = [sel (n_pos-tdata.runs(i)+1):(n_pos-tdata.runs(i)+dtemp(k)-1)];
            elseif k == length(dtemp)
                sel = [sel (n_pos-tdata.runs(i)+1+dtemp(k):n_pos)];
            else
                sel = [ sel ((n_pos-tdata.runs(i)+1+dtemp(k-1)):(n_pos-tdata.runs(i)+dtemp(k)-1))];
            end
        end
    end
end

tdata.snScRc = tdata.nScRc(:,sel);
tdata.snSR = tdata.nSR(:,sel);
tdata.snSc = tdata.nSc(:,sel);
tdata.snS = tdata.nS(:,sel);

end