function tryincrease_imgs_2(subjID, whichsoftware)
% function internalpercepts_debug(subjID, whichsoftware)
% subjID should be a string e.g. 'P101' % for convenience also add the TMS site with underscore - e.g. 'P101_LO'
% whichsoftware is a string that 'octave' or 'matlab'

try 
  %%%%%%%%%
  % A few lines you might need to edit in order to get underway
  %%%%%%%%%
  
  if whichsoftware == 'octave'
  rand('twister',sum(100*clock));% use this to reset the random number generator in Octave
  else
  rng('shuffle') % use this to reset the random number generator in Matlab
  end
  
  Screen('Preference', 'SkipSyncTests', 1); 						% set to 1 for debugging, 0 when doing real testing
  KbName('UnifyKeyNames');                                        % see help KbName for more details, basically tries to unify key codes across OS
  theKeyCodes = KbName({'a','s','d','f','UpArrow','DownArrow', 'space'});                                % get key codes for your keys that you want alternative
  
  if whichsoftware == 'octave'
  page_screen_output(0, 'local');								% use in Octave to stop less/more from catching text output to the workspace
  end
  
  %%%%%%%%%
  % This ugly block of code is about setting up the screens/windows, checking timing, etc.
  %%%%%%%%%
  ptbv = PsychtoolboxVersion;										% record the version of PTB that was being used
  scriptVersion = 1.3;											% record the version of this script that is running
  screens = Screen('Screens');									% how many screens do we have?
  screenNumber = max(screens);								% take the last one by default
  %screenRect = [100 100 1920 1080];            %% uncomment this and next line for small screen for debugging
  %[window, screenRect] = Screen('OpenWindow', 0, [127 127 127], screenRect);

  [window, screenRect] = Screen('OpenWindow', screenNumber, 0); 	% 0 == black background; also record the size of the screen in a Rect
  info = Screen('GetWindowInfo', window); 						% records some technical detail about screen and graphics card
  %[ifi, nvalid, stddev] = Screen('GetFlipInterval', window, ...	% ifi is the duration of one screen refresh in sec (inter-frame interval)
  %100, 0.01, 30);												% set up for very rigourous checking; results reported in next lines
  ifi = Screen('GetFlipInterval', window);

  fprintf('Refresh interval is %2.5f ms.', ifi*1000);
  %fprintf('samples = %i, std = %2.5f ms\n', nvalid, stddev*1000); % reports the results of the ifi measurements to the workspace
  HideCursor; 													% guess what
  ListenChar(2);                        % suppresses the output of key presses to the command window/editor; press Ctrl+C in event of a crash
  WaitSecs(1); 													% Give the display a moment to recover 
  
  ctrPoint = [screenRect(3)./2 screenRect(4)./2];					% the point at the middle of the screen
  %ctrRect = CenterRect([0 0 200 300], screenRect);				% a rectangle that puts our image at the center of the screen
  
  
  %% octave vs matlab directory
  if whichsoftware == 'octave'
  rootDir = 'C:/Users/uomom/Documents/internalsizepercept/'; % root directory for the experiment - Windows
  else
  rootDir = 'D:/Documents/Marco_Gandolfo/internalsizepercept/';		% root directory for the experiment in the lab - Windows
end


%% durations
 maskDur = 18;                                               % number of screen frames for the image
 fixDur = [45 60 90 105 120] - 0.5;	                          % no of screen frames for fixation randomdurations
 
 
  %% prepare texture for the response screen
  img = imread('01_flat_desert_furniture_gb.png');

  imgTexture = Screen('MakeTexture', window, img);
  
  scene = imread('01_flat_desert_full_furniture_2.jpg');
  sceneTexture = Screen('MakeTexture', window, scene);
  
  mask = imread('themask.jpg');
  
  maskTexture = Screen('MakeTexture', window, mask);
  
  %% get size of image
  [imageHeight, imageWidth, colorChannels] = size(img);
  
  %% define image rect
  imageRect = [0 0 imageWidth imageHeight];
  
  %% Center the rectangle
  destinationRect = CenterRect(imageRect, screenRect);
  



  cd(rootDir);													% change to the main experiment directory
  Screen('FillRect', window, 128);								% grey background
  Screen('TextColor', window, [0 0 0]);							% black text
  Screen('TextSize', window, 48);									% big font
  Screen('DrawText', window, 'Press a key when ready.', 20, 20);	% draw the ready signal offscreen
  vbl = Screen('Flip', window);									% flip it onscreen
  
  %% Present the scene
  Screen('DrawTexture', window, sceneTexture, [], destinationRect);
  Screen('Flip', window);
  
  WaitSecs(2);
  KbWait();
  
  %%Present the mask
  Screen('DrawTexture', window, maskTexture, [], destinationRect);
  Screen('Flip', window);
  
  WaitSecs(2)
  KbWait();

  %% present image  
  
  Screen('DrawTexture', window, imgTexture, [], destinationRect);
  Screen('Flip', window);
  
  WaitSecs(2)
  KbWait();
  
  %% restart
  
   %% Present the scene
  Screen('DrawTexture', window, sceneTexture, [], destinationRect);
  Screen('Flip', window);
  
  WaitSecs(2);
  KbWait();
  
  %%Present the mask
  Screen('DrawTexture', window, maskTexture, [], destinationRect);
  Screen('Flip', window);
  
  WaitSecs(2)
  KbWait();
  
  %newsizeRect = OffsetRect(destinationRect, destinationRect(1)./0.5, destinationRect(2)./0.5);
  newsizeRect = [destinationRect(1).*.2, destinationRect(2).*.2]; 
  
  Screen('Drawtexture', window, imgTexture, [], [newsizeRect(1), newsizeRect(2), destinationRect(3), destinationRect(4)]);
  Screen('Flip', window);
  
  %
  WaitSecs(2);
  KbWait();
  
  %% now try to offset the image resizing it
  
   experimentEnd = GetSecs;										                          % time stamp the end of the study (more useful for fMRI/ERP?)
   
  Screen('CloseAll');												                            % close all the offscreen and onscreen windows
  ShowCursor;														                                % guess what?
  ListenChar(0);         
  %save([subjID '_internalpercepts_TMS' datestr(now, 30) '.mat'], '-v7');	 
    

%%% if an error occurs it enters the catch statement  
catch 

Screen('CloseAll');												                            % close all the offscreen and onscreen windows
ShowCursor;														                                % guess what?
ListenChar(0);         
%save([subjID '_internalperceptssize' datestr(now, 30) '.mat'], '-v7');	
fprintf('We''ve hit an error.\n');
psychrethrow(psychlasterror);

end
