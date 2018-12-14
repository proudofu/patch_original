function patchPlot(date, strainList)

    plotTracks = load(sprintf('G:/behavior/%s/allTracks_%s', date, date));
    plotTracks_cell = struct2cell(plotTracks);
    plotTracks = plotTracks_cell(1); % Loading in the struct adds a layer to the already nested struct. This compensates by "going one layer further in".
    if nargin < 2
        strainList = reshape(fields(plotTracks{1}), [1 length(fields(plotTracks{1}))]);
    end

    vs = whos('plotTracks');
    vs = {vs(:).name};
    for b = 1:length(vs)
        eval(sprintf('allTracks{%i} = %s;', b, vs{b}));
    end
    allTracks = allTracks{1,1}; %#ok allTracks defined before this line during eval statement above
    
    showPooledEncounters(allTracks, strainList);
    
end

function showPooledEncounters(allTracks, combine, varargin)

    par = inputParser;
    addParameter(par, 'exclude', {});
    parse(par, varargin{:})

    if nargin > 2 && isempty(par.Results.exclude)
        normalTracks = normalizeSpeedsByN2(allTracks, combine, varargin{:});
    else
        normalTracks = normalizeSpeedsByN2(allTracks, combine);
    end

    if ~isempty(par.Results.exclude)
        excluded = par.Results.exclude;
        strains = fields(normalTracks);
        for s = 1:length(strains)
            include = arrayfun(@(x) ~contains(x.Name, excluded), normalTracks.(strains{s}));
            normalTracks.(strains{s}) = normalTracks.(strains{s})(include);
        end
    end

    showEncounters(normalTracks);

end
    



