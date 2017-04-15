function legends = numericLegends(n)
    
    legends = cell(1,n);
    for i = 1:n
        legends{i} = num2str(i);
    end

end