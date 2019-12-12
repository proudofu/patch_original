function define_led_prefs()

global SCOPE_NUMBER;

% global LED_CONTROLLER_PORT_CONFIG;
% % LED_CONTROLLER_PORT_CONFIG(1,:) = [1 2 0 0 0 0 0 0 0 0 2 3 0 0 0];
% % LED_CONTROLLER_PORT_CONFIG(2,:) = [1 3 3 4 0 0 0 0 0 0 0 0 0 0 0];
% 
% LED_CONTROLLER_PORT_CONFIG(1,:) = [1 2 2 0 0 0 0 0 0 0 0 0 0 0 0];
% LED_CONTROLLER_PORT_CONFIG(2,:) = [1 3 3 0 0 0 0 0 0 0 0 0 0 0 0];
% LED_CONTROLLER_PORT_CONFIG(4,:) = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
% LED_CONTROLLER_PORT_CONFIG(100,:) = [1 2 3 4 0 0 0 0 0 0 0 0 0 0 101];

global LED_LAMBDA;
LED_LAMBDA = [455 530 590 400];
% LED_LAMBDA(23) = 560;

global LED_CHANNELS_COLORS;
LED_CHANNELS_COLORS{1} = 'blue';
LED_CHANNELS_COLORS{2} = 'green';
% LED_CHANNELS_COLORS{3} = 'amber';
% LED_CHANNELS_COLORS{4} = 'violet';
% LED_CHANNELS_COLORS{10} = 'gray';
% LED_CHANNELS_COLORS{22} = 'doublegreen';
% LED_CHANNELS_COLORS{33} = 'doubleamber';
% LED_CHANNELS_COLORS{23} = 'ambergreen';
% LED_CHANNELS_COLORS{32} = 'greenamber';
% LED_CHANNELS_COLORS{101} = 'histamine';
% LED_CHANNELS_COLORS{102} = 'capsaicin';
% LED_CHANNELS_COLORS{201} = 'odor';
% LED_CHANNELS_COLORS{202} = 'odor2';

global POWERMETER_DIAMETER;
POWERMETER_DIAMETER = 8; % in mm

global POWERMETER_AREA;
POWERMETER_AREA = pi*(POWERMETER_DIAMETER/2)^2;

global MAX_LED_CURRENT;
global LED_CONTROL_PROGRAM;
global DEFAULT_LED_STROBE_PERIOD;

global PAUSELOOP_STEPSIZE;
global PAUSELOOP_HALF_STEPSIZE;

global LED_CALIBRATION_PATH;
global LED_CALIBRATION_MOVIES_PATH;

global DEFAULT_STROBE_ON_TIME;
global DEFAULT_STROBE_PAUSE_TIME;

global LED_LEVEL_SETTING;

global DEBUG_FLAG;

global LED_PAPER_METER;

global DEFAULT_LED_CURRENT;
global DEFAULT_LED_POWER;

global LED_CALIBRATION_STIMULUS;

global LED_FIT_TOL;
LED_FIT_TOL = 1.1;

% global CLOCK_ZERO;
% CLOCK_ZERO = 1.0e+003*[2.0120    0.0010    0.0120    0.0130    0.0410    0.0596];
% CLOCK_ZERO = absolute_seconds(CLOCK_ZERO); % 6.341989571960000e+010;

PAUSELOOP_STEPSIZE = 0.015625;
PAUSELOOP_HALF_STEPSIZE = PAUSELOOP_STEPSIZE/2;

MAX_LED_CURRENT = 5;
% LED_CONTROL_PROGRAM = 'C:\Users\rhoadesj\Dropbox (MIT)\Behavioral Setup\Matlab\LED_control.m';

% DEFAULT_LED_STROBE_PERIOD = [];
DEFAULT_LED_STROBE_PERIOD = [0 0 0 0]; % [PAUSELOOP_STEPSIZE 0]; % [2*PAUSELOOP_STEPSIZE 0];

DEFAULT_STROBE_ON_TIME = [0 0 0 0];  % 5 0 0 
DEFAULT_STROBE_PAUSE_TIME = [0 0 0 0]; % 0.5 0 0 

DEFAULT_LED_CURRENT = [5 5 5 5];

DEFAULT_LED_POWER = [1.25 1.25 1.25 1.25];

LED_CALIBRATION_PATH = 'C:\Users\rhoadesj\Dropbox (MIT)\Behavioral Setup\Matlab\LED_files\';
LED_CALIBRATION_MOVIES_PATH  = 'C:\Users\rhoadesj\Dropbox (MIT)\Behavioral Setup\Matlab\LED_files\calibration_movies\';
      
LED_LEVEL_SETTING = [0.25 0.5 0.75 1 1.5 2 2.5 3 3.5 4 4.5 5];                           

LED_PAPER_METER=[];

% scope, color, [m b 0 0] m*x + b or [A a B b] A*x^a + B*exp(b*x)

% scope 1
LED_PAPER_METER(1,1,:) = [6.970992e-8 1.304908e-3 0 0]; % blue
LED_PAPER_METER(1,2,:) = [8.5144e-8 0.97763 2.430755e-3 1.112e-7]; % [5.3459e-8 0.052684 0 0];  % green
% LED_PAPER_METER(1,3,:) = [5.107730e-8 5.393446e-2 0 0]; % amber
% LED_PAPER_METER(1,4,:) = [0 0 0 0]; % violet

