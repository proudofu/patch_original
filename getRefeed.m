function [allFinalTracks] = getRefeed(date) % date is in YYYYMMDD format, a string

% Turn off known warnings:
warning('off', 'images:initSize:adjustingMag') % Anticipate image resizing during user lawn border selection

cd(sprintf('G:/behavior/%s', date)); % Hard-coded, replace with own video file location

nested = true; %nested is boolean indicating whether all mat files are in same folder or individual folders

allFinalTracks = struct();
clean = {'Eccentricity'
    'MajorAxes'
    'RingDistance'
    'Image'
    'body_contour'
    'NumFrames'
    'numActiveFrames'
    'original_track_indicies'
    'Reorientations'
    'State'
    'body_angle'
    'head_angle'
    'tail_angle'
    'midbody_angle'
    'curvature_vs_body_position_matrix'
    'Curvature'
    'mvt_init'
    'stimulus_vector'};

folders = dir; %each video's files should be in own folder named date_genotype_vid#(_Cam#)...
folders = folders([folders.isdir]);
folders = folders(3:end);
for i=1:length(folders)
    fileName = strread(folders(i).name,'%s','delimiter','_');
    cd (folders(i).name)
    lawnFile = dir([fileName{1} '*.lawnFile.mat']);
    if isempty(lawnFile)
        edgeFile = dir([fileName{1} '*.edge.mat']);
        if ~isempty(edgeFile)
            load(edgeFile.name);
        else
            edge = [];
        end
        bgFile = dir([fileName{1} '*.background.mat']);
        load(bgFile.name);
        [edge, lawn] = findBorderManually(bkgnd, edge);
        vidName = strread(folders(i).name,'%s','delimiter','.');
        save([vidName{1} '.lawnFile.mat'], 'edge', 'lawn');
    end
    cd ..
end
for i=1:length(folders)
    fileName = strread(folders(i).name,'%s','delimiter','_');
    group = fileName{3};
    video = fileName{end-1};
    cd (folders(i).name)
    file = dir('*.finalTracks.mat');
    load(file.name);
    lawnFile = dir('*.lawnFile.mat');
    load(lawnFile(1).name);
    figure; hold on; title([fileName{1} fileName{3:4}]);

    fprintf('\nAnalyzing %s %s:\t\n', group, video);
    finalTracks = processPatchRefeed(finalTracks, edge, lawn);
    if ~isempty(finalTracks) && length(fields(finalTracks))>0
       finalTracks = rmfield(finalTracks, clean);
        if (isfield(allFinalTracks,group))
           oldFinalTracks = allFinalTracks.(group);
           allFinalTracks.(group) = [oldFinalTracks finalTracks];
        else
           allFinalTracks.(group) = finalTracks;
        end
    end
    cd ..
end

strains = fields(allFinalTracks);
N2s = contains(strains,'N2');
strainOrder = [{strains{N2s}} {strains{~N2s}}];
allFinalTracks = orderfields(allFinalTracks, strainOrder);

num = 1;

names = unique({allFinalTracks.(strains{1}).Name});
name = split(names{1}, '\');
name = split(name(end), '_');
name = name{1};

while exist(sprintf('uncheckedTracks_%s_%i.mat', name, num), 'file')
    num = num + 1;
end

% eval(sprintf('tracks_%s = allFinalTracks', name))
tracks = allFinalTracks; %#ok
% eval(sprintf('save(''uncheckedTracks_%s_%i.mat'', ''tracks'')', name, num, name));
goodname = strcat('uncheckedTracks_', date);
save(goodname, 'tracks')

return

end

function strains = getStrains(list)
    list = {list.name};
    strains = unique(cellfun(@(a) {a{3}}, cellfun(@(b) {split(b,'_')}, list)));

return
end
