function out= SFIRNum(in,Num)
out=in;
out.data=filtfilt(Num,1,in.data);
end