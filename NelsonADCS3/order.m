function n = order(val, base)
%function taken from Ivar Eskerud Smith on
%mathworks.com/matlabcentral/fileexchange/28559-order-of-magnitude/content/order.m

if nargin < 2
    base = 10;
end
n = floor(log(abs(val))./log(base));
