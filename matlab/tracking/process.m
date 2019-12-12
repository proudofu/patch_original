% Master function, runs track.m to get Tracks files and then track_final.m to get finalTracks files.

function process(folder, subfolder, user)

% Hard-coded range of worms expected on the plate
numworms = [10 200];

% Get Tracks
cd(sprintf('/om/user/%s/data/patch_data_cluster/%s/%s', user, folder, subfolder));
[~, folder_name] = fileparts(pwd); % name of video same as folder name but with .avi extension
    vid = {folder_name};
    cam = char(vid{1});
    cam = cam((length(cam)-3):end);
    measure = strcat(sprintf('/home/%s/patch/measure/measure', user), cam, '.avi');
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
        fprintf('\nThe following file failed track_final.m: %s\n', vid{1});
        fprintf('The stack:\n------------------------\n%s\n------------------------\n', getReport(error))
    end

end
