% =====141223 �������� nan ���ſ� ===============
max_stage_length = length(Head.Stage.Series);
for n = 1:max_stage_length % �� ���� ������. ��ü ����� �پ��
    nn = max_stage_length - n +1;
    if 0 == max(~isnan(Head.Stage.Series(nn,:)))
        Head.Stage.Series(nn,:) = [] ; 
    end
end