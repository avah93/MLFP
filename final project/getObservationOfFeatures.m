function [ seq ] = getObservationOfFeatures( f1c , f2c , f3c , f4c ,f1 ,f2 ,f3 ,f4 )

u1 = dsearchn(f1c, f1);
u2 = dsearchn(f2c, f2) + size(f1c ,1);
u3 = dsearchn(f3c, f3) + size(f1c ,1) + size(f2c ,1);
u4 = dsearchn(f4c, f4) + size(f1c ,1) + size(f2c ,1) + size(f3c,1);
seq = [u1 u2 u3 u4];

end

