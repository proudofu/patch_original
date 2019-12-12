% This function convolves the vector *Data* with a rectangular sliding window
% of size *WinSize* (a scalar). The amplitude of the rectangular window is
% 1/WinSize (to obtain an average). The overall effect is of a low-pass
% filter of approx. width (in the frequency domain) of 1/(2*WinSize).
%
% Alignment issues:
% The function returns a vector (SmoothData) that is aligned with the input vector (Data).
% This means that the i-th index of SmoothData is the filtered value of the i-th index
% of Data. This filtered value is calculated by centering the sliding window about the
% i-th index of Data.

% Recommendation: use odd valued Winsize for symmetry

% Edge effects: See code (too long to explain & not that important).

function SmoothData = RecSlidingWindow(Data,WinSize)

Len = length(Data);

if(WinSize==0 || Len<=WinSize)
    SmoothData = Data;
    return;
end

% SmoothData = nanmean(Data(ceil(-(WinSize-1)/2):ceil((WinSize-1)/2)));
% return;


SmoothData = 0;
for i = ceil(-(WinSize-1)/2):ceil((WinSize-1)/2)
    if i< 0
        SmoothData = SmoothData + [zeros(size(Data(1:-i))), Data(1:Len+i)];
    elseif i == 0
        SmoothData = SmoothData + Data;
    else	% (i > 0)
        SmoothData = SmoothData + [Data(i+1:Len),zeros(size(Data(Len-(i-1):Len)))];
    end
end
WinSizeDiv1 = [WinSize-abs(ceil(-(WinSize-1)/2)):WinSize];
WinSizeDiv3 = [WinSize:-1:WinSize-ceil((WinSize-1)/2)];
WinSizeDiv2 = [WinSize*ones(size(SmoothData(1:Len-length(WinSizeDiv1)-length(WinSizeDiv3))))];
WinSizeDiv = [WinSizeDiv1, WinSizeDiv2, WinSizeDiv3];

SmoothData = SmoothData./WinSizeDiv;	% Divide summed data by WinSizeDiv to obtain average.

return;
end
