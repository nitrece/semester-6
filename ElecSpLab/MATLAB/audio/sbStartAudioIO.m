function [ai, ao] = sbStartAudioIO(Fs, N)

% shared variables
global sbAudioIO_AiAdaptor sbAudioIO_AiId;

% stop all running data acquisition objects
if (~isempty(daqfind))
    stop(daqfind)
end

% create analog input object
if(isempty(sbAudioIO_AiAdaptor))
    adaptor = 'winsound';
else
    adaptor = sbAudioIO_AiAdaptor;
end
if(isempty(sbAudioIO_AiId))
    ai = analoginput(adaptor);
else
    ai = analoginput(adaptor, sbAudioIO_AiId);
end

% add required setting to the analog input object
addchannel(ai, [1 2]);
ai.SampleRate = Fs;
ai.SamplesPerTrigger = N;
ai.TriggerType = 'Immediate';
ai.TriggerRepeat = inf;

% start analog input
start(ai);

end
