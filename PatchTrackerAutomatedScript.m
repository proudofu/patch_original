% Tracker function, performs the actual machine vision for tracking the worms.
% The only arguments ever passed in through processPatchVids:
%   PatchTrackerAutomatedScript(vids{i-2}, 'quick', 'scale', char(measure), 'numworms', numworms, 'none')

function PatchTrackerAutomatedScript(directoryListFilename, varargin)

rehash path; % refreshes the m-files after they have been edited repeatedly during the existence of a single MATLAB instance.
curr_dir = pwd; % char array of the path

global Prefs; % makes a global variable called Prefs; not a built-in MATLAB function
Prefs = [];
Prefs = define_preferences(Prefs);
Prefs.Ringtype = 'noRingHereThanks';
aviread_to_gray;
stimulusIntervalFile = '';
trackonly_flag = 0;
trackmasterflag = 0;
retrack_flag = 0;
reanalyze_flag = 0;
dont_track_flag = 0;
quick = 1;
pixelsize_MovieName = varargin{3};
target_numworms = varargin{5};
scaleRing = get_pixelsize_from_arbitrary_object(pixelsize_MovieName);
Prefs.DefaultPixelSize = scaleRing.PixelSize;
Prefs.PixelSize = scaleRing.PixelSize;
Prefs = CalcPixelSizeDependencies(Prefs, Prefs.DefaultPixelSize);
Prefs.DefaultNumWormRange = [min(target_numworms) max(target_numworms)];
target_numworms = 0;

%%% Can delete below block based on running tracker with traces
% for i=1:length(directoryListFilename)
%     ds = sprintf('PatchTrackerAutomatedScript(''%s'', ''dont_track''',directoryListFilename{i});
%     for v=1:length(varargin) 
%         if(ischar(varargin{v}))
%             ds = sprintf('%s,''%s''',ds,varargin{v});
%         else
%             ds = sprintf('%s,%d',ds,varargin{v});
%         end
%     end
%     ds = sprintf('%s);',ds);
%     eval(ds);
% end
% for i=1:length(directoryListFilename)
%     ds = 'PatchTrackerAutomatedScript(directoryListFilename{i}';
%     for v=1:length(varargin) 
%         if(ischar(varargin{v}))
%             ds = sprintf('%s,''%s''',ds,varargin{v});
%         else
%             ds = sprintf('%s,%d',ds,varargin{v});
%         end
%     end
%     ds = sprintf('%s);',ds);
%     eval(ds);
% end
% return;

%%% Keep
% file_ptr = fopen(directoryListFilename,'rt');      % file_ptr will always be a directory, also shwon via tracker tracing
% if(file_ptr == -1) % directoryListFilename is not an actual file, but is a directory

file_ptr = fopen('temp','w');
fprintf(file_ptr,'%s\n',directoryListFilename);
fclose(file_ptr);

file_ptr = fopen('temp','rt');
dummystringCellArray = textscan(file_ptr,'%s');
fclose(file_ptr);
delete('temp');

