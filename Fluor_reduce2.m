
function [ d ] = Fluor_reduce2( spec_num )
%Function to reduce data from Fluor-log 3 in Biophysics core
%Store all data in a d. data structure



%Get File names for import


series_name = input('Input Series names in order from low to high concentration: ');
d.lipid_con = input('Input Matching Lipid Concentration series: ');

color = ['b' 'k' 'r' 'm' 'g' 'c'];

for s = 1:length(series_name)
    
    for r = 1:spec_num
        
        if r == 1
    
            %Import Blank:

            blank_name = strcat(series_name(s) , ' (0',num2str(r),')_Graph.dat');
            blank = importdata(blank_name);
            blank = blank.data;

            blank_SR = blank(:,2);
            blank_Sc = blank(:,4);
            blank_ScRc = blank(:,6);
            blank_S = blank(:,8);
            

        else
            
            data_name = strcat(series_name(s) , ' (0',num2str(r),')_Graph.dat');
            rawdata = importdata(data_name);
            rawdata = rawdata.data;

            d.wvl = rawdata(:,1);
            rdata_SR(:,r) = rawdata(:,2) - blank_SR;
            rdata_Sc(:,r) = rawdata(:,4) - blank_Sc;
            rdata_ScRc(:,r) = rawdata(:,6) - blank_ScRc;
            rdata_S(:,r) = rawdata(:,8) - blank_S;
            
            %plot(d.wvl,rdata_SR(:,r),color(r-1));
            %title(num2str(d.lipid_con(2)));
            %hold on;
            %pause;
            %d.lipid_con(s)
            
           
            
        end
            
    end

    close
    %Take mean of data series:
    
        
    for j = 1:size(rdata_SR,1)
        
        d.mdata_SR(j,s) = mean(rdata_SR(j,:));
        d.std_SR(j,s) = std(rdata_SR(j,:));
        
        d.mdata_Sc(j,s) = mean(rdata_Sc(j,:));
        d.std_Sc(j,s) = std(rdata_Sc(j,:));
        
        d.mdata_ScRc(j,s) = mean(rdata_ScRc(j,:));
        d.std_ScRc(j,s) = std(rdata_ScRc(j,:));
        
        d.mdata_S(j,s) = mean(rdata_S(j,:));
        d.std_S(j,s) = std(rdata_S(j,:));  
   
    end
    
    
end
        
        
        
        
        
        
   