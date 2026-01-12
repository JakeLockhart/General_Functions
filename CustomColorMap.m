function ColorMap = CustomColorMap(n, Style, Resolution)
    % <Documentation>
        % CustomColorMap()
        %   Create custom color maps for MatLab plots.
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ColorMap = CustomColorMap(n, Style, Resolution)
        %
        % Description:
        %   CustomColorMap generates a colormap with a specified number of discrete colors
        %       (n) sampled evenly from a MATLAB colormap of a given Style. The Resolution 
        %       parameter sets the internal resolution used to sample the colormap, allowing 
        %       for smooth interpolation when selecting fewer colors than the default colormap size.
        %   
        % Input:
        %   n           - Total color maps to be made
        %   Style       - MatLab color map styles supported by MatLab version R2024a or earlier.
        %   Resolution  - Internal resolution for the default color maps. Higher resolutions give
        %                   smoother sampling of the original MatLab colormaps.
        %   
        % Output:
        %   ColorMap    - MatLab RGB color map vector. Size of nx3.
        %   
    % <End Documentation>
    arguments
        n (1,1) double {mustBeNumeric, mustBeInteger, mustBePositive}
        Style (1,:) char {mustBeMember(Style, {'parula', 'turbo', 'hsv', 'hot', 'cool', 'spring', 'summer', 'autumn', 'winter', 'gray', 'bone', 'copper', 'pink', 'sky', 'abyss', 'jet', 'white'})} = 'jet'
        Resolution (1,1) double {mustBeNumeric, mustBeInteger, mustBePositive} = 256;
    end

    DefaultColorMap = feval(Style, Resolution);
    ColorGradient = round(linspace(1,Resolution, n));
    ColorMap = DefaultColorMap(ColorGradient, :);

end