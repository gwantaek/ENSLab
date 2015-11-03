function NFFT = lgt_nfft(L)

    if L < 128
        NFFT = 64;
    elseif L >= 128 && L < 256
        NFFT = 128;
    elseif L >= 256 && L < 512
        NFFT = 256;
    elseif L >= 512 && L < 1024
        NFFT = 512;
    else
        NFFT = 1024;
    end
    
end