function [ result ] = getMatrixValues( m )

[x, y] = size(m);
o = zeros(1,y);

result = zeros(x ,1);

for i=1:x
    result(i) = pdist2( o ,m(i ,:));
end

end