%%% Delete
% else % is a file                                   % Same reasoning as above, will always be a directory.      
%     
% [PathName, FilePrefix, ~] = fileparts(directoryListFilename); % replaced ext with ~ because ext is not used given unreached conditionals
% 
% if(strcmp(ext,'.avi')==1) % is a single avi file <------- always true
%     fclose(file_ptr);
% 
% if(~isempty(PathName))
%     fps = sprintf('%s%s%s',PathName,filesep,FilePrefix);
% else
%     fps = FilePrefix;
% end
% 
% If rerunning this script on previously analyzed vids, erase the existing files.
% if(retrack_flag == 1)
%     rmstr = sprintf('%s.*.mat',fps);
%     rm(rmstr);
% end
% if(reanalyze_flag == 1)
%     rmstr = sprintf('%s.Tracks.mat',fps);
%     rm(rmstr);
%     rmstr = sprintf('%s.linkedTracks.mat',fps);
%     rm(rmstr);
%     rmstr = sprintf('%s.collapseTracks.mat',fps);
%     rm(rmstr);
%     rmstr = sprintf('%s.BinData.mat',fps);
%     rm(rmstr);
% end
% if(reanalyze_flag == 2)
%     rmstr = sprintf('%s.BinData.mat',fps);
%     rm(rmstr);
% end
% 
% if(isempty(PathName))
%     PathName = pwd;
% end
% 
% background = calculate_background(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix));
% 
% ringfile = sprintf('%s%s%s.Ring.mat',PathName, filesep, FilePrefix);
% if(isempty(scaleRing))
%     Ring = find_ring(background,sprintf('%s%s',PathName,filesep), FilePrefix, 1, quick);%%%
% else
%     if(strcmp(Prefs.Ringtype(1:6),'square'))
%         Ring = find_ring(background,sprintf('%s%s',PathName,filesep), FilePrefix, 1, quick);%%%
%     else
%         Ring = scaleRing;
%     end
%     Ring.PixelSize = scaleRing.PixelSize;
%     save(ringfile, 'Ring');
% end
% 
% 
% 
% if(isempty(Ring.DefaultThresh))
%     [~, ~, ~, Ring] = default_worm_threshold_level(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix), background, [], target_numworms, Ring, 1);
%     save(ringfile,'Ring');
% end
% 
% if(dont_track_flag==1)
%     cd(curr_dir);
%     return;
% end
% 
% 
% command = sprintf('Tracker(''%s'',''%s'',''%s'','''',''numworms'',%d, ''framerate'', %d)', PathName, FilePrefix, stimulusIntervalFile, target_numworms, Prefs.FrameRate);
% eval(command);
% 
%         dummystring = 'SingleFileJeffsTrackerAutomatedScript(directoryListFilename';
%         for(v=1:length(varargin))
%             dummystring = sprintf('%s,''%s''',dummystring,varargin{v});
%         end
%         dummystring = sprintf('%s)',dummystring);
%         eval(dummystring);
% 
% cd(curr_dir);
% return;
%     
% else % is a bona fide directory list file
%     dummystringCellArray = textscan(file_ptr,'%s');
%     fclose(file_ptr);
% end
% end

%%% The meat
% change for to parfor on line 176
% silencing the launch_matlab_command and going straight to the else statement prevents child process spawning.
% this can likely be put into a parfor loop quite easily once cleaned up.

directoryList = char(dummystringCellArray{1});
animal_find_dud_idx = [];

curr_path = split(curr_dir, filesep); 
fprintf('Calculating background and rings for all the movies in folder %s\n', curr_path{end})
%disp('Some might need manual intervention later, so please do not leave yet!') % Wanna delete this message

% parallel processing for ring and animal finding
% if(Prefs.NumCPU > 3)
    prefsfile = sprintf('%s%sPrefs.%d.mat',tempdir,filesep,Prefs.PID);
    save(prefsfile, 'Prefs');
%     num_cpus = Prefs.NumCPU;
    doneflag=0;
    while(doneflag == 0)
        disp('1')
        doneflag = 1;
        for i = 1:length(directoryList(:,1)) % change to parfor
            disp('2')
            directoryList(i,:) = filesep_convert(directoryList(i,:));
            PathName = deblank(directoryList(i,:));

% localpath never used
%             if(strcmp(PathName,'')==0)
%                 localpath = PathName;
%                 if(localpath(end)~=filesep)
%                     localpath = sprintf('%s%s',PathName, filesep);
%                 end
%             else
%                 localpath = '';
%             end

            dummystring = sprintf('%s%s*.avi',PathName,filesep);
            movieList = dir(dummystring);
            
            for j=1:length(movieList)
                disp('3')
