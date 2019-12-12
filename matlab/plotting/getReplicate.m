function rep_tracks = getReplicate(tracks, rep)
% reps: an array of replicates to keep

rep_tracks = tracks; % USE tracks.tracks IF FUNCTION OUTSIDE OF patchPlot
f = fields(rep_tracks);

for s = 1:length(f) % loop through all conditions
   condition = rep_tracks.(f{s});
   worms_to_remove = [];
   for w = 1:length(condition) % loop through all worms of the given condition
       worm = condition(w);
       if ~ contains(worm.ID, sprintf('vid%da', rep)) % if not from replicate, add its index to be removed.
          worms_to_remove = [worms_to_remove w]; %#ok
       end
   end
   for w = flip(worms_to_remove) % remove marked worms from other replicates (decrement in order to avoid array resizing issues)
       rep_tracks.(f{s})(w) = [];
   end
end

end