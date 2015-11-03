function [y]=my_filter(x,freq,fs);

n=4;
Rp=1;
Rs=40;
Pass_freq = freq(1);
Stop_freq = freq(2);

Wp=[Pass_freq/(fs/2) Stop_freq/(fs/2)];

if (Wp(1) == 0)
    [b,a]=ellip(n,Rp,Rs,Wp(2), 'low');
elseif (Wp(2) == 1)
    [b,a]=ellip(n,Rp,Rs,Wp(1), 'high');
else
    [b,a]=ellip(n,Rp,Rs,Wp);
end
for i=1:size(x,1)
    y(i,:)=filtfilt(b,a,x(i,:));
end