%                 [pathstr, FilePrefix, ext] = fileparts(movieList(j).name); % pathstr and ext never used in this loop
                [~, FilePrefix, ~] = fileparts(movieList(j).name);
                ringfile = sprintf('%s%s%s.Ring.mat',PathName, filesep, FilePrefix);
                working_file = sprintf('%s%s%s.Ring.working',PathName, filesep, FilePrefix);
                
                if(does_this_file_need_making(ringfile))
                    doneflag = 0;
                    disp('4')
                    
                    if(file_existence(working_file) == 0)
                        disp('5')
                        fp = fopen(working_file,'w'); fclose(fp);
%                         fprintf('%s%s%s.avi\t%s',PathName, filesep, FilePrefix, timeString())
                        fprintf('Beginning\t%s\n', timeString())
                        moviefile = sprintf('%s%s%s.avi',PathName, filesep, FilePrefix);
                        
%                         command = sprintf('cd %s; global Prefs; Prefs = []; load %s;', pwd, prefsfile);
%                         command = sprintf('%s scaleRing = find_ring(''%s'');', command, pixelsize_MovieName);
%                         command = sprintf('%s calc_background_ring_worm_count(''%s'', ''%s'', scaleRing, %i);', command, PathName, moviefile, quick);
                        
%                         if(num_cpus>1)
%                             launch_matlab_command(command,1);
%                             num_cpus = num_cpus - 1;
%                         else
                            calc_background_ring_worm_count(PathName, moviefile, scaleRing);
%                         end
                    end
                else
                    % working file exists and the ringfile exists ...
                    % so, the ringfile was just made
                    if(file_existence(working_file)==1 && does_this_file_need_making(ringfile) == 0)
                        disp('6')
%                         num_cpus = num_cpus+1;
                        %                         load(ringfile);
                        %                         if(Ring.NumWorms < Prefs.DefaultNumWormRange(1) || Ring.NumWorms > Prefs.DefaultNumWormRange(2))
                        %                             animal_find_dud_idx = [animal_find_dud_idx; i j];
                        %                         end
                        clear('Ring');
                        rm(working_file);
                    end
                end
            end
        end
        pause(2);
    end
% end

% make background and find rings for all the movies
for i = 1:length(directoryList(:,1))
    disp('7')
    directoryList(i,:) = filesep_convert(directoryList(i,:));
    PathName = deblank(directoryList(i,:));

% localpath never used
%     if(strcmp(PathName,'')==0)
%         localpath = PathName;
%         if(localpath(end)~=filesep)
%             localpath = sprintf('%s%s',PathName, filesep);
%         end
%     else
%         localpath = '';
%     end

    dummystring = sprintf('%s%s*.avi',PathName,filesep);
    movieList = dir(dummystring);
    
    % disp([sprintf('%s:',PathName)])
    
    for j=1:length(movieList)
        disp('8')
        % pathstr and ext not used
%         [pathstr, FilePrefix, ext] = fileparts(movieList(j).name);
        [~, FilePrefix, ~] = fileparts(movieList(j).name);
        
        ringfile = sprintf('%s%s%s.Ring.mat',PathName, filesep, FilePrefix);
        if(does_this_file_need_making(ringfile))
            disp('9')
            rm(ringfile);
            background = calculate_background(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix));
            % first pass, no manual intervention
            
            if(isempty(scaleRing))
                disp('10')
                Ring = find_ring(background,sprintf('%s%s',PathName,filesep), FilePrefix, 0, quick);%%%
            else
                disp('11')
                if(strcmp(Prefs.Ringtype(1:6),'square'))
                    disp('12')
                    Ring = find_ring(background,sprintf('%s%s',PathName,filesep), FilePrefix, 1, quick);%%%
                else
                    disp('13')
                    Ring = scaleRing;
                end
                Ring.PixelSize = scaleRing.PixelSize;
                save(ringfile, 'Ring');
            end
            
            % successfully found ring, so calc default threshold for finding animals
            if(~does_this_file_need_making(ringfile))
                disp('14')
                %if(target_numworms == 0)
                if(isempty(Ring.DefaultThresh))
                    disp('15')
