function tdata = getdata(X,n) %raw fluorolog data where wavelength is the first column
%function to import data from Fluorolog-3 *.dat data exported by the Origin
%on the computer.
%Zhiliang Gong, 7/24/2012
%modified on 11/6/2012 by Zhiliang Gong
%modified on 12/14/2012 by Zhiliang Gong
%modified on 11/14/2013 by Zhiliang Gong
%modified on 7/11/2014 by Zhiliang Gong
%modified on 7/26/2014 by Zhiliang Gong

%either 0 argument, 1 argument, or 2 arguments
switch nargin
    
    case 0
        
        fname = uigetfile('*.dat','Select the file you want to import');
        lname = uigetfile('*.dat','Select last data file in series');
        
        raw = importdata(fname);
        tdata.wl = raw.data(:,1); % the wavelength range, which should be the same for all series
        
        fser = fname(1); %the first series, so that different series could be imported
        lser = lname(1); %the last series
        
        if fser == lser %only one series to import, or more
            
            fnum = str2double(strcat(fname(length(fname)-12), fname(length(fname)-11)));
            %index of the first file
            lnum = str2double(strcat(lname(length(lname)-12), lname(length(lname)-11))); 
            %index of the last file
            
            int = fnum:lnum; %the index series
            
            %initializing the tdata variable
            tdata.SR = zeros(length(tdata.wl),length(int)); %this is the signal normalized by lamp amptitude
            tdata.Sc = tdata.SR; %signal corrected for detector sensitivity
            tdata.ScRc = tdata.SR; %lamp amptitude and detector sensitivity
            tdata.S = tdata.SR; %original counts
            tdata.R = tdata.SR; %lamp amptitude
            
            for k = 1:length(int)
                
                name = strcat(fname(1:(length(fname)-13)),sprintf('%02d',int(k)),')_Graph.dat');
                raw = importdata(name);
                
                if length(tdata.wl) == 61
                    
                    tdata.SR(:,k) = raw.data(:,2);
                    tdata.Sc(:,k) = raw.data(:,4);
                    tdata.ScRc(:,k) = raw.data(:,6);
                    tdata.S(:,k) = raw.data(:,8);
                    tdata.R(:,k) = raw.data(:,10);
                    
                else
                    
                    tdata.SR(:,k)=raw.data(:,2);
                    
                end
                
            end
            
        else %if more than one series to import
            
            runs = input('Please input number of measurements array: ');
            
            %number of series must agree with the range of series elected
            while length(runs) ~= (lser-fser+1)
                
                disp('Your inputed array has a wrong length!');
                runs = input('Please input number of measurements for each series: ');
                
            end
            
            tdata.runs =runs;
            tdata.SR = zeros(length(tdata.wl), sum(runs)); %normalized by lamp amptitude
            tdata.Sc = tdata.SR; %signal corrected for detector sensitivity
            tdata.ScRc = tdata.SR; %lamp amptitude and detector sensitivity
            tdata.S = tdata.SR; %original counts
            tdata.R = tdata.SR; %lamp amptitude
            
            n = 1; %the index of data columns
            
            for k = 1:(lser-fser+1)

                for m = 1:runs(k)
                
                    name = strcat(char(fser+k-1),fname(2:length(fname)-13),sprintf('%02d',m),')_Graph.dat');
                    raw = importdata(name);
                    
                    tdata.SR(:,n) = raw.data(:,2);
                    tdata.Sc(:,n) = raw.data(:,4);
                    tdata.ScRc(:,n) = raw.data(:,6);                    
                    tdata.S(:,n) = raw.data(:,8);
                    tdata.R(:,n) = raw.data(:,10);
                    
                    n = n + 1;
                
                end
                
            end
            
        end
        
    case {1, 2}
        
        fname = strcat(X,' (01)_Graph.dat');
        raw = importdata(fname);
        tdata.wl = raw.data(:,1);
        
        if nargin == 1
        
            n = 0; %number of existing data files for this series (data identifier)
            name = strcat(fname(1:(length(fname)-13)),sprintf('%02d',n+1),')_Graph.dat');
            
            while exist(fullfile(cd, name), 'file')

                n = n + 1;
                name = strcat(fname(1:(length(fname)-13)),sprintf('%02d',n+1),')_Graph.dat');

            end
            
        end

        tdata.SR = zeros(length(tdata.wl),n); %this is the signal normalized by lamp amptitude
        tdata.Sc = tdata.SR; %signal corrected for detector sensitivity
        tdata.ScRc = tdata.SR; %lamp amptitude and detector sensitivity
        tdata.S = tdata.SR; %original counts
        tdata.R = tdata.SR; %lamp amptitude
        
        for k = 1:n
            
            name = strcat(fname(1:(length(fname)-13)),sprintf('%02d',k),')_Graph.dat');
            raw = importdata(name);
            
            tdata.SR(:,k) = raw.data(:,2);
            tdata.Sc(:,k) = raw.data(:,4);
            tdata.ScRc(:,k) = raw.data(:,6);
            tdata.S(:,k) = raw.data(:,8);
            tdata.R(:,k) = raw.data(:,10);
            
        end
        
    otherwise
        
        disp('check your arguments!');

end
    
end