function [data] = readAsciiData(fileName, headerLines)
    %READASCIIDATA Simple function to read an ASCII file into a table
    %   Similar to importdata.m::LocalTextRead()
    %
    %   Note that textscan(), as used in getBPMreadings,
    %   may be faster and safer; however this function mimics importdata().
    
    fid = fopen(fileName, 'r');
    %Scroll past the header lines...
    for i = 1:headerLines
        ret = fgetl(fid);
        if ret == -1
            error('Error in reading file "%s", reached End-Of-File while reading header at line %i / %i', fileName, i, headerLines);
        end
    end
    %data = zeros(1,102);
    
    data = [];
    
    i = 1;
    numCols = NaN;
    while true %Read forever until EOF is reached.
               %Assume that the user will hit ^C if it takes infinite time.
        
        dataLine = fgetl(fid);
        if dataLine == -1
            %EOF reached; we are done!
            break
        end
        if isempty(strtrim(dataLine))
            %Blank line, SKIP
            continue;
        end
        
        %For debugging
        %disp(dataLine)
        
        % Parse!
        dataLineNum = str2num(dataLine); %#ok<ST2NM>
        
        %Mimic importdata behaviour; if something unexpected happens,
        % we are effectively EOF so stop reading.
        if i > 1 
            if length(dataLineNum) ~= numCols
                break
            end
        end
        
        %Grow 'data' line by line;
        % yes it's slow but for this it doesn't matter
        if i == 1
            data = dataLineNum;
            numCols = length(dataLineNum);
        else
            data(i,:) = dataLineNum; %#ok<AGROW>
        end
        
        i = i+1;
    end
    fclose(fid);
    
end

