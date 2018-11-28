% Master function, runs track.m to get Tracks files and then processPatchTracks to get finalTracks files.

% For either function, failure to execute will result in a description of the error while continuing to analyze other files.

% Example function call:
%   processPatchVids('20180705')

function process(folder,subfolder) % date is a char array in format YYYYMMDD corresponding to the day of recording

% default parameters: range of worms expected on the plate and size of plate
numworms = [10 100];

%cd (sprintf('/om/user/kmaher/data/patch_videos/%s', date))
%folders = dir; %avi should be in own folder named date_genotype_vid#_Cam#
%vids = cell(1, length(folders) - 2); % preallocating space

% Get Tracks
cd(sprintf('/om/user/kmaher/data/patch_videos/%s/%s', folder, subfolder));
[~, folder_name] = fileparts(pwd); % name of video same as folder name but with .avi extension
    vid = {folder_name};
    cam = char(vid{1});
    cam = cam((length(cam)-3):end);
    measure = strcat('/om/user/kmaher/data/patch_videos/measure', cam, '.avi');
    try
        track(vid{1}, 'quick', 'scale', char(measure), 'numworms', numworms, 'none'); %FOR SMALL PLATES
    catch error
        fprintf('\nThe following file failed track.m: %s\n', vid{1});
        fprintf('The stack:\n------------------------\n%s\n------------------------\n', getReport(error))
    end

% Get finalTracks
    try
        track_final(char(vid{1}));
    catch error
        fprintf('\nThe following file failed processPatchTracks: %s\n', vid{1});
        fprintf('The stack:\n------------------------\n%s\n------------------------\n', getReport(error))
    end

end
