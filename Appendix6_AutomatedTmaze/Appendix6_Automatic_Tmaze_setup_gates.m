% Matlab script | Appendix 6: Automated T-maze gates
% A framework for a low-cost system of automated gate control in assays of spatial cognition in fishes
% 2024
clear all; close all
imaqreset

%% Custom video settings 
vid = videoinput('gentl', 1);
src = getselectedsource(vid);
set(vid,'LoggingMode','disk');
set(src, 'AcquisitionFrameRate', 30)
set(src, 'AcquisitionFrameRateEnable', 'true')
set(src, 'BinningVertical', 30)
set(src, 'BinningHorizontal', 30)
set(vid,'ReturnedColorSpace','grayscale');
vid.FramesPerTrigger = Inf; %trigger settings
triggerconfig(vid, 'manual');
vid.LoggingMode = 'disk'
vid.DiskLogger = VideoWriter('AutoGate', 'Motion JPEG AVI') 
%vid.ROIPosition = [0 212 1138 333]; %enable to set video roi

%% Define two regions of interests per gate - one for opening and one for closing of each gate
roi_entrance_1 = [262 680 680 50];  % [x y w h]
    roi1_x = roi_entrance_1(2):roi_entrance_1(2)+roi_entrance_1(4);
    roi1_y = roi_entrance_1(1):roi_entrance_1(1)+roi_entrance_1(3);
roi_entrance_2 = [262 580 680 50];
    roi2_x = roi_entrance_2(2):roi_entrance_2(2)+roi_entrance_2(4);
    roi2_y = roi_entrance_2(1):roi_entrance_2(1)+roi_entrance_2(3);
roi_decision_1_1 = [400 150 100 100];
    roid1_1x = roi_decision_1_1(2):roi_decision_1_1(2)+roi_decision_1_1(4);
    roid1_1y = roi_decision_1_1(1):roi_decision_1_1(1)+roi_decision_1_1(3):
