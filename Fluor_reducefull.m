function [ d ] = Fluor_reducefull( con, plotopt )
%Function to reduce data from Fluor-log 3 in Biophysics core
%Store all data in a d. data structure
%Averages spectra from repeat conditions

color = 'brkmgcybrkmgcybrkmgcybrkmgcybrkmgcybrkmgcy';

%Get File names for import
for j = 1:length(con)
    
    %Group series by concentration values:
    d.lipid_con(j) = con(j);
    series_name = input(['Input series to be averaged for ' num2str(con(j)) ':'],'s');
    
    for s = 1:length(series_name)
        
        for r = 1:3
            
            if r == 1

                %Import Blank:

                blank_name = strcat(series_name(s) , ' (0',num2str(r),')_Graph.dat');
                blank = importdata(blank_name);
                blank = blank.data;

                blank_SR = blank(:,2);


            else
                
                %Import data and blank subtract
                data_name = strcat(series_name(s) , ' (0',num2str(r),')_Graph.dat');
                rawdata = importdata(data_name);
                rawdata = rawdata.data;

                d.wvl = rawdata(:,1);
                rdata_SR = rawdata(:,2) - blank_SR;
                
                if plotopt ==1 
                    
                    if r == 2
                        
                        figure(1)
                        plot(d.wvl,rdata_SR,'b','LineWidth', 1.3);
                        title(['Series' series_name(s) ': ' num2str(con(j))]);
                        hold on;
                        
                    elseif r==3
                        hold on;
                        plot(d.wvl,rdata_SR,'r','LineWidth', 1.3)
                        
                        pause;
                        
                    end
                    
                end
                    
                
                if r == 3
                    
                    d.mdata_SR(:,s,j) = rdata_SR;
                    
                end
                 

            end
            
        end
        
        if plotopt ==1
        figure(2)
        plot(d.wvl,d.mdata_SR(:,s,j),color(s))
        hold on;
            pause;
            
        end
    end
    close all;
end
    
d.ubnd_name = input('Input blank series: ','s');
    
    for s = 1:length(d.ubnd_name)
        
        for r = 1:3
            
            if r == 1

                %Import Blank:

                blank_name = strcat(d.ubnd_name(s) , ' (0',num2str(r),')_Graph.dat');
                blank = importdata(blank_name);
                blank = blank.data;

                blank_SR = blank(:,2);

            else

                data_name = strcat(d.ubnd_name(s) , ' (0',num2str(r),')_Graph.dat');
                rawdata = importdata(data_name);
                rawdata = rawdata.data;

                rdata_SR = rawdata(:,2) - blank_SR;
                
                if plotopt ==1 
                    
                    if r == 2
                        
                        figure(1);
                        plot(d.wvl,rdata_SR,'b','LineWidth', 1.3);
                        hold on;
                    elseif r==3
                        
                        plot(d.wvl,rdata_SR,'r','LineWidth', 1.3)
                        
                        pause;
                        
                    end
                    
                    close(1)
                end
                    
                
                
                if r == 3
                    
                    d.ubnd(:,s) = rdata_SR;
                    
                end

            end
            
        end
        
            
    end
    
    for q = 1:length(d.wvl)
        
        d.mubnd(q) = mean(d.ubnd(q,:));
        
    end
        
        

   

d.bnd_name = input('Input bound series: ','s');
d.bnd_con = input('Input bound series concentration: ','s');   

    for s = 1:length(d.bnd_name)
        
        for r = 1:3
            
            if r == 1

                %Import Blank:

                blank_name = strcat(d.bnd_name(s) , ' (0',num2str(r),')_Graph.dat');
                blank = importdata(blank_name);
                blank = blank.data;

                blank_SR = blank(:,2);

            else

                data_name = strcat(d.bnd_name(s) , ' (0',num2str(r),')_Graph.dat');
                rawdata = importdata(data_name);
                rawdata = rawdata.data;

                rdata_SR = rawdata(:,2) - blank_SR;
                
                if plotopt ==1 
                    
                    if r == 2
                        
                        plot(d.wvl,rdata_SR,'b','LineWidth', 1.3);
                        title(['Series' series_name(s) ': ' num2str(con(j))]);
                        
                    elseif r==3
                        hold on;
                        plot(d.wvl,rdata_SR,'r','LineWidth', 1.3)
                        
                        pause;
                        
                    end
                    
                    close all;
                end
                    
                
                
                if r == 3
                    
                    d.bnd(:,s) = rdata_SR;
                    
                end

            end
            
        end
        
            
    end
    
    for q = 1:length(d.wvl)
        
        d.mbnd(q) = mean(d.bnd(q,:));
        
    end
    
 
%Program end

        
end



   
    
    


        
        
        
        
        
        
   