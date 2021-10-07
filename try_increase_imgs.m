function try_increase_imgs(subjID, whichsoftware)
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
  
  Screen('Preference', 'SkipSyncTests', 0); 						% set to 1 for debugging, 0 when doing real testing
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
  %screenRect = [100 100 600 600];            %% uncomment this and next line for small screen for debugging
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
  ctrRect = CenterRect([0 0 200 300], screenRect);				% a rectangle that puts our image at the center of the screen
  
  
  %%%%%%%%%                                               %%%%%%%%%%
  % Here we LOAD parameters that are relevant to the experiment    % 
  %%%%%%%%%                                               %%%%%%%%%%
  
  %internalsizepercepts_parameters; %% UPDATE TTHIS LATER

  if whichsoftware == 'octave'
  rootDir = 'C:/Users/uomom/Documents/internalsizepercept/'; % root directory for the experiment - Windows
  else
  rootDir = 'D:/Documents/Marco_Gandolfo/internalsizepercept/';		% root directory for the experiment in the lab - Windows

  
  numImages = 4; 											  % number of pictures in each condition and block
  numBlocks = 1;											  % how many blocks of 32 trials do I want to test?
  numDurs = 5;                                                % number of fixation durations, to jitter fixation cross durations
  memotestpixDur = 2-0.5;                                     % number of screen frames for target stimuli in the memotestphase
  testphasepixDur = 24;                                       % number of screen frames for the experimental test phase for the target picture
  maskDur = 18;                                               % number of screen frames for the Mask
  studyphasePixDur = 360;                                     % 6 seconds duration or keypress
  numStudyReps = 1;                                           % how many times they repeat
  fixDur = [45 60 90 105 120] - 0.5;												% number of screen frames for the Fixation; subtract 0.5 to compensate for timing jitter (see DriftWaitDemo.m)
  maxRespDur = 2;												% timeout for the response (in seconds, not frames, because for this we use GetSecs rather than frame timing)
  memtestpixdur = 2 - 0.5; %% duration of the picture for the memtest in frames
  maxCatRespDur = 3; %% maximum time for categorical response in seconds
  expphasepixDur = 21 - 0.5; %% 357 msecs
  expphaseMaskDur = 6 -0.5; %% 100 ms
  

  %%%%%%%%%                                              %%%%%%%%%%%%
  % LOAD All Images into turbo textures                             %
  %%%%%%%%%                                              %%%%%%%%%%%%

  %internalpercepts_loadimages;  FIX LATER!!

  %% prepare texture for the response screen
  img = imread('01_flat_desert_furniture_gb.png');

  imgTexture = Screen('MakeTexture', window, img);
  



  cd(rootDir);													% change to the main experiment directory
  Screen('FillRect', window, 128);								% grey background
  Screen('TextColor', window, [0 0 0]);							% black text
  Screen('TextSize', window, 48);									% big font
  Screen('DrawText', window, 'Press a key when ready.', 20, 20);	% draw the ready signal offscreen
  vbl = Screen('Flip', window);									% flip it onscreen

  %% set the base rectangle for the study phase
  baseRect = [0 0 823 563];
  %% Center this rectangle to Screen Center
  centeredRect = CenterRectOnPointd(baseRect, ctrPoint(1), ctrPoint(2));
  %% red and green color vectors
  redcolor = [175 0 0];
  greencolor = [0 175 0];

  rectangle = [0 0 800 533];


  numsizes = 10
  sizesteps = [-100 -80 -70 -60 -50 100 80 70 60 50]

  sizelist = {};

  for g = 1:numsizes
    
    sizelist{g} = rectangle([3,4]) + sizesteps(g);
  
  end
   

  KbWait; KbReleaseWait;											% hold on until any key is pressed and then released
  experimentStart = GetSecs;			

  %%%%%%%%%
  % This is the main loop of the experiment (over trials)
  % we will put up a fixation point, followed by the image
  % we select a random fish/car on each trial (could be better!)
  % we collect a keypress and a response time
  %%%%%%%%%
  
    for t = 1:size(sizelist,2)
      
     
      %% fixation dot
      Screen('gluDisk', window, 0, ctrPoint(1), ctrPoint(2), 8);  % draw fixation dot (offscreen)
      vbl = Screen('Flip', window);	
      
      %% drawing the image from the right condition    
      Screen('DrawTexture', window, ...							% draw an image offscreen in the right location -- try "Screen DrawTexture?" in command window
   img, [], [rectangle(1), rectangle(2), sizelist{t}(1), sizelist{t}(2)]); % 1st dimension is block, second dimension is full/box/foil 3rd dimension is the exemplar category 1-2-3-4
   [vbl imgOnset(t) fts(t,1) mis(t,1) beam(t,1)] = ...			% (keep track of lots of Flip output)
    Screen('Flip', window, vbl + (fixDur(randi(length(fixDur))) .* ifi)); %% flip image after a random duration of the cross
   
    
    Screen('FillRect', window, [128 128 128], []);
    [vbl maskOffset(t) fts(t,2) mis(t,2) beam(t,2)] = ...		% (keep track of lots of Flip output)
    Screen('Flip', window, vbl + (maskDur .* ifi)); 
   
   
    
    responded = 0; 												% reset the response flag for each trial
        while ((GetSecs - imgOnset(t)) < maxRespDur)				% keep checking for a keypress until the clock runs out
          [keyIsDown, secs, keyCode] = KbCheck;					% check for a key press(es)
          if ~responded && keyIsDown								% if they didn't respond already and a key is down, then ...
            RTs{b}(t) = GetSecs - imgOnset(t);						% response time, in seconds, since the onset of the image			
            responded = 1;										% set the flag - now they have responded (so now we won't take any later keypresses on this trial)
            oneKey = find(keyCode);								% use find to figure out which key(s) they pressed
            keys{b}(t) = oneKey(1);	       % maybe they mashed multiple keys! then just pick one (the first one, in keyCode order)
            oneKey;
            KbReleaseWait; %% hold on until the key is released.
            break;          
            
          end
        end
        
  
           respOnset(t)
 
   
      
 end

  experimentEnd = GetSecs;										                          % time stamp the end of the study (more useful for fMRI/ERP?)
   
  Screen('CloseAll');												                            % close all the offscreen and onscreen windows
  ShowCursor;														                                % guess what?
  ListenChar(0);         
  save([subjID '_internalpercepts_TMS' datestr(now, 30) '.mat'], '-v7');	 
    

%%% if an error occurs it enters the catch statement  
catch 

Screen('CloseAll');												                            % close all the offscreen and onscreen windows
ShowCursor;														                                % guess what?
ListenChar(0);         
save([subjID '_internalpercepts_TMS' datestr(now, 30) '.mat'], '-v7');	
fprintf('We''ve hit an error.\n');
psychrethrow(psychlasterror);

end


