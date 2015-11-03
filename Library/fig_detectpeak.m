function [amp lat] = fig_detectpeak(erp, tw, freq, base, updown)
%----------------------------------------------------------
% Measures of the time-frequency transformed ERP
%
% erp   : erp
% tw    : Time window
% freq  : sampling rate
% base  : length of baseline
% updown: positive or negative peak
% lat   : latency

% Author : Gwan-Taek Lee
% Last update : 2011. 09. 16
%----------------------------------------------------------

    tw_tp = lgt_lat2tp(tw(1),freq,base):lgt_lat2tp(tw(2),freq,base);
    tp = lgt_getcomponent(erp,tw_tp,updown,'peak');

    lat = lgt_tp2lat(tp,freq,base);
    amp = erp(tp);
    
    time = lgt_tp2lat(1,freq,base):1000/freq:lgt_tp2lat(length(erp),freq,base);
    plot(time, erp);
    hold on;
    
    % Display Peak
    xl = xlim;
    yl = ylim;
    rw = round((xl(2)-xl(1))/30);
    rh = round((yl(2)-yl(1))/30);
    theta = 0:0.1:2*pi;
    X1 = cos(theta)*rw+lat;
    Y1 = sin(theta)*rh+erp(tp);
    plot(X1, Y1, 'LineWidth', 2, 'Color', [1 0 0]);
    
end