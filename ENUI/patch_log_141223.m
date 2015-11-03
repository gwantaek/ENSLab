% =====141223 스테이지 nan 제거용 ===============
max_stage_length = length(Head.Stage.Series);
for n = 1:max_stage_length % 그 행을 없애자. 전체 사이즈가 줄어듬
    nn = max_stage_length - n +1;
    if 0 == max(~isnan(Head.Stage.Series(nn,:)))
        Head.Stage.Series(nn,:) = [] ; 
    end
end