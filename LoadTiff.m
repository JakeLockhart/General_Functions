function ImageStack = LoadTiff(Tiff_Directory)
    % <Documentation>
        % LoadTiff()
        %   Load multi-page .tif files and save into a 3D image stack (Rows, Columns, Frames)
        %   Created by: jsl5865
        %   
        % Syntax:
        %   ImageStack = LoadTiff(Tiff_Directory)
        %
        % Description:
        %   This function reads all pages of a multi-page .tif file. This function can be called
        %       with a known file directory as the input or can be called without an input. In 
        %       the case of no input, a file selection window will open for the user to choose
        %       the .tif file to be loaded.
        %   
        % Input:
        %   Tiff_Directory - String or character entry. This is the full path directory to the 
        %                    .tif file.    
        % Output:
        %   ImageStack - 3D numeric array containing the pixel intensity values for the loaded
        %                .tif file. Saved as a 3D vector: Rows, Columns, Frames.
        %   
    % <End Documentation>
    
    arguments
        Tiff_Directory {mustBeTextScalar}
    end

    if nargin == 0
        File = FileLookup("tif","SingleFile");
        Tiff = File.Path;
    else
        Tiff = Tiff_Directory;        
    end

    TiffInfo = imfinfo(Tiff);
    Frames = numel(TiffInfo);
    Rows = TiffInfo(1).Height;
    Columns = TiffInfo(1).Width;

    ImageStack = zeros(Rows, Columns, Frames, "like", imread(Tiff, 1));
    for i = 1:Frames
        ImageStack(:,:,i) = imread(Tiff, i);
    end

end
