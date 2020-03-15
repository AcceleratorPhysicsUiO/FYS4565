% EXTRACT BPM MISALIGNMENT SIGMAS and ACTUAL NUMBERS
function [ sigma_dx, sigma_dy, bpm_dxs, bpm_dys ] = getBpmMisalignments()

    % misalignments from parameters (standard devs)
    params = getParams();
    sigma_dx = params(8);
    sigma_dy = params(9);
    
    % declare misalignment file
    misalignmentFile = 'bpmMisalignments.tfs';
    % extract quadrupole misalignments in x and y
    headerLinesIn = 8;
    %misalignmentData = importdata(misalignmentFile, ' ', headerLinesIn);
    
    fid = fopen(misalignmentFile, 'r');
    for i = 1:headerLinesIn
        fgetl(fid);
    end
    data = zeros(1,102);
    for i = 1:100000 %Assumed max number of lines
        dataLine = fgetl(fid);
        if dataLine == -1
            break
        end
        data(i,:) = str2num(dataLine);
    end
    fclose(fid);
    
    % read out misalignments of BPMs (MREX, MREY: "monitor readout error)
    bpm_dxs = data(:, 43);
    bpm_dys = data(:, 44);
    
end


