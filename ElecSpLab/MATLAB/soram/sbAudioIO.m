classdef sbAudioIO < handle
    % sbAudioIO - Realtime audio input-output class
    %   This class can be used to obtain and play audio in
    %   realtime.
    
    properties
        Fs = 44100;
        InpAdaptor = 'winsound';
        InpDevId = [];
        OutAdaptor = 'winsound';
        OutDevId = [];
        InpChannels = [1 2];
        OutChannels = [1 2];
        OutSilenceZeros = 64;
		OutPrevSamples = 16;
        DataType = 'double';
        Ai;
        Ao;
    end
    properties (SetAccess = 'private')
        AiActive = 0;
        AoActive = 0;
    end
    
    methods
        function PauseInp(obj)
            if(obj.AiActive == 1)
                stop(obj.Ai);
                obj.AiActive = 0;
            end
        end
        
        function PauseOut(obj)
            if(obj.AoActive == 1)
                stop(obj.Ao);
                obj.AoActive = 0;
            end
        end
        
        function Pause(obj)
            obj.PauseInp();
            obj.PauseOut();
        end
        
        function ResumeInp(obj)
            if(obj.AiActive == 0)
                start(obj.Ai);
                obj.AiActive = 1;
            end
        end

        function ResumeOut(obj)
            if(obj.AoActive == 0)
                start(obj.Ao);
                obj.AoActive = 1;
            end
        end
        
        function Resume(obj)
            obj.ResumeInp();
            obj.ResumeOut();
        end
        
        function obj = sbAudioIO(Fsamp)
            if(isempty(obj.InpDevId))
                obj.Ai = analoginput(obj.InpAdaptor);
            else
                obj.Ai = analoginput(obj.InpAdaptor, obj.InpDevId);
            end
            addchannel(obj.Ai, obj.InpChannels);
            if(isempty(obj.OutDevId))
                obj.Ao = analogoutput(obj.OutAdaptor);
            else
                obj.Ao = analogoutput(obj.OutAdaptor, obj.OutDevId);
            end
            addchannel(obj.Ao, obj.OutChannels);
            obj.Fs = Fsamp;
		end
        
        function StartInp(obj)
            obj.Ai.SampleRate = obj.Fs;
            obj.Ai.SamplesPerTrigger = inf;
            obj.Ai.TriggerType = 'Immediate';
            obj.Ai.TriggerRepeat = inf;
            obj.ResumeInp();
        end
        
        function StartOut(obj)
            obj.Ao.SampleRate = obj.Fs;
            obj.Ao.TriggerType = 'Immediate';
			obj.Ao.Timeout = inf;
            putdata(obj.Ao, zeros(obj.OutSilenceZeros, length(obj.OutChannels)));
            obj.ResumeOut();
        end
        
        function Start(obj)
            obj.StartInp();
            obj.StartOut();
        end
        
        function StopInp(obj)
            obj.PauseInp();
            delete(obj.Ai);
        end
        
        function StopOut(obj)
            obj.PauseOut();
            delete(obj.Ao);
        end
        
        function Stop(obj)
            obj.StopInp();
            obj.StopOut();
        end
        
        function delete(obj)
            obj.Stop();
        end
        
        function inp = PeekInp(obj)
            inp = peekdata(obj.Ai, obj.Ai.SamplesAvailable, obj.DataType);
        end
        
        function inp = GetInp(obj)
            inp = peekdata(obj.Ai, obj.Ai.SamplesAvailable, obj.DataType);
            flushdata(obj.Ai, 'all');
        end
        
        function inp = GetInpFixed(obj, num_samples)
            inp = getdata(obj.Ai, num_samples, obj.DataType);
        end
        
        function SetOut(obj, samples)
			if(obj.Ao.SamplesAvailable > 0 && size(samples, 1) > 0)
				putdata(obj.Ao, samples);
			elseif(size(samples, 1) > 0)
				putdata(obj.Ao, samples);
				start(obj.Ao);
			end
        end
    end
end