%                     [DefaultLevel, NumFoundWorms, mws, Ring] = default_worm_threshold_level(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix), background, [], target_numworms, Ring, 0);
                    [~, NumFoundWorms, ~, ~] = default_worm_threshold_level(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix), background, [], target_numworms, Ring, 0);
                    save(ringfile, 'Ring');
                    
                    if(NumFoundWorms < Prefs.DefaultNumWormRange(1) || NumFoundWorms > Prefs.DefaultNumWormRange(2))
                        disp('16')
                        animal_find_dud_idx = [animal_find_dud_idx; i j]; %#ok,conditional, don't feel like heavily changing code
                    end
                end
                %end
            end
            clear Ring;
            clear background;
        end
    end
end

% now allow manual intervention for those files that failed
disp('Manually pick rings, if needed')

for i = 1:length(directoryList(:,1))
    disp('17')
    directoryList(i,:) = filesep_convert(directoryList(i,:));
    PathName = deblank(directoryList(i,:));

% localpath not used
%     if(strcmp(PathName,'')==0)
%         localpath = PathName;
%         if(localpath(end)~=filesep)
%             localpath = sprintf('%s%s',PathName, filesep);
%         end
%     else
%         localpath = '';
%     end
    
    dummystring = sprintf('%s%s*.avi',PathName,filesep);
    movieList = dir(dummystring);
    
    for j=1:length(movieList)
        disp('18')
        % pathstr and ext not used
%         [pathstr, FilePrefix, ext] = fileparts(movieList(j).name);
        [~, FilePrefix, ~] = fileparts(movieList(j).name);
        background = calculate_background(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix));
        
        ringfile = sprintf('%s%s%s.Ring.mat',PathName, filesep, FilePrefix);
        if(does_this_file_need_making(ringfile))
            disp('19')
            rm(ringfile);
            % manual intervention now permitted for finding ring
            Ring = find_ring(background,sprintf('%s%s',PathName,filesep), FilePrefix, 1, quick);%%%
            
            % find default thresholds and number of worms this file now that we have the manual ring  ...
            %if(target_numworms == 0)
%             [DefaultLevel, NumFoundWorms, mws, Ring] = default_worm_threshold_level(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix), background, [], target_numworms, Ring, 0);
            [~, NumFoundWorms, ~, ~] = default_worm_threshold_level(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix), background, [], target_numworms, Ring, 0);
            save(ringfile,'Ring');
            
            if(NumFoundWorms < Prefs.DefaultNumWormRange(1) || NumFoundWorms > Prefs.DefaultNumWormRange(2))
                disp('20')
                animal_find_dud_idx = [animal_find_dud_idx; i j]; %#ok,conditional, don't feel like heavily changing code
            end
            %end
            
            clear('Ring');
        end
        clear('background');
    end
end

for k=1:size(animal_find_dud_idx,1)
    disp('21')
    
    i = animal_find_dud_idx(k,1);
    j = animal_find_dud_idx(k,2);
    directoryList(i,:) = filesep_convert(directoryList(i,:));
    PathName = deblank(directoryList(i,:));

% localpath not used
%     if(strcmp(PathName,'')==0)
%         localpath = PathName;
%         if(localpath(end)~=filesep)
%             localpath = sprintf('%s%s',PathName, filesep);
%         end
%     else
%         localpath = '';
%     end

    dummystring = sprintf('%s%s*.avi',PathName,filesep);
    movieList = dir(dummystring);
    
    fprintf('%s:',PathName)
    
    % pathstr and ext not used
%     [pathstr, FilePrefix, ext] = fileparts(movieList(j).name);
    [~, FilePrefix, ~] = fileparts(movieList(j).name);
    
    background = calculate_background(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix));
    
    Ring = find_ring(background,sprintf('%s%s',PathName,filesep), FilePrefix, 1, quick);%%%
    
    fprintf('%d %d %d %s%s%s.avi',i,j,Ring.NumWorms, PathName, filesep, FilePrefix)
    
    % None of these variables even used in the rest of this loop.
