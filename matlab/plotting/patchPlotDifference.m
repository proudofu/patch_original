function  patchPlotDifference(date, mutant, varargin)
% date: date the experiment was performed
% mutant: the name of the strain as abbreviated in file, eg if saved as ttxFed and ttxStarved, mutant = ttx
% NOTE: Hard coded to plot only 2 conditions

tracks = load(sprintf('G:/behavior/%s/allTracks_%s', date, date)); % Have to load this in first to set some default vars
p = inputParser;

% Default vals
controls          = {'N2Fed' 'N2Starved'}; % default controls that will serve as benchmark speed
mins              = 8; % number of mins on either side of patch encounter one wishes to view
window            = 5; % number of seconds for width of sliding window avg to smooth graph in last step.
lowerBound        = 0; % Only display worms that encountered AFTER this time (sec)
upperBound        = 1800; % Only display worms that encountered BEFORE this time (sec)
replicate         = [1 2]; % Default both replicates; choose double vals 1 or 2 for a single replicate
tracks            = tracks.tracks; % tracks is saved with an extra nested layer so need to go one layer in
defaultConditions = transpose(fields(tracks)); % Default conditions, i.e. every condition in the experiment
colorLock         = false; % Lock line colors to condition or just loop through colors in order.

% Parse inputs and set parameters accordingly
addRequired( p, 'date',                   @ischar   );
addRequired( p, 'mutant',                 @ischar   );
addParameter(p, 'controls',   controls,   @iscellstr)
addParameter(p, 'mins',       mins,       @isnumeric);
addParameter(p, 'window',     window,     @isnumeric);
addParameter(p, 'lowerBound', lowerBound, @isnumeric);
addParameter(p, 'upperBound', upperBound, @isnumeric);
addParameter(p, 'replicate',  replicate,  @isnumeric);
addParameter(p, 'colorLock',  colorLock,  @boolean  );

parse(p, date, mutant, varargin{:});

controls   = p.Results.('controls'  );
mins       = p.Results.('mins'      );
window     = p.Results.('window'    );
lowerBound = p.Results.('lowerBound');
upperBound = p.Results.('upperBound');
replicate  = p.Results.('replicate' );
colorLock  = p.Results.('colorLock' );


% Threshold by encounter time and select replicates from original tracks file
if length(replicate) < 2
    tracks = getReplicate(tracks, replicate);
end
tracks = thresholdTracks(tracks, lowerBound, upperBound);

% Get difference of speedMatrices between mutant/N2 Fed and mutant/N2 Starved
n2f = getSpeedMatrix(controls{1},               mins, tracks); % N2Fed (default)
n2s = getSpeedMatrix(controls{2},               mins, tracks); % N2Starved (default)
muf = getSpeedMatrix(strcat(mutant, 'Fed'),     mins, tracks); % MutantFed
mus = getSpeedMatrix(strcat(mutant, 'Starved'), mins, tracks); % MutantStarved

dmf = muf - nanmean(n2f); % Difference matrix of Fed animals; avg N2Fed subtracted from each mutant worm (row-wise subtraction)
dms = mus - nanmean(n2s); % Difference matrix of Starved animals

plotSpeeds(mutant, {dmf, dms}, defaultConditions, mins, window, colorLock)

end


function speedMatrix = getSpeedMatrix(condition, mins, tracks)
%Return matrix containing speeds of all worms in condition centered at encounter

maxFrames = 16201; % max number of frames recorded during patch (1.5 hrs)
mi = (maxFrames-1)/2 + 1; % middle index, i.e. index of middle column of speedMatrix

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

end


function plotSpeeds(mutant, speedMatrices, defaultConditions, mins, window, colorLock)

% Establish figure and key plotting vars
figure
title( 'Difference from Controls', 'Color', 'k')
ylabel('Speed',                    'Color', 'k')
xlabel('Time',                     'Color', 'k')
lineColors  = {[.8 .25 .8], [.2 .7 .2]}; % List of line colors to be used in order
patchColors = {[.8 .25 .8], [.4  1 .4]};
edgeColors  = {[.9 .6 .9 ], [.3 .9 .3]};
patchAlphas = [.4 .4];
lines       = ['-' '-']; % List of line styles to be used in order
lgnd        = cell(2,1);
mainlines   = [];
hold on

% Plot results (shaded error package reference:  https://github.com/raacampbell/shadedErrorBar/blob/master/README.md  )
time = -mins:1/180:mins; % sec = 1/60th a minute, 3 frames per sec, so intervals are (1/60)*(1/3)
i = 0;
for condition = {strcat(mutant, 'Fed'), strcat(mutant, 'Starved')}
    i = i + 1;
    speedMatrix = speedMatrices{i};
    avgspeed = nanmean(speedMatrix);
    p = shadedErrorBar(time, movmean(avgspeed, window*3), nanstd(speedMatrix)./sqrt(sum(~isnan(speedMatrix))), 'lineprops', {strcat(lines(i), 'k')});
    p.mainLine.LineWidth = 1.5;
    if colorLock
        colorIndex = find(strcmp(defaultConditions, condition));
    else
        colorIndex = i;
    end
    p.mainLine.Color  = lineColors{colorIndex};
    p.patch.FaceColor = patchColors{colorIndex};
    p.patch.FaceAlpha = patchAlphas(colorIndex);
    p.edge(1).Color   = edgeColors{colorIndex};
    p.edge(2).Color   = edgeColors{colorIndex};
    mainlines         = [mainlines p.mainLine]; %#ok Have to specify that legends only correspond to mainLine elements of shadedErrorBar plot, i.e. not the shading.
    lgnd{i,1}         = strcat(char(condition), sprintf(', n = %d', size(speedMatrix,1)));
end

% Plot final legend.
legend(mainlines, lgnd)
hold off
grid on

end