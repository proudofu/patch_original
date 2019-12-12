function good_tracks = thresholdTracks(tracks, lowerBound, upperBound)
% lowerBound is the time threshold (seconds) such that worms encountering lawn before that time are tossed.
% upperBound is the time threshold (seconds) such that worms encountering lawn after  that time are tossed.

good_tracks = tracks; % USE tracks.tracks IF FUNCTION OUTSIDE OF patchPlot
f = fields(good_tracks);

for s = 1:length(f) % loop through all conditions
   condition = good_tracks.(f{s});
   worms_to_remove = [];
   for w = 1:length(condition) % loop through all worms of the given condition
       worm = condition(w);
       if worm.Time(worm.refeedIndex) < lowerBound || worm.Time(worm.refeedIndex) > upperBound  % if worm encounters before lowerBound or after upperBound, mark for removal.
          worms_to_remove = [worms_to_remove w]; %#ok Dont care ab initializing matrix to speed up.
       end
   end
   for w = flip(worms_to_remove) % remove marked worms from other replicates (decrement in order to avoid array resizing issues)
       good_tracks.(f{s})(w) = [];
   end
end

end