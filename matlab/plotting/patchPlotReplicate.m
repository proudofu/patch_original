function patchPlotReplicate(date, mins, window, replicate, varargin)
% date: date the experiment was performed
% mins: number of mins on either side of patch encounter one wishes to view
% window: number of seconds for width of sliding window avg to smooth graph in last step.
% lowerBound: Only display worms that encountered AFTER this time (sec)
% upperBound: Only display worms that encountered BEFORE this time (sec)
% For example: patchPlotThresh('20181204', 8, 20, 0, 20)
% NOTE: Only plots 4 conditions. THIS IS AN INTENTIONAL LIMITATION.

tracks = getReplicate(date, replicate);

% Handle conditions
if nargin < 5
    conditions = fields(tracks);
else
    conditions = varargin{1}';
end

% Set up plot and some important vars
figure
title('Speed at Patch Encounter', 'Color', 'k')
ylabel('Speed', 'Color', 'k')
xlabel('Time', 'Color', 'k')
lineColors = {[0 0 0], [.5 .5 .5], [.8 .25 .8], [.2 .7 .2]}; % List of line colors to be used in order
patchColors = {[0 0 0], [.5 .5 .5], [.8 .25 .8], [.4 1 .4]};
patchAlphas = [.6 .4 .4 .5];
edgeColors = {[.3 .3 .3], [.7 .7 .7], [.9 .6 .9], [.3 .9 .3]};
lines = ['-' '-' '-' '-']; % List of line styles to be used in order
% colors = 'cmyk';
lgnd = cell(length(conditions),1);
mainlines = [];
wormIndex = 0;
hold all
maxFrames = 16201; % max number of frames recorded during patch (1.5 hrs)
mi = (maxFrames-1)/2 + 1; % middle index, i.e. index of middle column of speedMatrix

% Loop through struct and plot each condition
for condition = transpose(conditions)
    wormIndex = wormIndex + 1;
    worms = tracks.(char(condition));
    speedMatrix = nan([length(worms) maxFrames], 'double');
    for w = 1:length(worms)
        worm = worms(w);
        ri = worm.refeedIndex;
        % 1. Fill in speed at refeedIndex in the middle column (i.e. fill in time zero)
        speedMatrix(w, mi) = worm.Speed(ri);
        % 2. Move to the left filling in speeds only where a frame was recorded (i.e. skip a slot if time skipped too)
        i = 1;
        while i < min(ri, mi)
            speedMatrix(w,mi - i) = worm.Speed(ri - i);
            i = i + 1;
        end
        % 3. Move to the right and do the same thing.
        i = 1;
        while i < min(length(worm.Speed) - ri, mi)
            speedMatrix(w, mi + i) = worm.Speed(ri + i);
            i = i + 1;
        end
    end
    % Trim to desired frame for plot
    speedMatrix = speedMatrix(:, mi-mins*60*3:mi+mins*60*3);
    
    % Averaging across worms within the condition
    avgspeed = nanmean(speedMatrix);
    
    % Plot results (shaded error reference:  https://github.com/raacampbell/shadedErrorBar/blob/master/README.md  )
    time = -mins:1/180:mins; % sec = 1/60th a minute, 3 frames per sec, so intervals are (1/60)*(1/3)
    p = shadedErrorBar(time, movmean(avgspeed, window*3), nanstd(speedMatrix)./sqrt(sum(~isnan(speedMatrix))), 'lineprops', {strcat(lines(wormIndex), 'k')});
    p.mainLine.LineWidth = 1.5;
    p.mainLine.Color = lineColors{wormIndex};
    p.patch.FaceColor = patchColors{wormIndex};
    p.patch.FaceAlpha = patchAlphas(wormIndex);
    p.edge(1).Color = edgeColors{wormIndex};
    p.edge(2).Color = edgeColors{wormIndex};
    mainlines = [mainlines p.mainLine]; %#ok Have to specify that legends only correspond to mainLine elements of shadedErrorBar plot, i.e. not the shading.
    lgnd{wormIndex,1} = strcat(char(condition), sprintf(', n = %d', size(speedMatrix,1)));
    
end

% Plot final legend.
legend(mainlines, lgnd)
% fig = gcf;
% fig.Color = [.3 .3 .3];
% ax = gca;
% ax.Color = [1 1 1];
hold off

end