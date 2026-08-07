function mustHaveFields(Struct, RequiredFields)
    % <Documentation>
        % mustHaveFields()
        %   MATLAB custom argument to validate a struct contains desired fields
        %   Created by: jsl5865
        %   
        % Syntax:
        %   mustHaveFields(Struct, RequiredFields)
        %
        % Description:
        %   Custom MATLAB argument to check if a struct contains user required fields.
        %
        % Input:
        %   Struct          - A MATLAB struct
        %   RequiredFields  - A string array of desired fields the struct must contain
        %
        % Output:
        %   Boolian; argument is true and function continues or error occurs
        %   
    % <End Documentation>
    arguments
        Struct (1,1) struct
        RequiredFields string {mustBeVector}
    end

    structFields = fieldnames(Struct);
    missingFields = setdiff(RequiredFields, structFields);

    if ~isempty(missingFields)
        identifier = "struct:MissingField";
        me = MException(identifier, 'Missing structure fields: %s', strjoin(missingFields, ", "));
        throwAsCaller(me)
    end
end