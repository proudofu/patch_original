% Kamal Edit Notes:
% This function contains collision detection functionality.
% How to trim all collision detection without trimming basic functionality?


function finalTracks = track_final(folder) % Folder should have all files for one video

%find the 3 tracks files and delete them - also open procFrame

PathofFolder = sprintf('%s',folder);
PathName = sprintf('%s',PathofFolder);
fileList = string(split(ls));
numFiles = length(fileList);

indexHere = 1;
for j=3:numFiles
    string2 = deblank(fileList(j,:));
    [pathstr, FilePrefix, ext] = fileparts(string2);
    %[pathstr, FilePrefix, ext] = fileparts(fileList);
    [pathstr2, FilePrefix2, ext2] = fileparts(FilePrefix);

    if(strcmp(ext2,'.Tracks')==1 || strcmp(ext2,'.rawTracks')==1 || strcmp(ext2,'.linkedTracks')==1||strcmp(ext2,'.collapseTracks')==1)
        fileName = deblank(fileList(j,:));
        filesToDelete{indexHere} = sprintf('%s', fileName);
        indexHere = indexHere+1;
    end
    
    if(strcmp(ext2,'.Tracks')==1)
        fileName = deblank(fileList(j,:));
        fileToOpen = sprintf('%s', fileName);
        load(fileToOpen)
    end
    
    if(strcmp(ext2,'.procFrame')==1)
        fileName = deblank(fileList(j,:));
        fileToOpen = sprintf('%s', fileName);
        load(fileToOpen)
    end
end

%get info on Tracks, then delete
who
trackHeight = Tracks(1).Height;
trackWidth = Tracks(1).Width;
PixelSizeVideo = Tracks(1).PixelSize;
FrameRateVideo = Tracks(1).FrameRate;
TrackName = Tracks(1).Name;
[pathstr3, FilePrefix_ForTrack, ext3] = fileparts(TrackName);

for j=1:(indexHere-1)
    delete(filesToDelete{j});
end

clear('indexHere');
clear('Tracks');

%Initialize Prefs

global Prefs;

OPrefs = Prefs;

Prefs = [];
Prefs = define_preferences(Prefs);
Prefs.PixelSize = PixelSizeVideo;
Prefs = CalcPixelSizeDependencies(Prefs, Prefs.PixelSize);


%Make rawTracks and Tracks
 Prefs.aggressive_linking = 0;
 rawTracks = create_tracks_LinkMiss(procFrame, trackHeight, trackWidth, PixelSizeVideo, FrameRateVideo, TrackName);
 
 [Tracks, linkedTracks] = analyse_rawTracks_LinkMiss(rawTracks, [], '', FilePrefix_ForTrack);
 
  %Save rawTracks
 disp(FilePrefix_ForTrack) 
  FileName = sprintf('%s.rawTracks.mat',FilePrefix_ForTrack);
  dummystring = sprintf('%s',FileName);
  disp(dummystring)
  saveTracks(dummystring, rawTracks);
  fprintf('Saved %s\t%s\n', dummystring, timeString())

% Re-Do linkage (from beginning) with new prefs for ON-FOOD, no-care for direction, agg=0,
% and set to 'missing' - use Tracks file


Prefs.MaxCentroidShift_mm_per_sec =.125;
Prefs.MaxTrackLinkSeconds = 108;
Prefs.PixelSize = PixelSizeVideo;
Prefs = CalcPixelSizeDependencies(Prefs, Prefs.PixelSize);

linkedTracks = link_tracks(Tracks, 1, 0, 1, 'missing'); % no direction variable
Tracks=linkedTracks;

%%%save linkedTracks

  FileName = sprintf('%s.linkedTracks.mat',FilePrefix_ForTrack);
  dummystring = sprintf('%s',FileName);
  saveTracks(dummystring, linkedTracks);
  fprintf('Saved %s\t%s\n', dummystring, timeString())

%%%%%%%%%Deal with collisions 

%%%Add "Path" field to Tracks file

for i=1:length(Tracks)
    numFr = Tracks(i).NumFrames;
    for j=1:numFr
        Tracks(i).Path(j,1:2) = [Tracks(i).SmoothX(j) Tracks(i).SmoothY(j)];
    end
end

for i=1:length(rawTracks)
    numFr = rawTracks(i).NumFrames;
    for j=1:numFr
        rawTracks(i).Path(j,1:2) = [rawTracks(i).SmoothX(j) rawTracks(i).SmoothY(j)];
    end
end
 
% Throw out short Tracks [be a little more generous?]

numTracksAfterColl = length(Tracks);
tracks_length = zeros(length(numTracksAfterColl)); % preallocating for speed
for i=1:numTracksAfterColl
    tracks_length(i) = Tracks(i).NumFrames;
end
index_less_than_5min = find(tracks_length<900);
Tracks(index_less_than_5min) = [];

% Decide on Speed StepSize (1?)

% Rename resulting linkedTracks file finalTracks and save

finalTracks = Tracks;

for t = 1:length(finalTracks)
    if t >= 10
        b = '00';
    elseif t >= 100
        b = '0';
    elseif t >= 1000
        b = '';
    else
        b = '000';
    end
    finalTracks(t).ID = sprintf('%s_worm%s%i', FilePrefix_ForTrack, b, t);
end
  
  
  
  FileName = sprintf('%s.finalTracks.mat',FilePrefix_ForTrack);
  dummystring = sprintf('%s', FileName);
  saveTracks(dummystring, finalTracks);
  fprintf('Saved %s\t%s\n', dummystring, timeString())

% Check Compatibility with HMM analyses

% Write an extra wrapper that does TrackerAutomated and then my finalizing

end
