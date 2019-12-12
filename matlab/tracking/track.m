% Tracker function, performs the actual machine vision for tracking the worms.
% The only arguments ever passed in through processPatchVids:
%   PatchTrackerAutomatedScript(vids{i-2}, 'quick', 'scale', char(measure), 'numworms', numworms, 'none')

function track(directoryListFilename, varargin)

rehash path; % refreshes the m-files after they have been edited repeatedly during the existence of a single MATLAB instance.
curr_dir = pwd; % char array of the path

global Prefs; % makes a global variable called Prefs; not a built-in MATLAB function
Prefs = [];
Prefs = patch_define_preferences(Prefs);
Prefs.Ringtype = 'noRingHereThanks';
patch_aviread_to_gray;
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

file_ptr = fopen('temp','w');
fprintf(file_ptr,'%s\n',directoryListFilename);
fclose(file_ptr);

file_ptr = fopen('temp','rt');
dummystringCellArray = textscan(file_ptr,'%s');
fclose(file_ptr);
delete('temp');

directoryList = char(dummystringCellArray{1});
animal_find_dud_idx = [];

curr_path = split(curr_dir, filesep); 
fprintf('\nCalculating background and rings for all the movies in folder %s\n', curr_path{end})

prefsfile = sprintf('%s%sPrefs.%d.mat',tempdir,filesep,Prefs.PID);
save(prefsfile, 'Prefs');

doneflag=0;
while(doneflag == 0)
        disp('1')
        doneflag = 1;
        for i = 1:length(directoryList(:,1)) % change to parfor
            disp('2')
            directoryList(i,:) = filesep_convert(directoryList(i,:));
            PathName = deblank(directoryList(i,:));
            dummystring = sprintf('%s.avi',PathName);
	    movieList = dir(dummystring); 
            for j=1:length(movieList)
                disp('3')
                [~, FilePrefix, ~] = fileparts(movieList(j).name);
                ringfile = sprintf('%s.Ring.mat',PathName);
                working_file = sprintf('%s.Ring.working',PathName);
                if(does_this_file_need_making(ringfile))
                    doneflag = 0;
                    disp('4')
                    
                    if(file_existence(working_file) == 0)
                        disp('5')
                        fp = fopen(working_file,'w'); fclose(fp);
                        fprintf('\nBeginning\t%s\n', timeString())
                        moviefile = sprintf('%s.avi',PathName);
                            ring(PathName, moviefile, scaleRing);
                    end
                else
                    if(file_existence(working_file)==1 && does_this_file_need_making(ringfile) == 0)
                        disp('6')
                        clear('Ring');
                        rm(working_file);
                    end
                end
            end
        end
        pause(2);
    end

% make background and find rings for all the movies
for i = 1:length(directoryList(:,1))
    disp('7')
    directoryList(i,:) = filesep_convert(directoryList(i,:));
    PathName = deblank(directoryList(i,:));

    %dummystring = sprintf('%s%s*.avi',PathName,filesep);
    dummystring = sprintf('%s.avi',PathName);
    movieList = dir(dummystring);
 
    for j=1:length(movieList)
        disp('8')
        [~, FilePrefix, ~] = fileparts(movieList(j).name);
        
        ringfile = sprintf('%s.Ring.mat',PathName);
        if(does_this_file_need_making(ringfile))
            disp('9')
            rm(ringfile);
            background = calculate_background(sprintf('%s.avi',PathName));
            % first pass, no manual intervention
            
            if(isempty(scaleRing))
                disp('10')
                Ring = find_ring(background,sprintf('%s',PathName), '', 0, quick);%%%
            else
                disp('11')
                if(strcmp(Prefs.Ringtype(1:6),'square'))
                    disp('12')
                    Ring = find_ring(background,sprintf('%s',PathName), '', 1, quick);%%%
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
                if(isempty(Ring.DefaultThresh))
                    disp('15')
                    [~, NumFoundWorms, ~, ~] = default_worm_threshold_level(sprintf('%s.avi',PathName), background, [], target_numworms, Ring, 0);
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
%disp('Manually pick rings, if needed')

