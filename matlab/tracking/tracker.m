function rawTracks = tracker(PathName, stimulusfile, target_numworms, fps)

global Prefs;
Prefs = patch_define_preferences(Prefs);

patch_aviread_to_gray;

FileInfo = [];
Ring = [];

startFrame = [];
endFrame = [];
Prefs.FrameRate = fps; % the index of Prefs.FrameRate is always 2 for patch calls
Prefs = CalcPixelSizeDependencies(Prefs, Prefs.DefaultPixelSize);
OPrefs = Prefs;
rawTracks = [];

   
Prefs.PlotFrameRate = Prefs.PlotFrameRateBatch;
Prefs.PlotDataRate = Prefs.PlotDataRateBatch;
FileName = sprintf('%s.avi', PathName);
    
localpath = PathName;
    
    
    testfile = sprintf('%s',FileName);
    fp = fopen(testfile,'r');
    if(fp==-1)
        sprintf('Cannot open %s',testfile)
        Prefs = OPrefs;
        return;
    end
    fclose(fp);
    
    
    rawtracksfilename = sprintf('%s.rawTracks.mat',localpath);
    
    if(file_existence(rawtracksfilename))
        fprintf('rawTracks file %s exists....',rawtracksfilename)
        
        if(does_this_file_need_making(rawtracksfilename,Prefs.trackerbirthday)==0)
            fprintf('processing....\t%s',timeString())
            
            rawTracks = [];
            analyse_rawTracks(rawTracks, stimulusfile, localpath, '');
            
            if(nargout>0)
                load(rawtracksfilename); %#ok no path conflict
            end
            
            Prefs = OPrefs;
            return;
        else
            fprintf('... but is old ... re-analyse')
            rm(rawtracksfilename);
        end
    end

% remove any processed files for this movie, in case they exist
fprintf('Removing old processed files for %s.avi\t%s', localpath, timeString())
dummystring = sprintf('%s*Tracks.mat',localpath);
rm(dummystring);
dummystring = sprintf('%s*BinData.mat',localpath);
rm(dummystring);
dummystring = sprintf('%s*.txt', localpath);
rm(dummystring);
dummystring = sprintf('%s*.pdf',localpath);
rm(dummystring);

RealMovieName = sprintf('%s.avi',localpath);

fprintf('Found %s ... ',RealMovieName)

procFrame_file = sprintf('%s.procFrame.mat',localpath);
if(does_this_file_need_making(procFrame_file))
    
    MovieName = RealMovieName;
    
    % read info about the movie
    FileInfo = moviefile_info(MovieName);
    
    if(isempty(startFrame))
        startFrame = 1;
        endFrame = FileInfo.NumFrames;
    end
    
    if(endFrame > FileInfo.NumFrames)
        endFrame = FileInfo.NumFrames;
    end
    
    
    NumFrames = endFrame-startFrame+1;
    
%   Last print statement before child process spawning
    fprintf('Now defining the global background and boundry\t%s',timeString())
    global_background = calculate_background(MovieName);
    Ring = find_ring(global_background,localpath, '');
    
    if(isempty(Ring.ring_mask))
        Prefs.aggressive_wormfind_flag = 0;
    end
    
    if(~isempty(Ring.NumWorms) && target_numworms==0)
        target_numworms = Ring.NumWorms;
    end
    
    if(isfield(Ring,'arena_name'))
        if(length(Ring.arena_name)>1)
            if(target_numworms==0)
                target_numworms = 30*length(Ring.arena_name);
            end
        end
    end
        
    procFrame = [];
    if(Prefs.NumCPU<=1 ||  NumFrames < 2*Prefs.TrackProcessChunkSize) % just do it in one process
        procFrame = patch_master_process_movie_frames(MovieName, localpath, '', Ring, stimulusfile, startFrame, endFrame, target_numworms);
        dummystring = sprintf('%s.%d_%d.procFrame.mat',localpath, startFrame, endFrame);
        mv(dummystring, procFrame_file);
        clear('dummystring');
    else % fork_process_movie_frames to process chunks in parallel
        
        if(isempty(Ring.NumWorms) || isempty(Ring.DefaultThresh) || isempty(Ring.meanWormSize))
            [~, ~, ~, Ring] = default_worm_threshold_level(MovieName, calculate_background(MovieName), procFrame, target_numworms, Ring);
            save(sprintf('%s.Ring.mat',localpath), 'Ring');
        end
        
        
        
        frameStep = round(NumFrames/(Prefs.NumCPU));
        
        startFrame_vector = [];
        frameEnd_vector = [];
        f=startFrame;
        while(f<endFrame)
            startFrame_vector = [startFrame_vector f]; %#ok, negligible speed difference
            frameEnd_vector = [frameEnd_vector startFrame_vector(end)+frameStep-1]; %#ok, negligible speed difference
            f = f + frameStep;
        end
        if(frameEnd_vector  > endFrame)
            frameEnd_vector = endFrame;
        end
        frameEnd_vector(end) = endFrame;
        if(frameEnd_vector(end) - startFrame_vector(end) + 1 < frameStep/2)
            startFrame_vector(end) = [];
            frameEnd_vector(end) = [];
            frameEnd_vector(end) = endFrame;
        end
            
        for kk=1:length(startFrame_vector)
            dummystring = sprintf('%s.%d_%d.procFrame.mat',localpath, startFrame_vector(kk), frameEnd_vector(kk));
            if(file_existence(dummystring)==0)