roi_decision_2_1 = [650 150 100 100];
    roid2_1x = roi_decision_2_1(2):(roi_decision_2_1(2)+roi_decision_2_1(4);
    roid2_1y = roi_decision_2_1(1):(roi_decision_2_1(1)+roi_decision_2_1(3);
roi_decision_1_2 = [250 150 100 100];
    roid1_2x = roi_decision_1_2(2):(roi_decision_1_2(2)+roi_decision_1_2(4);
    roid1_2y = roi_decision_1_2(1):(roi_decision_1_2(1)+roi_decision_1_2(3);
roi_decision_2_2 = [800 150 100 100];
    roid2_2x = roi_decision_2_2(2):(roi_decision_2_2(2)+roi_decision_2_2(4);
    roid2_2y = roi_decision_2_2(1):(roi_decision_2_2(1)+roi_decision_2_2(3);

% IM = getsnapshot(vid);   %enable to see location of rois (green: opening, red: closing) 
% imshow(IM)
% rectangle('Position', roi_entrance_1 , 'EdgeColor', 'g')
% rectangle('Position', roi_entrance_2 , 'EdgeColor', 'r')
% rectangle('Position', roi_decision_1_1 , 'EdgeColor', 'g')
% rectangle('Position', roi_decision_1_2 , 'EdgeColor', 'r')
% rectangle('Position', roi_decision_2_1 , 'EdgeColor', 'g')
% rectangle('Position', roi_decision_2_2 , 'EdgeColor', 'r')
% pause 
% close all

% opening of entrance gates 
state = 0;  %the state is changed on roi trigger
while state == 0;
    IM = getsnapshot(vid); %fetch frame
    imshow(IM)    %disable visualization to accelerate script
    hold on       %disable visualization to accelerate script
    rectangle('Position', roi_entrance_1) %disable visualization to accelerate script
    
     % cut fetched frame to roi dimensions
     ROI_1 = IM(roi1_x, roi1_y);

      if min(ROI_1(:))<= 30==1; %detects fish by dark pixel
            rectangle('Position', roi_entrance_1 , 'EdgeColor', 'g') %roi turns green when triggered; disable visualization to accelerate script
            state = 1;
            disp('Opening Gate | Starting to record') 
            start(vid)   %starts video acquisition 
            trigger(vid)
            web('http://192.168.50.5/index.php?entrance_open=Open+Entrance+Gate') %triggers gate opening on pi 
                      %when in hotspot
            %web('http://192.168.0.57/index.php?entrance_open=Open+Entrance+Gate')
                      %f.ex. when in home wifi
            pause(3)
      else
      end
end

state = 0; %the state is changed on roi trigger

% closing of entrance gates 
while state == 0;
    IM = getsnapshot(vid); %fetch frame
    imshow(IM) %disable visualization to accelerate script
    hold on    %disable visualization to accelerate script
    rectangle('Position', roi_entrance_2) %disable visualization to accelerate script
    
     % cut fetched frame to roi dimensions
     ROI_2 = IM(roi2_x, roi2_y);
     
      if min(ROI_2(:)) <= 30 ==1  %detects fish by dark pixel
            rectangle('Position', roi_entrance_2 , 'EdgeColor', 'g') %roi turns green when triggered; disable visualization to accelerate script
            state = 1;
            disp('Closing Gate')         
            web('http://192.168.50.5/index.php?entrance_close=Close+Entrance+Gate')
                %when hotspot
%           web('http://192.168.0.57/index.php?entrance_close=Close+Entrance+Gate')
                %f.ex. when in home network               
             pause(3)
      else
      end
end
 
% opening of decision gates 
state = 0; %the state is changed on roi trigger
%decision gates should move simultaneously if fish triggers one of two
%decision rois 
while state == 0;
    IM = getsnapshot(vid); %fetch frame
    imshow(IM) %disable visualization to accelerate script
    hold on    %disable visualization to accelerate script
    rectangle('Position', roi_decision_1_1) %disable visualization to accelerate script
    rectangle('Position', roi_decision_2_1) %disable visualization to accelerate script
   
    %cut frame to both decision rois' dimensions 
    roi_decision_1 = [IM(roid1_1x, roid1_1y), IM(roid2_1x, roid2_1y)];
 
    if min(roi_decision_1(:)) <= 30==1;  %detects fish by dark pixel       
            rectangle('Position', roi_decision_1_1 , 'EdgeColor', 'g') %disable visualization to accelerate script
            rectangle('Position', roi_decision_2_1 , 'EdgeColor', 'g') %disable visualization to accelerate script
            state = 1;
            disp('Opening Decision Gate')         
            web('http://192.168.50.5/index.php?decision_open=Open+Decision+Gates')
                %when hotspot
            %web('http://192.168.0.57/index.php?decision_open=Open+Decision+Gates')
                %f.ex. when in home network               
            pause(3)
     else
     end
end

% closing of decision gates 
state=0; %the state is changed on roi trigger
while state == 0; 
    IM = getsnapshot(vid); %fetch frame
    imshow(IM) %disable visualization to accelerate script
    hold on    %disable visualization to accelerate script
    rectangle('Position', roi_decision_1_2) %disable visualization to accelerate script
    rectangle('Position', roi_decision_2_2) %disable visualization to accelerate script
    
    %cut frame to both decision rois' dimensions 
    roi_decision_2 = [IM(roid1_2x, roid1_2y), IM(roid2_2x, roid2_2y)];

    if min(roi_decision_2(:)) <= 30 ==1;  %detects fish by dark pixel
            rectangle('Position', roi_decision_1_2 , 'EdgeColor', 'g') %disable visualization to accelerate script
            rectangle('Position', roi_decision_2_2 , 'EdgeColor', 'g') %disable visualization to accelerate script
            state = 1;            
            disp('Closing Decision Gate')
            web('http://192.168.50.5/index.php?decision_close=Close+Decision+Gates')
                %when hotspot
%           web('http://192.168.0.57/index.php?decision_close=Close+Decision+Gates')
                %f.ex. when in home network                
      else
      end
end

pause(2)
stop(vid) %stop video acquisition when trial is completed 
