% Matlab script | Appendix 4: Remote motor control of setup gates
% Approaches for automated setup gates in fish spatial behavioural experiments using the RaspberryPi
% 2024

%%% Remember to sign in to the hotspot created by the pi 

close all
clear all
imaqreset

%% File preparation
prompt = {'FishID', 'Date', 'Session', 'Trial'};
dlg_title= 'File Preparation';
num_line = 1;
def = {'xx', '2024_04_26', '1', '1'}
answer = inputdlg(prompt, dlg_title, num_line, def);
%prepare data saving
filename=['ID_', answer{1}, '_', answer{2}, '_S_', answer{3}, '_', ...
    answer{4}, '_', answer{5}, '_', answer{6}, '.avi'];
writerObj = VideoWriter(num2str(filename));

%% Custom acquisition parameters
vid = videoinput('gentl', 1,'Mono8');
pause(5)
vid.ROIPosition = [147 485 981 419]; %video roi
src= getselectedsource(vid);
src.AcquisitionFrameRate= 30;
src.ExposureTime=24000;
src.AllGain = 12;
pause(2)

%% Call website to access gate control
web('http://192.168.50.5/')
pause(2)

%% Live video and Video acquisition
preview(vid) %show live video

%start video acquisition
b = menu('Start', 'Ok')
if b ==1;
    start(vid)
else 
end

%start video acquisition
a = menu('Stop', 'Ok')
if a==1;
    stop(vid)
    close(vid.DiskLogger);
    delete(vid)
    clear vid;
else 
end



