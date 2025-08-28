function FWHM_Demo
    % <Documentation>
        % FWHM_Demo()
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

    %% Synthetic Noisy Data
        Demo = zeros(256,256, "double");                            % Create a black image that is of type 'double' in order to add noise later (0 = black, no pixel intensity)

        LineThickness = randi(size(Demo, 1)/4, 1);                  % Randomly assign a line thickness 
        YPosition.Center = size(Demo, 1) / 2;                       % Center the line along the rows 
        YPosition.Top = ceil(YPosition.Center - LineThickness/2);     % Determine the top row (first) that the line appears
        YPosition.Bottom = floor(YPosition.Center + LineThickness/2); % Determine the bottom row (last) that the line appears
        Demo(YPosition.Top:YPosition.Bottom, :) = 1;                % Give all rows between the top/bottom rows of the line an intensity (1 = fully bright, max pixel intensity)

        Demo = Demo + 0.1*randn(size(Demo));                        % Add random noise to the entire image (salt and pepper noise)
        Demo = min(max(Demo, 0), 1);                                % Lock all pixel intensities between 0 and 1
        Demo = imnoise(Demo, "gaussian", 0, 0.005);                 % Add gaussian noise to the entire image

    %% Create Figure
        figure;             % Create a figure window to contain all plots
        tiledlayout(1,2);   % Create a tiledlayout (1 row, 2 columns) for two panels. One to show synthetic data, one to show intensity profile

        Tile1 = nexttile;                                                                   % Define first tile
        imshow(Demo, [], 'Parent', Tile1);                                                  % Display the synthetic data
        title(Tile1, sprintf('Demo image - Draw ROI\n(%g Pixel Width)', LineThickness));    % Give a title to tile that contains true line thickness

        Tile2 = nexttile;                                                                           % Define second tile
        hold on;                                                                                    % Hold all plotted components on tile
        ROIProfilePlot = plot(Tile2, NaN, NaN, '-b');                                               % Plot the improfile (initially does not exist)
        IntensityMidLine = yline(Tile2, NaN, '--r', 'FWHM', 'LabelHorizontalAlignment', 'left');    % Plot the midline of the intensity (initially does not exist)
        Edge1Line = xline(Tile2, NaN, '--k');                                                       % Plot the top edge of the detected line, intercepts with intensity profile (initially does not exist)
        Edge2Line = xline(Tile2, NaN, '--k');                                                       % Plot the bottom edge of the detected line, intercepts with intensity profile (initially does not exist)

        title(Tile2, 'ROI Profile Intensity');  % Give a title to the ROI profile intensity
        xlabel(Tile2, 'Line Index (Pixels)');   % Define x axis as the length of the ROI
        ylabel(Tile2, 'Mean Intensity');        % Define y axis as the pixel intensity on the ROI

    %% Draw ROI & Control Line Thickness
        ROI = drawline(Tile1);
        ROI.LineWidth = 2;
        UpdateProfile() % Update figures during event

        Step = 0.5;
        Window = ancestor(Tile1,'figure');
        Window.WindowScrollWheelFcn = @(~,event) AdjustLineWidth(event, ROI);
        function AdjustLineWidth(event, ROI)
            if isvalid(ROI) && isprop(ROI,'LineWidth')
                AdjustedWidth = ROI.LineWidth + Step * -sign(event.VerticalScrollCount);
                ROI.LineWidth = max(0.5, min(AdjustedWidth, 10));
                UpdateProfile();
            end
        end

    %% Plot Pixel Intensity along ROI Profile
        function UpdateProfile()
            x = ROI.Position(:,1);
            y = ROI.Position(:,2);

            ROI_HalfWidth = round(ROI.LineWidth);
            SamplesOnROI = 1000;

            ROIProfile = AdjustedImprofile(Demo, x, y, ROI_HalfWidth, SamplesOnROI);

            ROILength = linspace(0,1,length(ROIProfile)) * norm(diff(ROI.Position));

            [FWHM, Edge1, Edge2] = CalculateFWHM(ROILength, ROIProfile);

            set(ROIProfilePlot, 'XData', ROILength, 'YData', ROIProfile);
            set(IntensityMidLine, 'Label', sprintf('FWHM ≈ %.1f px', FWHM));
            set(IntensityMidLine, 'Value', 0.5 * (max(ROIProfile) + min(ROIProfile)));
            set(Edge1Line, 'Value', Edge1);
            set(Edge2Line, 'Value', Edge2);

            title(Tile1, sprintf('Demo image - Draw ROI\n(%g Pixel Width)', LineThickness));
            drawnow
        end
end

%% Helper Functions
function ROIProfile = AdjustedImprofile(Demo, x, y, ROI_HalfWidth, SamplesOnROI)
    [X, Y, ~] = improfile(Demo, x, y, SamplesOnROI);
    if isempty(X)
        ROIProfile = NaN(SamplesOnROI, 1);
        return
    end

    Theta = atan2(Y(end) - Y(1), X(end) - X(1));
    UnitVectorX = -sin(Theta);
    UnitVectorY = cos(Theta);

    Temp = zeros(length(X), 2*ROI_HalfWidth+1);
    for i = -ROI_HalfWidth:ROI_HalfWidth
        OffsetX = X + i * UnitVectorX;
        OffsetY = Y + i * UnitVectorY;
        Temp(:, i+ROI_HalfWidth+1) = interp2(double(Demo), OffsetX, OffsetY, "linear", 0); 
    end

    ROIProfile = mean(Temp, 2, 'omitnan');
end

function [FWHM, Edge1, Edge2] = CalculateFWHM(x, y)
    y = y - min(y);
    y = y / max(y);

    HalfMax = 0.5;

    UpperRegion = y >= HalfMax;
    idx = find(UpperRegion);
    if isempty(idx)
        FWHM = NaN;
        Edge1 = NaN;
        Edge2 = NaN;
        return
    end

    Edge1 = x(idx(1));
    Edge2 = x(idx(end));
    FWHM = Edge2 - Edge1;
end