%     [DefaultLevel, NumFoundWorms, mws, Ring] = default_worm_threshold_level(sprintf('%s%s%s.avi',PathName, filesep, FilePrefix), background, [], target_numworms, Ring, 1);
    ringfile = sprintf('%s%s%s.Ring.mat',PathName, filesep, FilePrefix);
    save(ringfile,'Ring');
    
    clear('Ring');
    clear('background');
end

if(dont_track_flag==1)
    disp('22')
    cd(curr_dir);
    return;
end

for i = 1:length(directoryList(:,1))
    disp('23')
    
    actually_processed_flag=0;
    
    % convert file paths automatically to the correct directory seperator
    directoryList(i,:) = filesep_convert(directoryList(i,:));
    
    PathName = deblank(directoryList(i,:));
    
    if(strcmp(PathName,'')==0)
        localpath = PathName;
        if(localpath(end)~=filesep)
            localpath = sprintf('%s%s',PathName, filesep);
        end
    else
        localpath = '';
    end
    
    
    dummystring = sprintf('%s%s*.avi',PathName,filesep);
    movieList = dir(dummystring);
    
    if(retrack_flag == 1)
        disp('24')
        rmstr = sprintf('%s%s*procFrame.mat',PathName,filesep);
        rm(rmstr);
        rmstr = sprintf('%s%s*Tracks.mat',PathName,filesep);
        rm(rmstr);
    end
    if(reanalyze_flag == 1)
        disp('25')
        rmstr = sprintf('%s%s*.Tracks.mat',PathName,filesep);
        rm(rmstr);
        rmstr = sprintf('%s%s*.BinData.mat',PathName,filesep);
        rm(rmstr);
        rmstr = sprintf('%s%s*.linkedTracks.mat',PathName,filesep);
        rm(rmstr);
        rmstr = sprintf('%s%s*.collapseTracks.mat',PathName,filesep);
        rm(rmstr);
        rmstr = sprintf('%s%s*.psth*',PathName,filesep);
        rm(rmstr);
    end
    if(reanalyze_flag == 2)
        disp('26')
        rmstr = sprintf('%s%s*.BinData.mat',PathName,filesep);
        rm(rmstr);
        rmstr = sprintf('%s%s*.psth.BinData.mat',PathName,filesep);
        rm(rmstr);
    end
    
    % Track all the movies
    elapsed_time=[];
    et_index=0;
    for j=1:length(movieList)
        disp('27')
        
%         [pathstr, FilePrefix, ext] = fileparts(movieList(j).name);
          [~, FilePrefix, ~] = fileparts(movieList(j).name);
