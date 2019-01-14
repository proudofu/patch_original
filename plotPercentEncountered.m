function plotPercentEncountered(date)

allTracks = load(sprintf('G:/behavior/%s/allTracks_%s.mat', date, date)); % the new struct that will contain only worms from second replicate
good_tracks = allTracks.tracks;
f = fields(good_tracks);

figure
title('Percent Encounters Over Time')
xlabel('time')
ylabel('% encounters')
hold on
colors = 'krbmcy';
lgnd = cell(length(f),1);

for s = 1:length(f) % loop through all conditions
   condition = good_tracks.(f{s});
   times = [];
   for w = 1:length(condition) % loop through all worms of the given condition
       worm = condition(w);
       times = [times worm.Time(worm.refeedIndex)]; %#ok dont care that i didnt initialize this matrix size
   end
   times = sort(times)/60; % sort so that each encounter corresponds to an increase in y; div by 60 for mins
   y = (1:length(times))/length(times);
   plot(times, y, colors(s), 'LineWidth',3);
   lgnd{s,1} = f{s};
   
end

legend(lgnd);

end