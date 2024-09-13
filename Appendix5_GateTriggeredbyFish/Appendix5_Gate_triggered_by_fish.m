% Matlab script | Appendix 5: Gate triggered by presence of fish in roi via Matlab
% A framework for a low-cost system of automated gate control in assays of spatial cognition in fishes
% 2024

%%% Remember to sign in to the local network created by the pi 
%%% web('http://192.168.50.5/index.php') calls webpage
clear all; close all
imaqreset
%% Custom acquisition parameters
framerate = 40; 
vid = videoinput('gentl', 1, 'Mono8'); 
set(vid.Source,'AllGain',5); 
set(vid.Source,'ExposureTime',24000); 
set(vid.Source,'AllBlackLevel',1); 
src = getselectedsource(vid);
set(src, 'AcquisitionFrameRateMode', 'Basic') 
set(src,'AcquisitionFrameRate',framerate);
vid.ROIPosition =  [180 200 801 646];  %custom video size setting
%File preparation
imaqmem(Inf);  
vid.FramesPerTrigger = Inf; 
triggerconfig(vid, 'manual');
vid.LoggingMode = 'disk';
vid.DiskLogger = VideoWriter('AutoGate', 'Motion JPEG AVI') 
vid.ReturnedColorspace = 'grayscale';  
videodata=[];
 
%% Starts recording when fish is in ROI1, opens gate after randomly
%% chosen waiting time, closes the gate and stops recording when fish is in ROI2
 
roi_entrance_1 = [300 300 100 30]; %defines roi that triggers gate opening
roi1_x = roi_entrance_1(2):roi_entrance_2(2)+roi_entrance_2(4);
roi1_y = roi_entrance_1(1):roi_entrance_2(1)+roi_entrance_2(3);
roi_entrance_2 = [500 300 100 30]; %defines roi that triggers gate closing
roi2_x = roi_entrance_2(2):roi_entrance_2(2)+roi_entrance_2(4);
roi2_y = roi_entrance_2(1):roi_entrance_2(1)+roi_entrance_2(3);

pause_times    = [5, 8, 10, 12, 15]   %defines waiting times before gate opens - script picks random value later
 
state = 0;
while state == 0;
    IM = getsnapshot(vid); 
    imshow(IM)
    hold on 
    rectangle('Position', roi_entrance_1)
    
    %cut snapshot to ROI1
    ROI_1 = IM(roi1_x, roi1_y);
    
    
      if min(ROI_1(:))<= 30 == 1; %if fish(dark pixels)is detected in ROI1
                rectangle('Position', roi_entrance_1 , 'EdgeColor', 'ma') %visual trigger indication
                state = 1;
                start(vid)   %start video
                trigger(vid)
                rand_pause=randsample(pause_times, 1); %random pick of pause_times
                disp(['ROI triggered | Gate opening in ', num2str(rand_pause) , ' sec'])
                pause(rand_pause)
                disp('Opening Gate | Starting to record')
                web('http://192.168.50.5/index.php?entrance_open=Open+Gate'); % web adress of the 'clicked' Open Gate button, start of motor script                  
                pause(2)
      else
      end
end
 
state = 0; 
 
while state == 0; 
    IM = getsnapshot(vid);
    imshow(IM)
    hold on 
    rectangle('Position', roi_entrance_2)
    
    %cut snapshot to ROI2
    ROI_2 = IM(roi2_x, roi2_y);
    
      if min(ROI_2) <= 30==1  %if fish(dark pixels)is detected in ROI2
            rectangle('Position', roi_entrance_2 , 'EdgeColor', 'ma') %visual trigger indication
            state = 1;
                disp('Closing Gate')         
                web('http://192.168.50.5/index.php?entrance_close=Close+Gate');  % web adress of the 'clicked' Close Gate button, start of motor script  
                pause(2)
      else
      end
end
 
state = 0;
pause(2)
stop(vid) %stop acquisition
