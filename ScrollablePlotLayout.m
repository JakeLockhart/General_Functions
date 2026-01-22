function SelectedPlots = ScrollablePlotLayout()
    % <Documentation>
        % ScrollablePlotLayout()
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

    end

    %% Properties

    %% Run Main
        [Window, MainLayout] = DefineWindowLayout;
        PlotPanel = DefinePlotPanel(MainLayout);
        ControlPanel = DefineControlPanel(MainLayout);


    %% Define User Interface Layout
    function [Window, MainLayout] = DefineWindowLayout
        Window = uifigure("Name", "Select plots...", "Scrollable", "on");
        MainLayout = uigridlayout(Window, [2,1]);
        MainLayout.RowHeight = {'1x', 50};
        MainLayout.ColumnWidth = {'1x'};
    end

    %% Plot Display Panels
    function PlotPanel = DefinePlotPanel(MainLayout)
        PlotPanel = uipanel(MainLayout);
        PlotPanel.Layout.Row = 1;
    end

    %% Control Panel
    function ControlPanel = DefineControlPanel(MainLayout)
        ControlPanel = uipanel(MainLayout);
        ControlPanel.Layout.Row = 2;
        ControlPanel_Grid = uigridlayout(ControlPanel, [1,3]);
        ControlPanel_Grid.ColumnWidth = {'1x', '1x'};

        ResetButton = uibutton(ControlPanel_Grid, ...
                               "Text", "Reset" ...
                              );
        ResetButton.Layout.Row = 1;
        ResetButton.Layout.Column = 1;
                              
        DoneButton = uibutton(ControlPanel_Grid, ...
                              "Text", "Done" ...
                             );
        DoneButton.Layout.Row = 1;
        DoneButton.Layout.Column = 2;
    end

end