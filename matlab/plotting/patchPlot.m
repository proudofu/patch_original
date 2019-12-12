function patchPlot(date, varargin)
% date: date the experiment was performed
% NOTE: Hard coded to plot only 6 conditions

tracks = load(sprintf('G:/behavior/%s/allTracks_%s', date, date));
p = inputParser;

% Default vals
mins              = 8; % number of mins on either side of patch encounter one wishes to view
window            = 5; % number of seconds for width of sliding window avg to smooth graph in last step.
lowerBound        = 0; % Only display worms that encountered AFTER this time wrt start of recording (sec)
upperBound        = 1800; % Only display worms that encountered BEFORE this time (sec)
replicate         = [1 2]; % Default both replicates; choose double vals 1 or 2 for a single replicate
tracks            = tracks.tracks; % tracks is saved with an extra nested layer so need to go one layer in
defaultConditions = transpose(fields(tracks)); % Default conditions, i.e. every condition in the experiment
colorLock         = false; % Lock line colors to condition or just loop through colors in order.

% Parse inputs and set parameters accordingly
addRequired( p, 'date', @ischar);
addParameter(p, 'mins', mins, @isnumeric);
addParameter(p, 'window', window, @isnumeric);
addParameter(p, 'lowerBound', lowerBound, @isnumeric);
addParameter(p, 'upperBound', upperBound, @isnumeric);
addParameter(p, 'replicate', replicate, @isnumeric);
addParameter(p, 'conditions', defaultConditions, @iscellstr);
addParameter(p, 'colorLock', colorLock, @boolean);

parse(p,date,varargin{:});

mins       = p.Results.('mins'      );
window     = p.Results.('window'    );
lowerBound = p.Results.('lowerBound');
upperBound = p.Results.('upperBound');
replicate  = p.Results.('replicate' );
conditions = p.Results.('conditions');
colorLock  = p.Results.('colorLock' );


% Set up figure and some important vars
if length(replicate) < 2
    tracks = getReplicate(tracks, replicate);
end
tracks = thresholdTracks(tracks, lowerBound, upperBound);
figure
title('Speed at Patch Encounter', 'Color', 'k')
ylabel('Speed', 'Color', 'k')
xlabel('Time', 'Color', 'k')
lineColors = {[0 0 0], [.5 .5 .5], [.8 .25 .8], [.2 .7 .2], [.25 .3 1], [1 .5 .05]}; % List of line colors to be used in order
patchColors = {[0 0 0], [.5 .5 .5], [.8 .25 .8], [.4 1 .4], [.25 .3 1], [1 .5 .05]};
patchAlphas = [.6 .4 .4 .4 .4 .5];
edgeColors = {[.3 .3 .3], [.7 .7 .7], [.9 .6 .9], [.3 .9 .3], [.4 .6 1], [1 .7 .2]};
lines = ['-' '-' '-' '-' '-' '-']; % List of line styles to be used in order
lgnd = cell(length(conditions),1);
mainlines = [];
wormIndex = 0;
hold on

maxFrames = 16201; % max number of frames recorded during patch (1.5 hrs)
mi = (maxFrames-1)/2 + 1; % middle index, i.e. index of middle column of speedMatrix


% Loop through struct and plot each condition
for condition = conditions
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
    
    % Plot results (shaded error package reference:  https://github.com/raacampbell/shadedErrorBar/blob/master/README.md  )
    time = -mins:1/180:mins; % sec = 1/60th a minute, 3 frames per sec, so intervals are (1/60)*(1/3)
    p = shadedErrorBar(time, movmean(avgspeed, window*3), nanstd(speedMatrix)./sqrt(sum(~isnan(speedMatrix))), 'lineprops', {strcat(lines(wormIndex), 'k')});
    p.mainLine.LineWidth = 1.5;
    if colorLock
        colorIndex = find(strcmp(defaultConditions, condition));
    else
          colorIndex = wormIndex;
    end
    p.mainLine.Color = lineColors{colorIndex};
    p.patch.FaceColor = patchColors{colorIndex};
    p.patch.FaceAlpha = patchAlphas(colorIndex);
    p.edge(1).Color = edgeColors{colorIndex};
    p.edge(2).Color = edgeColors{colorIndex};
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