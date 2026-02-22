function ThresholdInRadonSpace(DemoShape)
    % <Documentation>
        % ThresholdInRadonSpace()
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
        DemoShape char {mustBeMember(DemoShape, {'Circle', 'Square' 'Phantom', 'PenetratingArtery', 'PenetratingVein'})}
    end
    %% Synthetic Noisy Data
        Demo = zeros(512, 512, "double");
        Padding = 25;
        Amplitude = 0.01;
        Frequency = 3;
        WallThickness = 5;

        ImageSize = size(Demo, 1);
        [x,y] = meshgrid(1:size(Demo,2), 1:size(Demo,1));

        MinRadius = floor(ImageSize/8);
        MaxRadius = ceil(ImageSize/4);
        TrueRadius = randi([MinRadius, MaxRadius], 1);

        DemoPadding = TrueRadius + Padding;
        CenterRange = [DemoPadding, ImageSize - DemoPadding];
        TrueCenter = randi(CenterRange, [1,2]);

        dx = x - TrueCenter(2);
        dy = y - TrueCenter(1);
        Theta = atan2(dy, dx);
        Rho = sqrt(dx.^2 + dy.^2);

        WaveMagnitude = Amplitude * TrueRadius;
        WaveFrequency = randi(Frequency);
        Phase = 2*pi*rand;
        WavyRadius = TrueRadius + WaveMagnitude * cos(WaveFrequency*Theta*Phase);

        WallThickness = randi(WallThickness);

        switch DemoShape
            case 'Circle'
                CircleMask = (x - TrueCenter(2)).^2 + (y - TrueCenter(1)).^2 <= TrueRadius^2;
                Demo(CircleMask) = 1;

            case 'Square'
                HalfWidth = TrueRadius / 2;
                SquareMask = abs(x - TrueCenter(2)) <= HalfWidth & abs(y - TrueCenter(1)) <= HalfWidth;
                Demo(SquareMask) = 1;
            
            case 'Phantom'
                Demo = phantom;
                
            case 'PenetratingArtery'
                ArteryMask = Rho <= WavyRadius;
                Demo(ArteryMask) = 1;

            case 'PenetratingVein'
                InnerRadius = WavyRadius - WallThickness;

                InteriorMask = (Rho <= InnerRadius);
                WallMask = (Rho > InnerRadius) & (Rho <= WavyRadius);

                Demo(InteriorMask) = 0.8;
                Demo(WallMask) = 1.0;

        end

        Demo = Demo + 0.1*randn(size(Demo));            % Add random noise to the entire image (salt and pepper noise)
        Demo = min(max(Demo, 0), 1);                    % Lock all pixel intensities between 0 and 1
        Demo = imnoise(Demo, "gaussian", 0, 0.005);     % Add gaussian noise to the entire image

    %% Processing
        [Mask, ReconstructedImage, RadonSpaceImage] = CalculateTiRS(Demo);

        stats = regionprops(Mask, 'ConvexHull', 'Centroid', 'Area', 'MajorAxisLength');
        [~, TrueRegion] = max([stats.Area]);
        stats = stats(TrueRegion);

        TiRS_Radius = stats.MajorAxisLength/2;
        TiRS_Area = stats.Area;
        TiRS_Center = stats.Centroid;  % [x, y]
        Boundary = stats.ConvexHull;  % for the largest component

    %% Display
        figure
        Tiles = tiledlayout(2,3);
        title(Tiles, 'TiRS Demonstration')

        nexttile(1)
        axis off

        Text0 = sprintf('Demo Image: %s', DemoShape);

        Text1 = sprintf('True Center: [%.2f, %.2f]', TrueCenter(1), TrueCenter(2));
        Text2 = sprintf('True Radius: %.2f', TrueRadius);
        Text3 = sprintf('True Area: %.2f', pi*TrueRadius.^2);

        Text4 = sprintf('TiRS Center: [%.2f, %.2f]', TiRS_Center(2), TiRS_Center(1));
        Text5 = sprintf('TiRS Radius: %.2f', TiRS_Radius);
        Text6 = sprintf('TiRS Area: %.2f', TiRS_Area);

        AllText = sprintf('%s\n\n%s\n%s\n%s\n\n%s\n%s\n%s', ...
                        Text0, Text1, Text2, Text3, Text4, Text5, Text6);

        text(0.01, 0.95, AllText, ... 
            'HorizontalAlignment', 'left', ...
            'VerticalAlignment', 'top', ...
            'FontSize', 12, ...
            'Interpreter', 'none')
        
        nexttile(2)
        imshow(Demo)
        title('Demo Image')

        nexttile(3)
        imshow(Demo)
        hold on
        plot(Boundary(:,1), Boundary(:,2), 'r', 'LineWidth', 2);
        scatter(TiRS_Center(1), TiRS_Center(2), 25, 'r', 'filled')
        scatter(TrueCenter(2), TrueCenter(1), 50, 'blue','o')
        title('Processed')

        nexttile(4)
        imshow(RadonSpaceImage)
        title('Radon Space Image')
        ylabel('\rho')
        xlabel('\theta')
        nexttile(5)
        imshow(ReconstructedImage)
        title('Reconstructed Image from Radon Space')
        nexttile(6)
        imshow(Mask)
        title('Binary Mask of Reconstructed Image')
        


    %% Helper Functions
        function [Mask, ReconstructedImage, RadonSpaceImage] = CalculateTiRS(ROI)
            % <Documentation>
                % CalculateTiRS()
                %   Function created 12/27/2025
                %   Created by: jsl5865
            % <End Documentation>

            Resolution = 5;
            RadonThreshold = 0.35;
            InverseRadonThreshold = 0.2;
            ProjectionAngles = linspace(0,180, 180*Resolution);

            RadonSpaceImage = radon(ROI, ProjectionAngles);
            RadonSpaceImage = RadonSpaceImage - min(RadonSpaceImage, [], 1);
            RadonSpaceImage = RadonSpaceImage ./ max(RadonSpaceImage, [], 1);

            [~, PeakRhoIndex] = max(RadonSpaceImage, [], 1);
            ThresholdLogicMask = RadonSpaceImage >= RadonThreshold;

            [TotalRho, TotalAngles] = size(RadonSpaceImage);
            for Angle = 1:TotalAngles
                PeakRho = PeakRhoIndex(Angle);

                MinRho = PeakRho;
                while MinRho > 1 && ThresholdLogicMask(MinRho, Angle)
                    MinRho = MinRho - 1;
                end
                MinRho = MinRho + 1;

                MaxRho = PeakRho;
                while MaxRho < TotalRho && ThresholdLogicMask(MaxRho, Angle)
                    MaxRho = MaxRho + 1;
                end
                MaxRho = MaxRho - 1;

                ThresholdLogicMask(:, Angle) = false;
                ThresholdLogicMask(MinRho:MaxRho, Angle) = true;        
            end

            ThresholdedRadonSpaceImage = RadonSpaceImage .* ThresholdLogicMask;
            ReconstructedImage = iradon(ThresholdedRadonSpaceImage, ProjectionAngles, 'linear', 'Hamming', size(ROI, 1));
            ReconstructedImage = ReconstructedImage ./ max(ReconstructedImage(:));
            Mask = ReconstructedImage >= InverseRadonThreshold;
        end

end