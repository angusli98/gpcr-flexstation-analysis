function [dose] = getdose(drg,dse)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if (drg == 1 || drg == 6)
    dose =  dse;
else
    dose = dse + 1;
end
end

