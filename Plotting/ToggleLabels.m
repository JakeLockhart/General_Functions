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
        scatterObject (1,1) matlab.graphics.chart.primitive.Scatter
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

    ax = ancestor(src, "axes");
    dx = scaledDifference(X, clickPoint(1), ax.XScale);
    dy = scaledDifference(Y, clickPoint(2), ax.YScale);

    [~, index] = min(dx.^2 + dy.^2);

    if all(C(index,:) == [0 0 0])
        C(index,:) = [1 0 0];
        T(index) = text(X(index), Y(index), Labels(index), ...
                        "FontSize", 8, ...
                        "HorizontalAlignment", "center", ...
                        "VerticalAlignment", "bottom", ...
                        "PickableParts", "none");
    else
        C(index,:) = [0 0 0];
        if isvalid(T(index))
            delete(T(index));
        end
        T(index) = gobjects(1);
    end

    src.CData = C;
    src.UserData.TextHandles = T;

    function distance = scaledDifference(truePosition, selectPosition, axisScale)
        if strcmp(axisScale, "log")
            distance = log10(truePosition) - log10(selectPosition);
        else
            distance = truePosition - selectPosition;
        end
    end

end