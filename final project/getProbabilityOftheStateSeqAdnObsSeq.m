function [ prob ] = getProbabilityOftheStateSeqAdnObsSeq( u ,v ,trans ,obs )

prob = 1;
ob = 1;
len = size(v,2);
for i=1:len
    q  = 1;
    if i ~= 1
        q = trans(v(i-1) ,v(i));
    end
    
    o = obs(v(i) ,u(i));
    prob = prob * q * o;
    
end


end