% scope 2
LED_PAPER_METER(2,1,:) = [2.689603e-6 0.80518 2.7718388e-3 1.1275e-7]; % blue
LED_PAPER_METER(2,2,:) = [0 0 0 0]; % green
% LED_PAPER_METER(2,3,:) = [5.884466e-8 5.698853e-4 0 0]; % amber
% LED_PAPER_METER(2,4,:) = [8.847915e-8 1.440969e-1 0 0]; % violet

% scope 3 Steve's
LED_PAPER_METER(3,1,:) = [1.8201e-9 -.078201 0 0]; 
LED_PAPER_METER(3,2,:) = [1.3746e-9 -0.11247 0 0];  
% LED_PAPER_METER(3,3,:) = [0 0 0 0]; 

% scope 4
LED_PAPER_METER(4,1,:) = [1.087014e-7 7.959676e-2 0 0];  % blue
LED_PAPER_METER(4,2,:) = [0 0 0 0]; 
% LED_PAPER_METER(4,3,:) = [0 0 0 0]; 

% scope 5
LED_PAPER_METER(5,1,:) = [0 0 0 0]; 
LED_PAPER_METER(5,2,:) = [0 0 0 0]; 
% LED_PAPER_METER(5,3,:) = [0 0 0 0]; 


LED_CALIBRATION_STIMULUS = [5.000000	10.000000	; ...
15.000000	20.000000	;...
25.000000	30.000000	;...
35.000000	40.000000	;...
45.000000	50.000000	;...
55.000000	60.000000	;...
65.000000	70.000000	;...
75.000000	80.000000	;...
85.000000	90.000000	;...
95.000000	100.000000	;...
105.000000	110.000000	;...
115.000000	120.000000	];



DEBUG_FLAG = 0;
% 
% chan_num = 22;
% LED_CHANNELS_COLORS{chan_num} = 'doublegreen';
% LED_LAMBDA(chan_num) = LED_LAMBDA(2);
% DEFAULT_LED_CURRENT(chan_num) = DEFAULT_LED_CURRENT(2);
% DEFAULT_LED_POWER(chan_num) = DEFAULT_LED_POWER(2);
% LED_PAPER_METER(1,chan_num,:) = LED_PAPER_METER(1,2,:);
% LED_PAPER_METER(2,chan_num,:) = LED_PAPER_METER(2,2,:);
% LED_PAPER_METER(3,chan_num,:) = LED_PAPER_METER(3,2,:);
% LED_PAPER_METER(4,chan_num,:) = LED_PAPER_METER(4,2,:);
% DEFAULT_LED_STROBE_PERIOD(chan_num) = 0;
% DEFAULT_STROBE_ON_TIME(chan_num) = 0;
% DEFAULT_STROBE_PAUSE_TIME(chan_num) = 0;
% 
% chan_num = 33;
% LED_CHANNELS_COLORS{chan_num} = 'doubleamber';
% LED_LAMBDA(chan_num) = LED_LAMBDA(3);
% DEFAULT_LED_CURRENT(chan_num) = DEFAULT_LED_CURRENT(3);
% DEFAULT_LED_POWER(chan_num) = DEFAULT_LED_POWER(3);
% LED_PAPER_METER(1,chan_num,:) = LED_PAPER_METER(1,3,:);
% LED_PAPER_METER(2,chan_num,:) = LED_PAPER_METER(2,3,:);
% LED_PAPER_METER(3,chan_num,:) = LED_PAPER_METER(3,3,:);
% LED_PAPER_METER(4,chan_num,:) = LED_PAPER_METER(4,3,:);
% DEFAULT_LED_STROBE_PERIOD(chan_num) = 0;
% DEFAULT_STROBE_ON_TIME(chan_num) = 0;
% DEFAULT_STROBE_PAUSE_TIME(chan_num) = 0;
% 
% chan_num = 23;
% LED_CHANNELS_COLORS{chan_num} = 'ambergreen';
% LED_LAMBDA(chan_num) = 560;
% DEFAULT_LED_CURRENT(chan_num) = 1000;
% DEFAULT_LED_POWER(chan_num) = 1.25;
% LED_PAPER_METER(1,chan_num,:) = [0 0 0 0];
% LED_PAPER_METER(2,chan_num,:) = [0 0 0 0];
% LED_PAPER_METER(3,chan_num,:) = [0 0 0 0];
% LED_PAPER_METER(4,chan_num,:) = [0 0 0 0];
% DEFAULT_LED_STROBE_PERIOD(chan_num) = 0;
% DEFAULT_STROBE_ON_TIME(chan_num) = 0;
% DEFAULT_STROBE_PAUSE_TIME(chan_num) = 0;

chan_num = 250;
LED_CHANNELS_COLORS{chan_num} = '';
LED_LAMBDA(chan_num) = 0;
DEFAULT_LED_CURRENT(chan_num) = 0;
DEFAULT_LED_POWER(chan_num) = 0;
LED_PAPER_METER(1,chan_num,:) = [0 0 0 0];
LED_PAPER_METER(2,chan_num,:) = [0 0 0 0];
LED_PAPER_METER(3,chan_num,:) = [0 0 0 0];
LED_PAPER_METER(4,chan_num,:) = [0 0 0 0];
DEFAULT_LED_STROBE_PERIOD(chan_num) = 0;
DEFAULT_STROBE_ON_TIME(chan_num) = 0;
DEFAULT_STROBE_PAUSE_TIME(chan_num) = 0;

return;
end
