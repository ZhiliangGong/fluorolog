function tdata = comgetdata
%get data from two or more series

N = input('number of input fragments: ');
temp = cell(N,1);
d2 = 0;
frags = zeros(1, N);

for i = 1:N
    temp{i} = getdata;
    [m, n] = size(temp{i}.SR);
    frags(i) = n;
    d2 = d2 + n;
end

tdata.wl = temp{1}.wl;
tdata.ScRc = zeros(m, d2);
tdata.SR = zeros(m, d2);
tdata.Sc = zeros(m, d2);
tdata.S = zeros(m,d2);

pos = 1;
for i = 1:N
    tdata.ScRc(:,pos:(pos+frags(i)-1)) = temp{i}.ScRc;
    tdata.SR(:,pos:(pos+frags(i)-1)) = temp{i}.SR;
    tdata.S(:,pos:(pos+frags(i)-1)) = temp{i}.S;
    tdata.Sc(:,pos:(pos+frags(i)-1)) = temp{i}.Sc;
    pos = pos + frags(i);
end
end