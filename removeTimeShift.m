function y_out = removeTimeShift(x, y)

delay = finddelay(x, y);

len = length(y);

if delay < 0
    y_out = paddata(y, len - delay, 'Side', 'leading');
    y_out = y_out(1:length(x));
else
    y_out = paddata(y, len + delay, 'Side', 'trailing');
    y_out = y_out(delay+1:end);
end