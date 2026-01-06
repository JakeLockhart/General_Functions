function mustBeNonEmptyProperties(Object, PropertyList)
    % <Documentation>
        % mustBeNonEmptyProperty()
        %   Matlab custom argument to validate that object properties are non-empty
        %   Created by: jsl5865
        %   
        % Syntax:
        %   mustBeNonEmptyProperty(Object, PropertyList)
        %
        % Description:
        %   Custom matlab argument to check if the user required properties contain 
        %       values or are empty.
        %
        % Input:
        %   Object              - An object class with properties
        %   RequiredProperties  - A string array of desired properties the object must contain
        %   
        % Output:
        %   Boolian; agrument is true and function continues or error occurs
        %   
    % <End Documentation>
    arguments
        Object
        PropertyList (1,:) string {mustHaveProperties(Object, PropertyList)}
    end

    TotalProperties = numel(PropertyList);
    EmptyProperties = string.empty;

    for i = 1:TotalProperties
        Property = PropertyList(i);
        
        if isempty(Object.(Property))
            EmptyProperties(i) = Property;
        end
    end

    EmptyIndex = ismissing(EmptyProperties);
    EmptyProperties = EmptyProperties(EmptyIndex == 0);
    if ~isempty(EmptyProperties)
        ClassName = class(Object);
        Identifier = ClassName + ":EmptyProperty";
        
        ME = MException(Identifier, 'Empty object property: %s', strjoin(EmptyProperties, ', '));
        throwAsCaller(ME)
    end
end