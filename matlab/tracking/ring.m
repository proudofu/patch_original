function NumFoundWorms = ring(PathName, moviefile, scaleRing, quick)

global Prefs;

Prefs.PID = randint(10000);

NumFoundWorms = NaN;

[pathstr, FilePrefix, ext] = fileparts(moviefile);

background = calculate_background(sprintf('%s.avi',PathName));

ringfile = sprintf('%s.%d.Ring.mat',PathName, Prefs.PID);
final_ringfile = sprintf('%s.Ring.mat',PathName);
if(does_this_file_need_making(final_ringfile))
    rm(ringfile);
    rm(final_ringfile);
    
    if(isempty(scaleRing))
        Ring = find_ring(background,sprintf('%s',PathName), sprintf('%s.%d',FilePrefix,Prefs.PID), 1);
    else
        if(strcmp(Prefs.Ringtype(1:6),'square'))
            Ring = find_ring(background,sprintf('%s',PathName), sprintf('%s.%d',FilePrefix,Prefs.PID), 1, quick);
        else
            Ring = scaleRing;
        end
        Ring.PixelSize = scaleRing.PixelSize;
        save(ringfile, 'Ring');
    end
    
    
    % successfully found ring, so calc default threshold for finding animals
    if(~does_this_file_need_making(ringfile) || ~isempty(scaleRing))
        if(isempty(Ring.DefaultThresh))
            [DefaultLevel, NumFoundWorms, mws, Ring] = patch_default_worm_threshold_level(sprintf('%s.avi',PathName), background, [], 0, Ring, 1);
            save(ringfile, 'Ring');
        end
    end
    
    mv(ringfile, final_ringfile);
else
    load(final_ringfile);
    NumFoundWorms = Ring.NumWorms;
end

clear('Ring');
clear('background');

return;
end
