% Clear the workspace and the screen
sca;
close all;
clear;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% We will be drawing some text so here we set the size we want the text to
% be
Screen('TextSize', window, 30);

% The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 300 pixels
baseRect = [0 0 200 300];

% Set the color of the rect to red
rectColor = [0.5 0.5 0.5];

% Set the intial position of the square to be in the centre of the screen
squareX = xCenter;
squareY = yCenter;

% Colors of the dots we will be drawing
dotColors = [0 1 0; 1 0 0; 0 0 1];

% Set the amount we want our square to move on each button press
pixelsPerPress = 10;

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% This is the cue which determines whether we exit the demo
exitDemo = false;

% Loop the animation until the escape key is pressed
while exitDemo == false

    % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck;

    % Depending on the button press, either move ths position of the square
    % or exit the demo
    if keyCode(escapeKey)
        exitDemo = true;
    elseif keyCode(leftKey)
        squareX = squareX - pixelsPerPress;
    elseif keyCode(rightKey)
        squareX = squareX + pixelsPerPress;
    elseif keyCode(upKey)
        squareY = squareY - pixelsPerPress;
    elseif keyCode(downKey)
        squareY = squareY + pixelsPerPress;
    end

    % We set bounds to make sure our square doesn't go completely off of
    % the screen. Here when the srectangles edges hit the screen then it
    % will not move off the screen at all
    if squareX < baseRect(3) / 2
        squareX = baseRect(3) / 2;
    elseif squareX > screenXpixels - baseRect(3) / 2
        squareX = screenXpixels - baseRect(3) / 2;
    end

    if squareY < baseRect(4) / 2
        squareY = baseRect(4) / 2;
    elseif squareY > screenYpixels - baseRect(4) / 2
        squareY = screenYpixels - baseRect(4) / 2;
    end

    % Center the rectangle on the centre of the screen
    centeredRect = CenterRectOnPointd(baseRect, squareX, squareY);

    % Draw the rect to the screen
    Screen('FillRect', window, rectColor, centeredRect);

    % Draw dots that show the rects coordinates
    dotPositionMatrix = [squareX centeredRect(1) centeredRect(3);...
        squareY centeredRect(2) centeredRect(4)];
    Screen('DrawDots', window, dotPositionMatrix, 10, dotColors, [], 2);

    % Draw text in the upper portion of the screen with the default font in
    % white
    line1 = ['\n Top left corner (red dot): x = ' num2str(centeredRect(1))...
        ' y = ' num2str(centeredRect(2))];
    line2 = ['\n Bottom Right corner (blue dot): x = ' num2str(centeredRect(3))...
        ' y = ' num2str(centeredRect(4))];
    line3 = ['\n Rect Centre (green dot): x = ' num2str(squareX) ' y = ' num2str(squareY)];
    DrawFormattedText(window, [line1 line2 line3], 'center', 100, [1 1 1]);

    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

% Clear the screen
sca;

Published with MATLAB® R2021a