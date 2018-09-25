function splitPatchVids(date) % date is a string in the format YYYYMMDD
% Example call: splitPatchVids('20180705')
    
    % Turn off known warnings
    warning('off', 'MATLAB:colon:nonIntegerIndex') % Known non-integer indeces in function writeVids

    % Find num videos in folder
    cd (sprintf('G:/behavior/%s',date))
    mkdir(sprintf('%s_unsplit', date));
    folders = dir; %avi should be in own folder named date_refeeding_numFields_genotype1_genotype2_genotype3_vid#_Cam#
    vids = {};
    
    % Get a handle to the cluster
    %c = parcluster('openmind');
    %c.AdditionaProperties.WallTime = '05:00:00';
    %c.saveProfile

    % Open a pool of workers
    %p = c.parpool(length(folders) - 2); % Number of workers = number of loops = number of videos in the folder that need splitting
    
    %parfor i= 3:length(folders)
    for i= 3:length(folders)
        vids(i-2) = {folders(i).name}; %#ok, Suppressing warning that vids may not be used after parfor loop. This is intentional.
        cd(vids{i-2});
        vid = dir('*.avi');
        disp('line before video reader call')
        v = VideoReader(vid.name); %#ok, Can't move this out of the loop, don't rly care ab 'better performance' here
        vidFrame = readFrame(v);
        nameParts = split(vids{i-2}, '_'); % parse
        numFields = str2double(nameParts{3});
        strains = strings(numFields); % preallocating space to make compatible w parfor loop
        for s = 1:numFields
            strains(s) = nameParts(3+s);
        end

        % import fields for this camera from the date folder
        fields = load(sprintf('%s_%s_fields.mat', nameParts{end-1}, nameParts{end}));
        fields = fields.fields; % just hacking the variables so that the rest of the script can be preserved

        for s = 1:numFields
            vidName = makeVidName(nameParts, strains{s}); % parses multi-strain file names by underscores to make new file name for each strain
            writers(s) = openVidWriter(vidName, v.FrameRate); %#ok makes an array of VideoWriter objects for each strain on this camera's file
            % consider finding a way to preallocate space for object array
        end    

        % Writing new cropped videos to disk.
        % This part seems to take the bulk of the run time, as the output is often in excess of 7000 sec = ~2 hrs
        tic
        fprintf('\nWriting new .avi files for %s and %s', strains{1}, strains{2});
        fprintf('\nProgress: ');
        writeVids(writers, fields, vidFrame);
        frame_counter = 1;
        total_frames = round(v.Duration*v.FrameRate);
        while hasFrame(v) % while v, a VideoReader object for the uncropped vid, still has frames in it (while video is not over)
            vidFrame = readFrame(v); % get next uncropped frame
            writeVids(writers, fields, vidFrame); % take this frame, crop it for each strain, and write it to respective strains' new .avi files
            % the below print statements are to display the number of frames written in real time
            if frame_counter > 1
                for j=1:length(sprintf('%d/%d frames', frame_counter, total_frames))
                    fprintf('\b'); % delete previous counter display
                end
            end
            frame_counter = frame_counter + 1;
            fprintf('%d/%d frames', frame_counter, total_frames);
        end
        fprintf('\n')
        
        close(writers);
        toc
        fprintf('\n');
        cd ..
        %clear('v') is this necessary? Prevents script from running due to potential workspace issue within parfor.
        movefile(vids{i-2}, sprintf('..//%s_unsplit//', date));
    end
    cd ..
    
    % Close parpool
%     delete(p);
end

    function vidName = makeVidName(nameParts, strain)
    i = 97;
    vidName = sprintf('%s_%s_%s_%s%c_%s', nameParts{1}, nameParts{2}, strain, nameParts{end-1}, i, nameParts{end});
    while isfolder(sprintf('..//%s', vidName))
        i = i + 1;
        vidName = sprintf('%s_%s_%s_%s%c_%s', nameParts{1}, nameParts{2}, strain, nameParts{end-1}, i, nameParts{end});
    end
end

function w = openVidWriter(vidName, frameRate)
    mkdir(sprintf('..//%s', vidName));
    w = VideoWriter(sprintf('..//%s//%s.avi', vidName, vidName));
    w.FrameRate = frameRate;
    open(w);
end

function writeVids(writers, fields, vidFrame)
    for s = 1:length(writers)
        subVid = vidFrame(fields(s).y(1):fields(s).y(2),...
            fields(s).x(1):fields(s).x(2));
        writeVideo(writers(s), subVid);
    end
end
