%05/13/2015

%This program is to plot two files next to each other from the real-life combined file.

%Clears all the variables and closes them
%Clears the screen
clear all; close all; clc
set(0,'defaultfigureWindowStyle','docked'); %This line makes it so that when you run the program, the default window style is 'docked'.

%Open the Log File.

%LogFile = fopen('..\ModuleData\LOG03337.TXT','r'); %One person null trial 1
%LogFile = fopen('..\ModuleData\LOG03339.TXT','r');	%One person alternative trial 1
%LogFile = fopen('..\ModuleData\LOG03586.TXT','r'); %Two people null (clips at 5000)
%LogFile = fopen('..\ModuleData\LOG03588.TXT','r'); %One person null trial two
%LogFile = fopen('..\ModuleData\LOG03589.TXT','r'); %Null test
%LogFile = fopen('..\ModuleData\LOG03592.TXT','r'); %Another Null test
%LogFile = fopen('..\ModuleData\LOG03593.TXT','r'); %Two person null redone
%LogFile = fopen('..\ModuleData\LOG03615.TXT','r'); %Two person alternative redone
%LogFile = fopen('..\ModuleData\LOG03617.TXT','r'); %Piqua
%LogFile = fopen('..\ModuleData\LOG03761.TXT','r'); %Outside
%LogFile = fopen('..\ModuleData\LOG03762.TXT','r'); %Basement
%LogFile = fopen('..\ModuleData\LOG03791.TXT','r'); %Real-life null trial
%LogFile = fopen('..\ModuleData\LOG03792.TXT','r'); %Real-life alternative trial
%LogFile = fopen('..\ModuleData\LOG03794.TXT','r'); %Test to see if the module is still working.
LogFile = fopen('..\ModuleData\LOG03795.TXT','r'); %Real-life combined.

SplitPlot = 1;

if SplitPlot
  StartOffsetMin = 2;
  PlotDurationMin = 67-StartOffsetMin;    %Time that the plot will be for.
  Exp2OffsetMin = 66.5;
end

MIN2SAMP = 30;
SAMP2MIN = 1/30;


NumLines = inf; %Read the whole file, or change the value for the number of lines you want to read.

%If the computer can't find the file, then it will give an error message.
if LogFile<0

  error('File not found.');

end

if ~isinf(NumLines)

  Data = zeros(NumLines,2);

else

  Data = [];

end

k = 1;

tline = fgets(LogFile);

while ischar(tline)

  %disp(tline)

  Data(k,:) = sscanf(tline,'%d,%f,%f,%d').'; %Put the data into arrays  - time (natural numbers), temperature (rational numbers), humidity (rational numbers), and CO2 Gas Concentration (natural numbers)

  % work-around for negtive number issue:
  Data(k,1) = k;
  tline = fgets(LogFile);
  if k == NumLines
    break;
  end
  k = k + 1;
end
fclose(LogFile);
Data = Data.';

if SplitPlot
  StartOffsetSamples = StartOffsetMin*MIN2SAMP;
  LengthSamples = PlotDurationMin*MIN2SAMP;

  TimeAxis = (0:(LengthSamples-1))*SAMP2MIN;

  Exp1 = Data(4,StartOffsetSamples:(StartOffsetSamples+LengthSamples-1));

  Exp2OffsetSamples = Exp2OffsetMin*MIN2SAMP;

  Exp2 = Data(4,(Exp2OffsetSamples+StartOffsetSamples):(Exp2OffsetSamples+LengthSamples+StartOffsetSamples-1));

  figure(1)
  hold on
  plot(TimeAxis,Exp1,'b')
  plot(TimeAxis,Exp2,'r')
  title('Time vs. Gas Concentration')
  xlabel('Time [Minutes]');
  ylabel('Gas Concentration [ppm]');
  hold off
  grid on

else

  % convert to minutes:
  Data(1,:)=Data(1,:)*SAMP2MIN;

  figure(1)
  plot(Data(1,:),Data(2,:))
  title('Analysis Part 1: Time vs. Temperature')
  xlabel('Time [Minutes]');
  ylabel('Temperature [C]')

  figure(2)
  plot(Data(1,:),Data(3,:))
  title('Analysis Part 2: Time vs. Humidity')
  xlabel('Time [Minutes]');
  ylabel('Humidity [%]')

  figure(3)
  plot(Data(1,:),Data(4,:))
  title('Analysis Part 3: Time vs. Gas Concentration')
  xlabel('Time [Minutes]');
  ylabel('Gas Concentration [PPM]')
  grid on

end