%         [pathstr, prf, ext] = fileparts(FilePrefix); % doesnt appear to be used
        
        % The below block is not commented out by me, Kamal
        %         if(strcmp(PathName,'')==0)
        %             localpath = PathName;
        %             if(localpath(end)~=filesep)
        %                 localpath = sprintf('%s%s',PathName, filesep);
        %             end
        %         else
        %             localpath = '';
        %         end
        
        working_file = sprintf('%s%s.working',localpath, FilePrefix);
        
        if(file_existence(working_file) == 0 && ...
                ( does_this_file_need_making(sprintf('%s%s.procFrame.mat',localpath, FilePrefix), Prefs.trackerbirthday) == 1 || ...
                does_this_file_need_making(sprintf('%s%s.rawTracks.mat',localpath, FilePrefix), Prefs.trackerbirthday) == 1 || ...
                does_this_file_need_making(sprintf('%s%s.Tracks.mat',localpath, FilePrefix), Prefs.track_analysis_date) == 1 || ...
                does_this_file_need_making(sprintf('%s%s.linkedTracks.mat',localpath, FilePrefix), Prefs.track_analysis_date) == 1 || ...
                does_this_file_need_making(sprintf('%s%s.collapseTracks.mat',localpath, FilePrefix), Prefs.track_analysis_date) == 1 ) )
            disp('28')
            
            fprintf('processing %s%s.avi',localpath, FilePrefix)
            actually_processed_flag=1;
            tic
            
            % remove any processed files for this movie, in case they exist
            fprintf('Removing old processed files for %s%s.avi\t%s',localpath,FilePrefix, timeString())
            dummystring = sprintf('%s%s.Tracks.mat',localpath,FilePrefix);
            rm(dummystring);
            dummystring = sprintf('%s%s.linkedTracks.mat',localpath,FilePrefix);
            rm(dummystring);
            dummystring = sprintf('%s%s.collapseTracks.mat',localpath,FilePrefix);
            rm(dummystring);
            dummystring = sprintf('%s%s.BinData.mat',localpath,FilePrefix);
            rm(dummystring);
            dummystring = sprintf('%s%s*.txt',localpath,FilePrefix);
            rm(dummystring);
            dummystring = sprintf('%s%s*.pdf',localpath,FilePrefix);
            rm(dummystring);
            dummystring = sprintf('%s%s.psth_Tracks.mat',localpath,FilePrefix);
            rm(dummystring);
            dummystring = sprintf('%s%s.psth.BinData.mat',localpath,FilePrefix);
            rm(dummystring);
            
            
            if(does_this_file_need_making(sprintf('%s%s.rawTracks.mat',localpath, FilePrefix), Prefs.trackerbirthday) == 1)
                disp('29')
                dummystring = sprintf('%s%s.rawTracks.mat',localpath,FilePrefix);
                rm(dummystring);
            end
            
            if(does_this_file_need_making(sprintf('%s%s.procFrame.mat',localpath, FilePrefix), Prefs.trackerbirthday) == 1)
                disp('30')
                dummystring = sprintf('%s%s.rawTracks.mat',localpath,FilePrefix);
                rm(dummystring);
                dummystring = sprintf('%s%s.procFrame.mat',localpath,FilePrefix);
                rm(dummystring);
            end
            
            % remove the averaged files since they will need to be remade
            %             dummystring = sprintf('%s%s*',localpath,prefix_from_path(PathName));
            %             rm(dummystring);
            
            % Child process; remove it
            fp = fopen(working_file,'w'); fclose(fp);
