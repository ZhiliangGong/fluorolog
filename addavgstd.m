function tdata = addavgstd(tdata)
%average multiple runs
%Zhiliang Gong, 07/24/2012
%Zhiliang Gong, modified on 11/6/2012

m = length(tdata.wl);
tdata.aScRc = zeros(m, length(tdata.runs));%average Sc/Rc
tdata.ScRcstd = zeros(m, length(tdata.runs));%standard deviation

tdata.aSR = zeros(m, length(tdata.runs));
tdata.SRstd = zeros(m, length(tdata.runs));

tdata.aSc = zeros(m, length(tdata.runs));
tdata.Scstd = zeros(m, length(tdata.runs));

tdata.S = zeros(m, length(tdata.runs));
tdata.Sstd = zeros(m, length(tdata.runs));

choice = input('Discard some spectra? Yes (1) or No (0): ');
pos = 1;
if choice == 0
    for i = 1:length(tdata.runs)
        if tdata.runs(i) == 1
            tdata.aScRc(:,i) = tdata.nScRc(:,i);
            tdata.aSR(:,i) = tdata.nSR(:,i);
            tdata.aSc(:,i) = tdata.nSc(:,i);
            tdata.aS(:,i) = tdata.nS(:,i);
        else
            tdata.aScRc(:,i) = mean(tdata.nScRc(:,pos:(pos+tdata.runs(i)-1)),2);
            tdata.aSR(:,i) = mean(tdata.nSR(:,pos:(pos+tdata.runs(i)-1)),2);
            tdata.aSc(:,i) = mean(tdata.nSc(:,pos:(pos+tdata.runs(i)-1)),2);
            tdata.aS(:,i) = mean(tdata.nS(:,pos:(pos+tdata.runs(i)-1)),2);
        end
        if tdata.runs(i) >= 2
            tdata.ScRcstd(:,i) = sqrt(sum((tdata.nScRc(:,pos:(pos+tdata.runs(i)-1)) - repmat(tdata.aScRc(:,i),1,tdata.runs(i))).^2, 2)/(tdata.runs(i)-1));
            tdata.SRstd(:,i) = sqrt(sum((tdata.nSR(:,pos:(pos+tdata.runs(i)-1)) - repmat(tdata.aSR(:,i),1,tdata.runs(i))).^2, 2)/(tdata.runs(i) - 1));
            tdata.Scstd(:,i) = sqrt(sum((tdata.nSc(:,pos:(pos+tdata.runs(i)-1)) - repmat(tdata.aSc(:,i),1,tdata.runs(i))).^2, 2)/(tdata.runs(i) - 1));
            tdata.Sstd(:,i) = sqrt(sum((tdata.nS(:,pos:(pos+tdata.runs(i)-1)) - repmat(tdata.aS(:,i),1,tdata.runs(i))).^2, 2)/(tdata.runs(i) - 1));
        end    
        pos = pos + tdata.runs(i);
    end
else
    tdata = addsrnk(tdata);
    for i = 1:length(tdata.nruns)
        tdata.aScRc(:,i) = mean(tdata.snScRc(:,pos:(pos+tdata.nruns(i)-1)),2);
        tdata.aSR(:,i) = mean(tdata.snSR(:,pos:(pos+tdata.nruns(i)-1)),2);
        tdata.aSc(:,i) = mean(tdata.snSc(:,pos:(pos+tdata.nruns(i)-1)),2);
        tdata.aS(:,i) = mean(tdata.snS(:,pos:(pos+tdata.nruns(i)-1)),2);
        if tdata.nruns(i) >= 2
            tdata.ScRcstd(:,i) = sqrt(sum((tdata.snScRc(:,pos:(pos+tdata.nruns(i)-1)) - repmat(tdata.aScRc(:,i),1,tdata.nruns(i))).^2, 2)/(tdata.nruns(i)-1));
            tdata.SRstd(:,i) = sqrt(sum((tdata.snSR(:,pos:(pos+tdata.nruns(i)-1)) - repmat(tdata.aSR(:,i),1,tdata.nruns(i))).^2, 2)/(tdata.nruns(i) - 1));
            tdata.Scstd(:,i) = sqrt(sum((tdata.snSR(:,pos:(pos+tdata.nruns(i)-1)) - repmat(tdata.aSc(:,i),1,tdata.nruns(i))).^2, 2)/(tdata.nruns(i) - 1));
            tdata.Sstd(:,i) = sqrt(sum((tdata.snS(:,pos:(pos+tdata.nruns(i)-1)) - repmat(tdata.aS(:,i),1,tdata.nruns(i))).^2, 2)/(tdata.nruns(i) - 1));
        end    
        pos = pos + tdata.nruns(i);
    end
end

tdata.M = max(tdata.aSR(:,1));
end