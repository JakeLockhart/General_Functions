function mustBeFileOrEmpty(Path)
    % <Documentation>
        % mustBeFileOrEmpty()
        %   MatLab custom argument validator that ensures the input path is either an empty string or an existing file
        %   Created by: jsl5865
        %   
        % Syntax:
        %   mustBeFileOrEmpty(Path)
        %   
        % Description:
        %   This functino is intended to be used within an arguments block to validate function inputs. 
        %       If Path is a non-empty string, it must correspond to an existing file.
        %   
        % Input:
        %   Path    -  A (1x1) string scalar representing a folder path or an empty string ("")
        %   
        % Output:
        %   Boolian; agrument is true and function continues or error occurs
        %   
    % <End Documentation>
    arguments
        Path (1,1) string
    end

    if Path == "" || isfile(Path)
        return
    end

    Identifier = "InvalidPath:NotFileOrEmpty"
    ME = MException(Identifier, 'Path (%s) is not a file or empty string.', Path);
    throwAsCaller(ME)
end