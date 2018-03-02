function [ writevar ] = writevar( x,k,filename )
%UNTITLED Grafei se excel
%   Detailed explanation goes here
col = char(64+k);
    N = size(x,1);
    Rg = sprintf([col '1:' col '%i' ],N);
    xlswrite(filename,x,Rg);

end

