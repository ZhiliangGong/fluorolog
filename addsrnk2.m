function tdata = addsrnk(tdata)
%add shrinked net data set
%Zhiliang Gong, 07/24/2012
%Zhiliang Gong, modified on 11/08/2012
%Zhiliang Gong, modified on 11/15/2012

tdata.nruns = tdata.runs;
colors = 'kgbrcmykgbrcmy';
n_pos = 0;
out_pos = 0;%number of to be discarded spectra
out = [];

%getting the out vector which contains the indexes of the to-be-discarded
%net data sets
for i = 1:length(tdata.runs)
    figure; %graphing for a specific lipid concentration
    for j = 1:(tdata.runs(i))            
        n_pos = n_pos + 1;
        plot(tdata.wl,tdata.nSR(:,n_pos),colors(j));
        hold on;
    end
    hold off;
    s = strcat('Lipid: ', sprintf('%02d',tdata.lcons(i)), 'uM, Protein: ', sprintf('%02d',tdata.pcons(i)), 'nM, ', tdata.buffer, ', ', sprintf('%02d',tdata.PS*100),'% PS');
    title(s);
    xlabel('wavelength (nm)');
    ylabel('S/R Intensity');
    switch tdata.runs(i)
        case 1
            legend('1');
        case 2
            legend('1','2');
        case 3
            legend('1','2','3');
        case 4
            legend('1','2','3','4');
        case 5
            legend('1','2','3','4','5');
        case 6
            legend('1','2','3','4','5','6');
        case 7
            legend('1','2','3','4','5','6','7');
        case 8
            legend('1','2','3','4','5','6','7','8');
        otherwise
            disp('Too many runs for legend!')
    end
    
    dtemp = input('Choose the graph(s) to be discarded (0 if none): ');
    if length(dtemp) == 1
        if dtemp == 0
            continue;
        else
            out_pos = out_pos + 1;
            out(out_pos) = n_pos - (tdata.runs(i) - dtemp);            
            tdata.nruns(i) = tdata.nruns(i) - 1;
        end
    else
        out_pos = out_pos + length(dtemp);
        tdata.nruns(i) = tdata.nruns(i) - length(dtemp);
        out((out_pos-tdata.nruns(i)+1):out_pos) = n_pos - (tdata.nruns(i) - dtemp);
    end
end

[m, n] = size(tdata.nSR);
tdata.snScRc = zeros(m, n - length(out));
tdata.snSR = zeros(m, n - length(out));
tdata.snSc = zeros(m, n - length(out));
tdata.snS = zeros(m, n - length(out));

stay = zeros(1,n - length(out));

pos = 1;
for i = 1:n
    if isempty(find(out==i))
        stay(pos) = i;
        pos = pos + 1;
    else
        continue
    end
end
out
tdata.snScRc = tdata.nScRc(:,stay);
tdata.snSR = tdata.nSR(:,stay);
tdata.snSc = tdata.nSR(:,stay);
tdata.snS = tdata.nSR(:,stay);

end