for i = 1:length(directoryList(:,1))
    disp('17')
    directoryList(i,:) = filesep_convert(directoryList(i,:));
    PathName = deblank(directoryList(i,:));

    dummystring = sprintf('%s.avi',PathName);
    movieList = dir(dummystring);
    
    for j=1:length(movieList)
        disp('18')
        [~, FilePrefix, ~] = fileparts(movieList(j).name);
        background = calculate_background(sprintf('%s.avi',PathName));
        
        ringfile = sprintf('%s.Ring.mat',PathName);
        if(does_this_file_need_making(ringfile))
            disp('19')
            rm(ringfile);
            % manual intervention now permitted for finding ring
            Ring = find_ring(background,sprintf('%s',PathName), '', 1, quick);%%%
            
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

    dummystring = sprintf('%s.avi',PathName);
    movieList = dir(dummystring);
    
    fprintf('\n%s\n:',PathName)
    
    [~, FilePrefix, ~] = fileparts(movieList(j).name);
    
    background = calculate_background(sprintf('%s.avi',PathName));
    
    Ring = find_ring(background,sprintf('%s',PathName), '', 1, quick);%%%
    
    fprintf('%d %d %d %s.avi\n',i,j,Ring.NumWorms, PathName)
    
    ringfile = sprintf('%s.Ring.mat',PathName);
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
    
ls
    actually_processed_flag=0;
    
    % convert file paths automatically to the correct directory seperator
    directoryList(i,:) = filesep_convert(directoryList(i,:));
    
    localpath = PathName;
    PathName = deblank(directoryList(i,:));
    
    
    dummystring = sprintf('%s.avi',PathName);
    movieList = dir(dummystring);
    
    if(retrack_flag == 1)
        disp('24')
        rmstr = sprintf('%s*procFrame.mat',PathName);
        rm(rmstr);
        rmstr = sprintf('%s*Tracks.mat',PathName);
        rm(rmstr);
    end
    if(reanalyze_flag == 1)
        disp('25')
        rmstr = sprintf('%s.Tracks.mat',PathName);
        rm(rmstr);
        rmstr = sprintf('%s.BinData.mat',PathName);
        rm(rmstr);
        rmstr = sprintf('%s.linkedTracks.mat',PathName);
        rm(rmstr);
        rmstr = sprintf('%s.collapseTracks.mat',PathName);
        rm(rmstr);
        rmstr = sprintf('%s.psth*',PathName);
        rm(rmstr);
    end
    if(reanalyze_flag == 2)
        disp('26')
        rmstr = sprintf('%s.BinData.mat',PathName);
        rm(rmstr);
        rmstr = sprintf('%s.psth.BinData.mat',PathName);
        rm(rmstr);
    end
    
    % Track all the movies
    elapsed_time=[];
    et_index=0;
    for j=1:length(movieList)
        disp('27')

ls        
          [~, FilePrefix, ~] = fileparts(movieList(j).name);
        
        working_file = sprintf('%s.working',localpath);

