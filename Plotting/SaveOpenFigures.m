function SaveopenFigures(fileType, destinationFolder)
    % <Documentation>
        % SaveAllFigures()
        %   
        %   Created by: jsl5865
        %   
        % Syntax:
        %   
        % Description:
        %   
        % Input:
        %   
        % Output:
        %   
    % <End Documentation>
    arguments
        fileType string {mustBeVector, mustBeMember(fileType, ["fig", "jpg", "tif", "gif", "png", "eps", "svg"])}
        destinationFolder (1,1) string {mustBeFolderOrEmpty} = ""
    end

    if destinationFolder == ""
        destinationFolder = uigetdir(pwd, "Choose a folder to save all open figures...");
        if destinationFolder == 0
            fprintf('\nNo destination folder selected\n')
            return
        end
    end
    fprintf('Saving figures...\n')

    childFolders = arrayfun(@(ext) CreateDirectory(ext, destinationFolder), fileType, "UniformOutput", false);

    openFigures = findall(0, "Type", "figure");
    existingTitles = strings(0, numel(openFigures));
    for figIndex = 1:numel(openFigures)
        Fig = openFigures(figIndex);

        figureTitle = GetfigureTitle(Fig);
        figureTitle = ValidateUniqueTitle(figureTitle, existingTitles);
        existingTitles(figIndex) = figureTitle;

        for child = 1:numel(fileType)
            ext = fileType(child);
            childFolder = childFolders{child};
            switch ext
                case "fig"
                    savefig(Fig, fullfile(childFolder, figureTitle + "." + ext));
                otherwise
                    exportgraphics(Fig, fullfile(childFolder, figureTitle + "." + ext));
            end
        end
    end


    fprintf('All figures saved as %s\n', strjoin(strcat('.', fileType), ', '))

    function extFolder = CreateDirectory(ext, ParentFolder)
        title = sprintf('MatLab Figures (.%s)', ext);
        extFolder = fullfile(ParentFolder, title);
        if ~exist(extFolder, 'dir')
            mkdir(extFolder)
        end
    end

    function figureTitle = GetfigureTitle(fig)
        Tiles = findobj(fig, "Type", "tiledlayout");
        if ~isempty(Tiles)
            tileAx = Tiles(1);
            if ~isempty(tileAx.Title) && ~isempty(tileAx.Title.String)
                figureTitle = CleanFileName(string(tileAx.Title.String));
                return
            end
        end

        axes = findobj(fig, "Type", "axes");
        for ax = axes'
            if ~isempty(ax.Title) && ~isempty(ax.Title.String)
                figureTitle = CleanFileName(string(ax.Title.String));
                return
            end
        end

        figureTitle = sprintf('Figure %d', fig.Number);
    end

    function uniqueTitle = ValidateUniqueTitle(baseTitle, existingTitles)
        uniqueTitle = baseTitle;
        count = 1;
        
        while any(existingTitles == uniqueTitle)
            uniqueTitle = sprintf('%s (%d)', baseTitle, count);
            count = count + 1;
        end
    end

    function appropriateFileName = CleanFileName(figureName)
        if isstring(figureName) || ischar(figureName)
            figureName = strjoin(string(figureName), '_');
        end
        appropriateFileName = regexprep(figureName, '[<>:"/\\|?*]', '_');
    end

end