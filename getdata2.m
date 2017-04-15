function tdata = getdata2 %raw fluorolog data where wavelength is the first column
%function to import data
%Zhiliang Gong, 7/24/2012
%modified on 11/6/2012 by Zhiliang Gong
%modified on 12/14/2012 by Zhiliang Gong
%renamed from getdata to getdata2 to make further modifications

fname = uigetfile('*.dat','Select the file you want to import');
lname = uigetfile('*.dat','Select last data file in series');

fser = fname(1); %the first series
lser = lname(1); %the last series

if fser == lser

    fnum = str2double(strcat(fname(length(fname)-12), fname(length(fname)-11))); 
    lnum = str2double(strcat(lname(length(lname)-12), lname(length(lname)-11))); 
    int = fnum:lnum;

    raw = importdata(fname);
    wl = raw.data(:,1);

    if fnum == lnum
        raw = importdata(fname);
        ScRc = raw.data(:,6);
        SR = raw.data(:,2);
        S = raw.data(:,8);
        Sc = raw.data(:,4);
    else
        ScRc = zeros(length(wl),length(int));
        SR = zeros(length(wl),length(int));
        S = zeros(length(wl),length(int));
        Sc = zeros(length(wl),length(int));
        for i = 1:length(int)
            name = strcat(fname(1:(length(fname)-13)),sprintf('%02d',int(i)),')_Graph.dat');
            raw = importdata(name);
            ScRc(:,i) = raw.data(:,6);
            SR(:,i) = raw.data(:,2);
            S(:,i) = raw.data(:,8);
            Sc(:,i) = raw.data(:,4);
        end
    end

else
   
    raw = importdata(fname);
    wl = raw.data(:,1);
    ScRc = zeros(length(wl),6*(lser-fser+1));
    SR = ScRc;
    S = ScRc;
    Sc = ScRc;
    for i = 1:(lser-fser+1)
        for j = 1:6
            name = strcat(char(lser+i-1),fname(2:length(fname)-13),sprintf('%02d',j),')_Graph.dat');
            raw = importdata(name);
            ScRc(:,6*(i-1)+j) = raw.data(:,6);
            SR(:,6*(i-1)+j) = raw.data(:,2);
            S(:,6*(i-1)+j) = raw.data(:,8);
            Sc(:,6*(i-1)+j) = raw.data(:,4);
        end
    end
end


    tdata.ScRc = ScRc;
    tdata.SR = SR;
    tdata.S = S;
    tdata.Sc = Sc;
    tdata.wl = wl;
end
