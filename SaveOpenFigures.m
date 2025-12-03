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

    OpenFigures = findall(0, "Type", "figure");
    for FigIndex = 1:numel(OpenFigures)
        Fig = OpenFigures(FigIndex);

        FigData = gcf;
        ax = findobj(FigData, "Type", "axes");
        FigTitle = ax(1).Title.String;
        if isempty(FigTitle)
            FigTitle = sprintf('Figure%d', Fig.Number);
        end

        savefig(Fig, fullfile(DestinationFolder, FigTitle + ".fig"));
        exportgraphics(Fig, fullfile(DestinationFolder, FigTitle + ".jpg"));
    end

    fprintf('\nAll figures saved as .fig and .jpg\n')

end