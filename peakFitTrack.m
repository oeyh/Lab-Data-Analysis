% Script to read spectrum data, fit and track peak
% Hai Yan
% For 20160610 bio
% 6/29/2016

% For each set of scan (data in a singl foler),
% fit and track peak, store time and peak value in
% a matrix and save in a csv file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For all folders
%     for all mat files
%         read spectrum data
%         fit and find peak
%         read time data
%         record time and peak data
% save peak track data to file and plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

% List folers
folder = 'Binding test\2AlignwRingTB\Assay';
% folder = 'Probe flow';
folderList = dir(folder);

% Fitting parameters
res = 1530;
sWidth = 3;
fWidth = 0.5;   % 0.5 for resonance around 1540nm

% preallocation
fullresult = zeros(0,2);
cnt = 0;    % target folder count

for i = 1:length(folderList)
    % if it is a target data folder
    % target folders contain '@' in folder name
    
    if ~isempty(strfind(folderList(i).name,'@')) && ...
            folderList(i).isdir == true
        
        cnt = cnt + 1;
        
%         % preallocation
        time = zeros(1,1);
        peak = zeros(1,1);
        % peakFit = zeros(100,1);
        
        % process mat files
        disp(folderList(i).name)
        j = 1;
        subfolder = folderList(i).name;
        while true
            % construt file name and see end has come
            filename = strcat('Scan',num2str(j),'.mat');
            fullPath = fullfile(folder,subfolder,filename);
            if ~exist(fullPath,'file')
                disp('end of folder')
                break
            end
            
            % read data, find peak
            [spectrumData, t] = readmat(fullPath);
%             peak(j,1) = peakfit(spectrumData, res, sWidth, true, fWidth);
            peak(j,1) = peakfit(spectrumData, res, sWidth, false);
            % update peak position
            res = peak(j,1);
            
            % parse time
            if j == 1 && cnt == 1
                time(j,1) = 0;
                startT = t;
            else
                currT = t;
                time(j,1) = difftime(currT, startT);
            end
            
%             if time(j,1) == 0
%                 disp('time = 0');
%             end
            
            j = j + 1;            
            
            
        end
        disp(peak(j-1,1))
        result = [time peak];
        fullresult = vertcat(fullresult, result);
        
        % save file to each subfolder
%         result = [time peak];
%         csvName = 'peakFitTrack.csv';
%         csvPath = fullfile(folder,subfolder,csvName);
%         dlmwrite(csvPath,result,'precision',10);
    end
end

csvName = 'peakTrackFit-1530nm.csv';
dlmwrite(csvName,fullresult,'precision',10);





