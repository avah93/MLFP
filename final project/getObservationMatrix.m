function [ obs ] = getObservationMatrix( f1cValue , f2cValue , f3cValue , f4cValue)

obs = zeros(4 ,size(f1cValue ,1) + size(f2cValue ,1) + size(f3cValue ,1) + size(f4cValue ,1));

s = sum(f1cValue) + sum(f2cValue) + sum(f3cValue) + sum(f4cValue);
r = [(f1cValue ./ s)' (f2cValue ./ s)' (f3cValue ./ s)' (f4cValue ./ s)'];

obs = [r;r;r;r];

end


