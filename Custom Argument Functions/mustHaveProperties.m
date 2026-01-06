function mustHaveProperties(Object, RequiredProperties)
    % <Documentation>
        % mustHaveProperties()
        %   MatLab custom argument to validate an object contains desired properties
        %   Created by: jsl5865
        %   
        % Syntax:
        %   mustHaveProperties(Object, RequiredProperties)
        %   
        % Description:
        %   Custom MatLab agrument to check if an object contains user required properties. This does 
        %       check hidden/protected properties by accessing the object's metadata.
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
        RequiredProperties (:,1) string
    end

    if ~isobject(Object)
        error('Input is not an object')
    end

    ObjectInfo = metaclass(Object);
    ObjectProperties = string({ObjectInfo.PropertyList.Name});

    MissingProperties = setdiff(RequiredProperties, ObjectProperties);
    if ~isempty(MissingProperties)
        ClassName = class(Object);
        Identifier = ClassName + ":MissingProperty";

        ME = MException(Identifier, 'Missing object property: %s', strjoin(MissingProperties, ", "));
        throwAsCaller(ME);
    end
end