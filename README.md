# General Functions
MatLab functions which can be universally employed.

- **Zap**: Clear window and close all figures in .m file  
- **FileLookup**: Collect all files of type __ within a folder structure. Can select individual files or all files within a folder structure.
- **ReadOscope**: Reads the output waveform from a Tektronix TDS 2014C four channel digital oscilloscope (250MHz, 2GS/s). Works directly with FileLookup() function.
- **NestedTiles**: Function to create nested tiledlayouts() for .m files.
- **UserDefinedPeaks**: Creates a user interactive figure window to define the lower and upper bound of a pulse.
- **Custom Argument Functinos**: Folder containing custom matlab arguments.
  - **mustBeNonEmptyProperties**: Matlab argument to check that object contains user specified properties.
  - **mustHaveProperties**: MatLab argument to validate that object propoerties are non-empty.
- **FWHM_Demo**: Demonstration of Full-Width at Half-Maximum technique using random, synthetic noisy data.
- **TiRS_Demo**: Demonstration of Threholding in Radon Space technique using synthetic data to demonstrate boundary identification.
- **SaveOpenFigures**: Helper function to save all open figure windows as a user specified file type to a designated folder.
- **LoadTiff**: Helper function to load a .tiff file into the MatLab workspace.
- **TiledSlices**: Helper function to make nested tiledlayouts().