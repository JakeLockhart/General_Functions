function SaveOpenFigures(FileType)
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
        FileType cell {mustBeMember(FileType, {'fig', 'jpg', 'tif', 'gif', 'png', 'eps', 'svg'})} = {'fig'}
    end

    DestinationFolder = uigetdir(pwd, "Choose a folder to save all open figures...");
    if DestinationFolder == 0
        fprintf('\nNo destination folder selected\n')
        return
    end
    fprintf('Saving figures...\n')

    ChildFolders = cellfun(@(ext) CreateDirectory(ext, DestinationFolder), FileType, "UniformOutput", false);

    OpenFigures = findall(0, "Type", "figure");
    for FigIndex = 1:numel(OpenFigures)
        Fig = OpenFigures(FigIndex);
        FigureTitle = GetFigureTitle(Fig);
        for Child = 1:numel(FileType)
            ext = FileType{Child};
            ChildFolder = ChildFolders{Child};
            switch ext
                case "fig"
                    savefig(Fig, fullfile(ChildFolder, FigureTitle + "." + ext));
                otherwise
                    exportgraphics(Fig, fullfile(ChildFolder, FigureTitle + "." + ext));
            end
        end
    end

    fprintf('All figures saved as .fig and .jpg\n')

    function extFolder = CreateDirectory(ext, ParentFolder)
        Title = sprintf('MatLab Figures (.%s)', ext);
        extFolder = fullfile(ParentFolder, Title);
        if ~exist(extFolder, 'dir')
            mkdir(extFolder)
        end
    end

    function FigureTitle = GetFigureTitle(Fig)
        Tiles = findobj(Fig, "Type", "tiledlayout");
        if ~isempty(Tiles)
            TileAx = Tiles(1);
            if ~isempty(TileAx.Title) && ~isempty(TileAx.Title.String)
                FigureTitle = CleanFileName(string(TileAx.Title.String));
                return
            end
        end

        Axes = findobj(Fig, "Type", "axes");
        for ax = Axes'
            if ~isempty(ax.Title) && ~isempty(ax.Title.String)
                FigureTitle = CleanFileName(string(ax.Title.String));
                return
            end
        end

        FigureTitle = sprintf('Figure %d', Fig.Number);
    end

    function AppropriateFileName = CleanFileName(FigureName)
        AppropriateFileName = regexprep(FigureName, '[<>:"/\\|?*]', '_');
    end

end