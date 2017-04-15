function tdata = addnet(tdata) %wavelength is the first column
%subtract blank
%Zhiliang Gong, 07/24/2012
%Zhiliang Gong, modified on 11/6/2012
%Zhiliang Gong, modified on 12/12/2012

disp('Have one blank for each single spectrum: 1');
disp('Have one for each lipid concentration: 2');
choice = input('Choose: ');

switch choice
    case 1
        tdata.nScRc = tdata.ScRc(:,2:2:end) - tdata.ScRc(:,1:2:end);
        tdata.nSR = tdata.SR(:,2:2:end) - tdata.SR(:,1:2:end);
        tdata.nSc = tdata.Sc(:,2:2:end) - tdata.Sc(:,1:2:end);
        tdata.nS = tdata.S(:,2:2:end) - tdata.S(:,1:2:end);
    case 2
        tdata.nS = zeros(length(tdata.wl),size(tdata.S,2)-length(tdata.lcons));
        tdata.nSR = tdata.nS;
        tdata.nSc = tdata.nS;
        tdata.nScRc = tdata.nS;
        pos = 1;
        for i = 1:length(tdata.lcons)
            tdata.nS(:, pos:(pos+tdata.runs(i)-1)) = tdata.S(:, (pos+i):(pos+i+tdata.runs(i)-1)) - repmat(tdata.S(:, pos+i-1), 1, tdata.runs(i));
            tdata.nSR(:, pos:(pos+tdata.runs(i)-1)) = tdata.SR(:, (pos+i):(pos+i+tdata.runs(i)-1)) - repmat(tdata.SR(:, pos+i-1), 1, tdata.runs(i));
            tdata.nSc(:, pos:(pos+tdata.runs(i)-1)) = tdata.Sc(:, (pos+i):(pos+i+tdata.runs(i)-1)) - repmat(tdata.Sc(:, pos+i-1), 1, tdata.runs(i));
            tdata.nScRc(:, pos:(pos+tdata.runs(i)-1)) = tdata.ScRc(:, (pos+i):(pos+i+tdata.runs(i)-1)) - repmat(tdata.ScRc(:, pos+i-1), 1, tdata.runs(i));
            pos = pos + tdata.runs(i);
        end
    otherwise
        disp('No such a choice!');
end

end