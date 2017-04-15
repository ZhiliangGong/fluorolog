function comdraw(tdata)
%comdraw.m
%draw the series
%Zhiliang Gong, 9/1/2012

colors = 'k-g-b-r-c-m-k.g.b.r.c.m.k+g+b+r+c+m+';

choice = input('Normalized intensity (1) or original S/R counts (2)? Choose: ');
while choice ~= 1 && choice ~= 2
    choice = input('Normalized intensity (1) or original S/R counts (2)? Choose: ');
end

figure;
if isfield(tdata, 'SRstd')
    for i = length(tdata.runs):-1:1
        if choice == 2
            if sum(tdata.SRstd(:,i).^2) > 0
                errorbar(tdata.wl,tdata.aSR(:,i),tdata.SRstd(:,i)/2,tdata.SRstd(:,i)/2,colors((2*i-1):(2*i)));
            else
                plot(tdata.wl,tdata.aSR(:,i),colors((2*i-1):(2*i)));
            end
            hold on;
        elseif choice == 1
            if sum(tdata.SRstd(:,i).^2) > 0
                errorbar(tdata.wl,tdata.aSR(:,i)/tdata.M,tdata.SRstd(:,i)/2/tdata.M,tdata.SRstd(:,i)/2/tdata.M,colors((2*i-1):(2*i)));
            else
                plot(tdata.wl,tdata.aSR(:,i)/tdata.M,colors((2*i-1):(2*i)));
            end
            hold on;
        end
    end
else
    for i = length(tdata.runs):-1:1
        if choice == 2
            plot(tdata.wl,tdata.aSR(:,i),colors((2*i-1):(2*i)));
            hold on;
        elseif choice == 1
            plot(tdata.wl,tdata.aSR(:,i)/tdata.M,colors((2*i-1):(2*i)));
            hold on;
        end
    end
end

if choice == 2
    axis([300 420 0 max(max(tdata.aSR))*1.05]);
    hold off
    s = strcat('Spectroscopy');
    title(s,'FontSize',12);
    xlabel('wavelength (nm)','FontSize',12);
    ylabel('average S/R','FontSize',12);
elseif choice == 1
    axis([300 420 0 max(max(tdata.aSR))/tdata.M*1.05]);
    hold off
    s = strcat('Spectroscopy');
    title(s,'FontSize',12);
    xlabel('wavelength (nm)','FontSize',12);
    ylabel('normalized S/R','FontSize',12);
end

for i = 1:length(tdata.runs)
    nleg{i} = tdata.leg{length(tdata.runs) - i +1};
end
legend(nleg);

end