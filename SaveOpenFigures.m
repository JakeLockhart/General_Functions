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

        FigData = findobj(Fig, "Type", "axes");
        if isempty(FigData)
            FigTitle = sprintf('Figure%d', Fig.Number);
        else
            AxesTitle = string(FigData(1).Title.String);
            switch AxesTitle
                case ""
                    FigTitle = sprintf('Figure%d', Fig.Number);
                otherwise
                    FigTitle = AxesTitle;
            end
        end

        savefig(Fig, fullfile(DestinationFolder, FigTitle + ".fig"));
        exportgraphics(Fig, fullfile(DestinationFolder, FigTitle + ".jpg"));
    end

    fprintf('All figures saved as .fig and .jpg\n')

end