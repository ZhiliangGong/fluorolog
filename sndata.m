function tdata = sndata( t1, t2)
%syndata Summary of this function goes here
%   synthezie different data sets into one

tdata.wl = t1.wl;
switch nargin
    case 1
        disp('Not enough arguments!');
    case 2
        tdata.nS = [t1.nS t2.nS];
        tdata.nSc = [t1.nSc t2.nSc];
        tdata.nSR = [t1.nSR t2.nSR];
        tdata.nScRc = [t1.nScRc t2.nScRc];
    otherwise
        disp('Too many arguments!');
end
end

