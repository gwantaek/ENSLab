% filter1.m by LCH
% after = filter1(before, f1, f2, fs)
% after, before: nchannel-by-ntime matrix
% f1: first cutoff frequency. if 0 ==> lowpass
% f2: second cutoff frequency. if fs/2 ==> highpass

function after = filter1(before, f1, f2, fs)

Ap = 1;
Ast = 20;
if (f1 == 0)
    Fp = f2/fs*2;
    Fst = Fp*1.1;
    Ast = 30;
    d = fdesign.lowpass('Fp,Fst,Ap,Ast',Fp,Fst,Ap,Ast);
    Hd = design(d,'equiripple');
elseif (f2 == fs/2)
    Fp = f1/fs*2;
    Fst = Fp*0.8;
    Ast = 30;
    d = fdesign.highpass('Fst,Fp,Ast,Ap',Fst,Fp,Ast,Ap);
    Hd = design(d);
else
    Fp1 = f1/fs*2;
    Fp2 = f2/fs*2;
    Fst1 = Fp1*0.8;
    Fst2 = Fp2*1.1;
    Ast1 = Ast;
    Ast2 = Ast;
	d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2);
    Hd = design(d,'equiripple');
end

after = zeros( size(before) );
aa = Hd.numerator;
for i=1:size(before,1)
    after(i,:) = filtfilt(Hd.numerator,1,before(i,:));
end
