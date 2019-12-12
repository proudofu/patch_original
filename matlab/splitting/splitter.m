function splitter(folder, subfolder, user)
% Example call: splitPatchVids('20180705', '20190705_refeeding_2_N2Fed_N2Starved_vid1_Cam1i, 'kmaher')
   
    % Turn off known warnings
    warning('off', 'MATLAB:colon:nonIntegerIndex') % Known non-integer indeces in function writeVids

    % Find num videos in folder
    cd (sprintf('/om/user/%s/data/patch_data_cluster/%s/%s', user, folder, subfolder))
    v = VideoReader(sprintf('%s.avi', subfolder)); %#ok, Can't move this out of the loop, don't rly care ab 'better performance' here
    vidFrame = readFrame(v);
    nameParts = split(subfolder, '_'); % parse
    numFields = str2double(nameParts{3});
    for s = 1:numFields
        strains(s) = nameParts(3+s);
    end

    fields = load(sprintf('%s_%s_ROIs.mat', nameParts{end-1}, nameParts{end}));
    fields = fields.fields; % just hacking the variables so that the rest of the script can be preserved

    for s = 1:numFields
        vidName = makeVidName(nameParts, strains{s}); % parses multi-strain file names by underscores to make new file name for each strain
        writers(s) = openVidWriter(vidName, v.FrameRate); %#ok makes an array of VideoWriter objects for each strain on this camera's file
    end    

    % Writing new cropped videos to disk.
    tic
    fprintf('\nWriting new .avi files for %s and %s %s', strains{1}, strains{2}, nameParts{end-1});
    writeVids(writers, fields, vidFrame);
    while hasFrame(v) % while v, a VideoReader object for the uncropped vid, still has frames in it (while video is not over)
        vidFrame = readFrame(v); % get next uncropped frame
        writeVids(writers, fields, vidFrame); % take this frame, crop it for each strain, and write it to respective strains' new .avi files
    end
    fprintf('\n')
        
    close(writers);
    toc
    fprintf('\n');
    cd ..
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