ls        
        if(file_existence(working_file) == 0 && ...
                ( does_this_file_need_making(sprintf('%s.procFrame.mat',localpath), Prefs.trackerbirthday) == 1 || ...
                does_this_file_need_making(sprintf('%s.rawTracks.mat',localpath), Prefs.trackerbirthday) == 1 || ...
                does_this_file_need_making(sprintf('%s.Tracks.mat',localpath), Prefs.track_analysis_date) == 1 || ...
                does_this_file_need_making(sprintf('%s.linkedTracks.mat',localpath), Prefs.track_analysis_date) == 1 || ...
                does_this_file_need_making(sprintf('%s.collapseTracks.mat',localpath), Prefs.track_analysis_date) == 1 ) )
            disp('28')
            
            fprintf('\nprocessing %s.avi\n',localpath)
            actually_processed_flag=1;
            tic
            
            % remove any processed files for this movie, in case they exist
            fprintf('Removing old processed files for %s.avi\t%s\n',localpath, timeString())
            dummystring = sprintf('%s.Tracks.mat',localpath);
            rm(dummystring);
            dummystring = sprintf('%s.linkedTracks.mat',localpath);
            rm(dummystring);
            dummystring = sprintf('%s.collapseTracks.mat',localpath);
            rm(dummystring);
            dummystring = sprintf('%s.BinData.mat',localpath);
            rm(dummystring);
            dummystring = sprintf('%s*.txt',localpath);
            rm(dummystring);
            dummystring = sprintf('%s.*pdf',localpath);
            rm(dummystring);
            dummystring = sprintf('%s.psth_Tracks.mat',localpath);
            rm(dummystring);
            dummystring = sprintf('%s.psth.BinData.mat',localpath);
            rm(dummystring);
            
            
            if(does_this_file_need_making(sprintf('%s.rawTracks.mat',localpath), Prefs.trackerbirthday) == 1)
                disp('29')
                dummystring = sprintf('%s.rawTracks.mat',localpath);
                rm(dummystring);
            end
            
            if(does_this_file_need_making(sprintf('%s.procFrame.mat',localpath), Prefs.trackerbirthday) == 1)
                disp('30')
                dummystring = sprintf('%s.rawTracks.mat',localpath);
                rm(dummystring);
                dummystring = sprintf('%s.procFrame.mat',localpath);
                rm(dummystring);
            end
            
            fp = fopen(working_file,'w'); fclose(fp);
            fprintf('\nLaunching tracker\n')
            tracker(localpath,stimulusIntervalFile,target_numworms,Prefs.FrameRate);
            fprintf('\nFinished tracker\n')
            rm(working_file);
            
            
            et_index = et_index + 1;
            elapsed_time(et_index) = toc; %#ok, changes size bc inside of conditional, don't feel like rewriting code to be deterministic
        else
            disp('31')
            if(file_existence(working_file) == 1)
                disp('32')
                fprintf('\n%s%s.avi is being worked on\n',localpath)
            else if(does_this_file_need_making(sprintf('%s%s.rawTracks.mat',localpath), Prefs.trackerbirthday) == 0) %#ok, readability warning
                    disp('33')
                    fprintf('%s%s.avi has been processed\n',localpath)
                end
            end
        end
        
        if(file_existence(sprintf('%sstop.txt',pwd)))
            disp('34')
            fprintf('\nstop due to %sstop.txt\n',pwd)
            cd(curr_dir);
            return;
        end
        
    end
    
    analyse_flag=0;%analyse_flag=1;
    j=1;
    while(j<=length(movieList))
        disp('36')
        
        if(file_existence(sprintf('%sstop.txt',pwd)))
            disp('37')
            fprintf('\nstop due to %sstop.txt\n',pwd)
            cd(curr_dir);
            return;
        end
        
          [~, FilePrefix, ~] = fileparts(movieList(j).name);
        testfile = sprintf('%s.BinData.mat',PathName);
        working_file = sprintf('%s.working',PathName);
        if(file_existence(testfile)==0)  % this BinData file does not exist ... someone else is working on it, so let that process do the averaging
            analyse_flag=0;
            disp('38')
            

                if(file_existence(working_file))
                    disp('42')
                    fprintf('%s exists ... another CPU should complete and average this directory\n',working_file)
                else
                    disp('43')
                    fprintf('\nNeither %s nor %s exists ... consider re-running PatchTrackerAutomatedScript for directory %s\n',testfile, working_file, localpath)
                end
%             end
        end
        j=j+1;
    end
    
    
    if(file_existence(sprintf('%sstop.txt',pwd)))
        disp('44')
        fprintf('\nstop due to %sstop.txt\n',pwd)
        cd(curr_dir);
        return;
    end
    
    if(analyse_flag==1)
        disp('45')
        if(trackonly_flag==0)
            disp('46')
            % if the averaged files don't exist, make them
            if( does_this_file_need_making(sprintf('%s.avg.collapseTracks.mat',localpath), Prefs.trackerbirthday) == 1 || ...
                    does_this_file_need_making(sprintf('%s.avg.BinData.mat',localpath), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s.avg.BinData_array.mat',localpath), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s.avg.freqs.txt',localpath), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s.avg.non_freqs.txt',localpath), Prefs.trackerbirthday) == 1  || ...
                    does_this_file_need_making(sprintf('%s.avg.pdf',localpath), Prefs.trackerbirthday) == 1 )
                disp('47')
                actually_processed_flag=1;
            end
            
            if(~isempty(stimulusIntervalFile))
                disp('48')
                if( does_this_file_need_making(sprintf('%s.avg.psth.BinData.mat',localpath), Prefs.trackerbirthday) == 1 || ...
                        does_this_file_need_making(sprintf('%s.avg.psth.pdf',localpath), Prefs.trackerbirthday) == 1  || ...
                        does_this_file_need_making(sprintf('%s.avg.psth_Tracks.mat',localpath), Prefs.trackerbirthday) == 1  )
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
patch_aviread_to_gray('rm_temp');

clear('Prefs');

cd(curr_dir);
return;
end
