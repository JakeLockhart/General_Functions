function SaveOpenFigures
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

    DestinationFolder = uigetdir(pwd, "Choose a folder to save all open figures...");
    if DestinationFolder == 0
        fprintf('\nNo destination folder selected\n')
        return
    end
    fprintf('Saving figures...\n')

    OpenFigures = findall(0, "Type", "figure");
    for FigIndex = 1:numel(OpenFigures)
        Fig = OpenFigures(FigIndex);
        FigureTitle = GetFiguretitle(Fig);
        savefig(Fig, fullfile(DestinationFolder, FigureTitle + ".fig"));
        exportgraphics(Fig, fullfile(DestinationFolder, FigureTitle + ".jpg"));
    end

    fprintf("All figures saved as .fig and .jpg\n")

    function FigureTitle = GetFiguretitle(Fig)
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