%             command = sprintf('
            Tracker(localpath,FilePrefix,stimulusIntervalFile,'','numworms',target_numworms, 'framerate', Prefs.FrameRate);
%             ', localpath, FilePrefix, stimulusIntervalFile, target_numworms, Prefs.FrameRate);
%             launch_matlab_command(command);
            rm(working_file);
            
            
            et_index = et_index + 1;
            elapsed_time(et_index) = toc; %#ok, changes size bc inside of conditional, don't feel like rewriting code to be deterministic
        else
            disp('31')
            if(file_existence(working_file) == 1)
                disp('32')
                fprintf('%s%s.avi is being worked on',localpath, FilePrefix)
            else if(does_this_file_need_making(sprintf('%s%s.rawTracks.mat',localpath, FilePrefix), Prefs.trackerbirthday) == 0) %#ok, readability warning
                    disp('33')
                    fprintf('%s%s.avi has been processed',localpath, FilePrefix)
                end
            end
        end
        
        if(file_existence(sprintf('%s%sstop.txt',pwd,filesep)))
            disp('34')
            fprintf('stop due to %s%sstop.txt',pwd,filesep)
            cd(curr_dir);
            return;
        end
        
    end
    % Analyse all the Tracks, combine the independent experiments in this
    % directory
    
    mean_time_per_run=150;
    if(~isempty(elapsed_time))
        disp('35')
        mean_time_per_run = mean(elapsed_time);
    end
    
    analyse_flag=0;%analyse_flag=1;
    j=1;
    while(j<=length(movieList))
        disp('36')
        
        if(file_existence(sprintf('%s%sstop.txt',pwd,filesep)))
            disp('37')
            fprintf('stop due to %s%sstop.txt',pwd,filesep)
            cd(curr_dir);
            return;
        end
        
%         [pathstr, FilePrefix, ext] = fileparts(movieList(j).name); % only FilePrefix is actually used
          [~, FilePrefix, ~] = fileparts(movieList(j).name);
%         [pathstr, prf, ext] = fileparts(FilePrefix); % none of these variables are actually used.
        testfile = sprintf('%s%s%s.BinData.mat',PathName,filesep, FilePrefix);
        working_file = sprintf('%s%s%s.working',PathName,filesep, FilePrefix);
        if(file_existence(testfile)==0)  % this BinData file does not exist ... someone else is working on it, so let that process do the averaging
            analyse_flag=0;
            disp('38')
            if(trackmasterflag==1)  % but this process is a master, so wait for the jobs to finish
                disp('39')
                j=0;
%                 analyse_flag=1;
                stopflag=0;
                tic;
                while(stopflag==0)
                    et = toc;
                    fprintf('Will wait %f sec for %s%s.avi to finish\t%s',2*mean_time_per_run-et, localpath, FilePrefix,timeString())
                    if(et > 2*mean_time_per_run)
                        disp('40')
                        fprintf('something wrong with processing %s%s.avi ... this computer will retry it\t%s',localpath, FilePrefix,timeString())
                        rm(working_file);
                        command = sprintf('Tracker(''%s'',''%s'',''%s'', '''',''numworms'',%d, ''framerate'', %d)', PathName, FilePrefix, stimulusIntervalFile,target_numworms, Prefs.FrameRate);
                        fprintf('processing %s%s.avi',localpath, FilePrefix)
                        launch_matlab_command(command);
                        actually_processed_flag=1;
                        stopflag=1;
                    end
                    if(file_existence(testfile)==1)
                        disp('41')
                        stopflag=1;
                    else
                        pause(10);
                    end
                end
            else
                if(file_existence(working_file))
                    disp('42')
                    fprintf('%s exists ... another CPU should complete and average this directory',working_file)
                else
                    disp('43')
                    fprintf('Neither %s nor %s exists ... consider re-running PatchTrackerAutomatedScript for directory %s',testfile, working_file, localpath)
                end
            end
        end
        j=j+1;
    end
    
    
    if(file_existence(sprintf('%s%sstop.txt',pwd,filesep)))
        disp('44')
        fprintf('stop due to %s%sstop.txt',pwd,filesep)
        cd(curr_dir);
        return;
    end
    
    if(analyse_flag==1)
        disp('45')
        if(trackonly_flag==0)
            disp('46')
            % if the averaged files don't exist, make them
            if( does_this_file_need_making(sprintf('%s%s.avg.collapseTracks.mat',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1 || ...
                    does_this_file_need_making(sprintf('%s%s.avg.BinData.mat',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s%s.avg.BinData_array.mat',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s%s.avg.freqs.txt',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s%s.avg.non_freqs.txt',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s%s.avg.pdf',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1 )
                disp('47')
                actually_processed_flag=1;
            end
            
            if(~isempty(stimulusIntervalFile))
                disp('48')
                if( does_this_file_need_making(sprintf('%s%s.avg.psth.BinData.mat',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1 || ...
                        does_this_file_need_making(sprintf('%s%s.avg.psth.pdf',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1  || ...
                        does_this_file_need_making(sprintf('%s%s.avg.psth_Tracks.mat',localpath, prefix_from_path(PathName)), Prefs.trackerbirthday) == 1  )
                    actually_processed_flag=1;
                    disp('49')
                end
            end
            
            if(actually_processed_flag==1 || reanalyze_flag>0) % reanalyse and average only if movies were actually processed
                AnalysisMaster(PathName, 'stimulusIntervalFile',stimulusIntervalFile);
                disp('50')
            end
        end
    end
    
end

% remove copy of movie from tempdir
aviread_to_gray('rm_temp');

clear('Prefs');

cd(curr_dir);
return;
end
