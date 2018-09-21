% Master function, runs PatchTrackerAutomatedScript and then processPatchTracks.

% For either function, failure to execute will result in a description of the error while continuing to analyze other files.

% Example function call:
%   processPatchVids('20180705')

function processPatchVids(date) % date is a char array in format YYYYMMDD corresponding to the day of recording

% default parameters: range of worms expected on the plate and size of plate
numworms = [10 100];

cd (char(date))
folders = dir; %avi should be in own folder named date_genotype_vid#_Cam#
vids = cell(1, length(folders) - 2); % preallocating space

% Get tracks
for i=3:length(folders)
    vids(i-2) = {folders(i).name};
    cam = char(vids(i-2));
    cam = cam((length(cam)-3):end);
    measure = strcat('..\measure', cam, '.avi');
    try
        PatchTrackerAutomatedScript(vids{i-2}, 'quick', 'scale', char(measure), 'numworms', numworms, 'none'); %FOR SMALL PLATES
    catch error
        fprintf('\nThe following file failed PatchTrackerAutomatedScript: %s\n', vids{i-2});
        fprintf('The stack: \n%s', getReport(error))
    end
end

% Analyze tracks
for i=1:length(vids)
    try
        processPatchTracks(char(vids(i)));
    catch error
        fprintf('\nThe following file failed processPatchTracks: %s\n', vids{i});
        fprintf('The stack: \n%s', getReport(error))
    end
end
cd ..

end
