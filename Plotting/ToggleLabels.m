function ToggleLabels(scatterObject, x, y, labels)
    % <Documentation>
        % ToggleLabels()
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
        scatterObject (1,1) matlab.graphics.chart.primitive.scatter
        x double {mustBeVector}
        y double {mustBeVector}
        labels string {mustBeVector}
    end

    % Scatter plot metadata
    scatterObject.UserData.X = x;
    scatterObject.UserData.Y = y;
    scatterObject.UserData.Labels = labels;
    scatterObject.UserData.TextHandles = gobjects(length(x), 1);

    % Predefine points to be black
    scatterObject.CData = repmat([0,0,0], length(x), 1);

    scatterObject.PickableParts = "all";
    scatterObject.ButtonDownFcn = @togglePoint;

end

function togglePoint(src, event)

    clickPoint = event.IntersectionPoint(1:2);

    X = src.UserData.X;
    Y = src.UserData.Y;
    Labels = src.UserData.Labels;
    C = src.CData;
    T = src.UserData.TextHandles;

    % Use log distance if axes are log-scaled
    ax = ancestor(src, 'axes');
    if strcmp(ax.XScale, "log")
        dx = log10(X) - log10(clickPoint(1));
    else
        dx = X - clickPoint(1);
    end

    if strcmp(ax.YScale, "log")
        dy = log10(Y) - log10(clickPoint(2));
    else
        dy = Y - clickPoint(2);
    end

    [~, idx] = min(dx.^2 + dy.^2);

    if all(C(idx,:) == [0 0 0])
        % Turn red + add label
        C(idx,:) = [1 0 0];

        T(idx) = text(X(idx), Y(idx), Labels(idx), ...
            'FontSize', 8, ...
            'HorizontalAlignment','left', ...
            'VerticalAlignment','bottom', ...
            'PickableParts','none');
    else
        % Turn black + remove label
        C(idx,:) = [0 0 0];

        if isvalid(T(idx))
            delete(T(idx));
        end
        T(idx) = gobjects(1);
    end

    src.CData = C;
    src.UserData.TextHandles = T;

end