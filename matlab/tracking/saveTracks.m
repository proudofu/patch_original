
function status = saveTracks(filename, Tracks)

status = 0;

varnamestring = inputname(2);

eval(sprintf('%s = Tracks;',varnamestring));

disp(sprintf('Saving %s\t%s',filename,timeString));
rm(filename);
save(filename, varnamestring,'-v7.3');
s = dir(filename);
if(s.bytes <= 2000)
    disp(sprintf('Failed to save %s\t%s',filename,timeString));
    return;
end

status = 1;

return;
end
