function tdata = addpara(tdata)
%adding parameters to tdata
%Zhiliang Gong, 07/24/2012
%Zhiliang Gong, modified on 11/6/2012
%Zhiliang Gong, 12/17/2012

if isfield(tdata,'runs')
    prompt = {'Buffer type: ', 'PS fraction: ', 'Lipid concentrations: ', 'Protein concentrations: ', 'Protein: ', 'Vesicle diamter: ','Comments: '};
    name = 'Input for complete data set.';
    numlines = 1;
    defaultanswer = cell(1, 7);
    defaultanswer{1} = 'HBS + 1mM Calcium';
    defaultanswer{2} = '0.1';
    defaultanswer{3} = '000 010 025 050 100 200 300 400 500 ';
    defaultanswer{4} = repmat('100 ', 1, 7);
    defaultanswer{5} = 'Tim4';
    defaultanswer{6} = '100 nm';
    defaultanswer{7} = date;
    
    tdata.buffer = answer{1};
    tdata.PS = str2num(answer{2});
    tdata.lcons = str2num(answer{3});
    tdata.pcons = str2num(answer{4});
    tdata.protein = answer{5};
    tdata.vesicle_diameter = answer{6};
    tdata.comments = answer{7};

else
    
    prompt = {'Buffer type: ', 'PS fraction: ', 'Runs per condition: ', 'Lipid concentrations: ', 'Protein concentrations: ', 'Protein: ', 'Vesicle diamter: ','Comments: '};
    name = 'Input for complete data set.';
    numlines = 1;
    defaultanswer = cell(1, 8);
    defaultanswer{1} = 'HBS + 1mM Calcium';
    defaultanswer{2} = '0.1';
    defaultanswer{3} = repmat('2 ',1, 7);
    defaultanswer{4} = '000 010 025 050 100 200 300 400 500';
    defaultanswer{5} = repmat('100 ', 1, 7);
    defaultanswer{6} = 'Tim4';
    defaultanswer{7} = '100 nm';
    defaultanswer{8} = date;
    
    answer = inputdlg(prompt,name,numlines,defaultanswer);

    tdata.buffer = answer{1};
    tdata.PS = str2num(answer{2});
    tdata.runs = str2num(answer{3});
    tdata.lcons = str2num(answer{4});
    tdata.pcons = str2num(answer{5});
    tdata.protein = answer{6};
    tdata.vesicle_diameter = answer{7};
    tdata.comments = answer{8};

end

%add legend

%if all the protein concentrations are the same, use lipid concentration as
%legend
if tdata.pcons(end) == tdata.pcons(1)
    for i = 1:length(tdata.lcons)
        tdata.leg{i} = strcat(num2str(tdata.lcons(i)), '\muM lipid');
    end
else
    for i = 1:length(tdata.pcons)
        tdata.leg{i} = strcat(num2str(tdata.pcons(i)), '\muM', tdata.protein);
    end
end

end