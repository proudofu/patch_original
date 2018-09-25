function preSplit(date)
    %strain, color
    colors = {'m' 'c' 'r' 'g' 'b' 'k'};
    
    % Turn off known warnings
    warning('off', 'images:initSize:adjustingMag') % Anticipate image resizing during user region selection
    
    % Establish same relevant variables as in main splitPatchVids
    cd('G:\behavior') % important to match this up to the letter for the hard drive connected that contains the videos
    cd (char(date))
    folders = dir; %avi should be in own folder named date_refeeding_numFields_genotype1_genotype2_genotype3_vid#_Cam#
    vids = {};  % Array of all .avi file names (one for each cam)
    for i= 3:length(folders)
        vids(i-2) = {folders(i).name}; %#ok, negligible size for preallocating space
        cd(vids{i-2});
        vid = dir('*.avi');
        v = VideoReader(vid.name); %#ok, don't feel like initializing outside of loop
        vidFrame = readFrame(v);
        nameParts = strsplit('_', vids{i-2}); % parse
        numFields = str2double(nameParts{3}); % 3rd index corresponds to number of strains
        for s = 1:numFields
            strains(s) = nameParts(3+s); %#ok, array of strain names for the given video, negligible size for preallocating space
        end

        % gather top left and bottom right coordinates of rectangular fields of interest
        fields =  struct(); % contains regions to be cropped, one for each strain
        c = 1;
        figure;
        imshow(vidFrame, []);
        hold on;    
        for s = 1:numFields % crops original video into relevant region for each strain
            [x, y] = getField(strains{s},colors{c});
            fields(s).x = x; % top left corner of relevant region
            fields(s).y = y; % top right corner of relevant region
            c = c + 1; % increment color index for unique colors for each strain
        end
        save (sprintf('%s_%s_fields.mat', nameParts{end-1}, nameParts{end}), fields); % name each fields struct based on the camera the video was recorded on
        cd ..
    end
end

function [x, y] = getField(strain, color)
[x, y] = ginput2(2); % collects top left and bottom right corner coordinates of the relevant region of plate
p = patch(x([1 2 2 1]), y([1 1 2 2]), color, 'FaceAlpha', 0.5); % colors user-selected region
answer = questdlg(sprintf('Field successfully selected for strain %s?', strain), 'Field selection');
if strcmp(answer, 'Yes') % 
    return
elseif strcmp(answer, 'No')
    p.delete;
    [x, y] = getField(strain, color);
    return
else
    error('Figure out what you want, then try again.')
end
end