%               Call to fork_process_movie_frames is the child process culprit!  
                patch_process_movie_frames(MovieName, localpath, '', stimulusfile, startFrame_vector(kk), frameEnd_vector(kk), target_numworms);
                pause(10);
            end
        end
        
        % pool procFrame segments into single procFrame file
        fprintf('pooling procFrame segments into single procFrame file\t%s',timeString)

        dummy_procFrame = [];
        for kk=1:length(startFrame_vector)
            pause(30);
            try
                load(sprintf('%s.%d_%d.procFrame.mat',localpath, startFrame_vector(kk), frameEnd_vector(kk))); %#ok
            catch
                pause(240);
                load(sprintf('%s.%d_%d.procFrame.mat',localpath, startFrame_vector(kk), frameEnd_vector(kk))); %#ok
            end
            if(isfield(procFrame(1),'scalars'))%decompress procFrames if necessary
                procFrame = compress_decompress_procFrame(procFrame);
            end
            dummy_procFrame = append_procFrame(dummy_procFrame, procFrame);
            clear('procFrame');
        end
        procFrame = dummy_procFrame;
        clear('dummy_procFrame');
        fprintf('saving final procFrame to %s\t%s',procFrame_file, timeString)
        save_procFrame(procFrame_file,procFrame);
        
        % remove segment procFrame files
        for kk=1:length(startFrame_vector)
            rm(sprintf('%s.%d_%d.procFrame.mat',localpath, startFrame_vector(kk), frameEnd_vector(kk)));
        end
    end
    
        
    % save the background and ring as a pdf
    hidden_figure(15);
    imshow(global_background);
    hold on;
    plot(Ring.RingX, Ring.RingY,'.g','markersize',2);
    if(isfield(Ring,'arena_name'))
        for t=1:length(Ring.arena_name)
            text(Ring.arena_center(t,1), Ring.arena_center(t,2), fix_title_string(Ring.arena_name{t}), 'FontSize',18,'FontName','Helvetica','HorizontalAlignment','center','color','g');
        end
    end
    dummystring = fix_title_string(sprintf('%s.avi ring area = %f level = %f %dx%d pixels %f pixel/mm',localpath, Ring.Area, Ring.Level, FileInfo.Height, FileInfo.Width, 1/Ring.PixelSize));
    title(dummystring);
    dummystring = sprintf('%s.bkgnd.ring.pdf',localpath);
    if(isempty(Ring.ComparisonArrayX))
        dummystring = sprintf('%s.bkgnd.no_ring.pdf',localpath);
    end
    save_pdf(15, dummystring);
    close(15);
    pause(1); % let the GUI catch up
    clear('global_background');
    
    
    % this movie has multiple arenas, so create a procFrame file for each
    % then, re-run this function for each procFrame file
    % then return
    if(isfield(Ring,'arena_name'))
        multi_arena_split_procFrame(procFrame, Ring, stimulusfile, localpath, '');
        return;
    end
    
else
    fprintf('loading procFrame file %s .... %s\n',procFrame_file,timeString())
    procFrame = load_procFrame(procFrame_file);
end

if(isempty(Ring))
    ringfile = sprintf('%s.Ring.mat',localpath);
    load(ringfile); %#ok
    if(isfield(Ring,'arena_name'))
        multi_arena_split_procFrame(procFrame, Ring, stimulusfile, localpath, '');
        
        % clear any child m-files in temp
        rm(sprintf('%schild_command_script_%d*.m', tempdir,Prefs.PID));
        
        return;
    end
end

    if(isempty(Ring.ring_mask))
        Prefs.aggressive_wormfind_flag = 0;
    end
    
fprintf('assigning animals to tracks\t%s',timeString())

% additional info
if(isempty(FileInfo))
    FileInfo = moviefile_info(RealMovieName);
end
rawTracks = create_tracks(procFrame, FileInfo.Height, FileInfo.Width, Ring.PixelSize, Prefs.FrameRate, fullpath_from_filename(RealMovieName));
clear('localname');
clear('dummystring');


   FileName = sprintf('%s.rawTracks.mat',localpath);
    dummystring = sprintf('%s', FileName);
    saveTracks(dummystring, rawTracks);
    fprintf('%s saved %s\n', dummystring, timeString())

% analyse and save analysed Tracks
analyse_rawTracks(rawTracks, stimulusfile, localpath,'');
if(nargout==0)
    clear('rawTracks')
end

% remove copy of movie from tempdir
patch_aviread_to_gray('rm_temp');

% clear any child m-files in temp
rm(sprintf('%schild_command_script_%d*.m', tempdir,Prefs.PID));

Prefs = OPrefs;

return;
end
