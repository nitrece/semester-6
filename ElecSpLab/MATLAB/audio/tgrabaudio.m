function samples=tgrabaudio(N, varargin)
%samples=tgrabaudio(N, varargin)
%
%=================================
% Gets the next N samples of audio, intended for use with realtime audio
%=================================
%
% 1/ Initialisation (mandatory)
%     tgrabaudio('start', [fs, [maxduration]])
%
%     fs = the sample-rate [default = 44100]
%     maxduration = the maximum delay (in seconds) that is considered an
%                   acceptable build-up of audio samples. If this buffer is
%                   exceeded during auditory capture, an error will be generated. 
%     
% 2/ Audio capture
%     wave=tgrabaudio(N);
%     
%     N = the number of samples to be "grabbed".
%
%     wave = by default, stereo input [hard-wired: search the code for "addchannel" to adapt for mono input]
%
% 3/ Tidying up (mandatory)
%
%     tgrabaudio('stop')
%
%    This clears the persistent variables and stops the background audio
%    input. Careful, if this step is omitted, Matlab is likely to crash or
%    behave strangely the next time tgrabaudio is run. NB if a program that
%    uses tgrabaudio crashes before calling tgrabaudio('stop'), don't forget 
%    to call tgrabaudio('stop') as soon as possible (either manually or using
%    Matlab's try...catch keywords).
%
%    EXAMPLE:
%
% The following code shows how to use tgrabaudio to input sound in
% realtime. For demo purposes, the audio is gathered over a finite period, 
% reconstructed into a single variable, and then simply played back.
% However, the same construction could be used for continuous processing of
% audio input.
% 
% >> framesamples=160; fs=16000; totalframes=100;
% >> wave=zeros(framesamples*totalframes,2);
% >> pointer=1;
% >> tgrabaudio('start',fs);
% >> for ii=1:totalframes
% >>     framedata=tgrabaudio(framesamples);
% >>     %do realtime processing here
% >>     wave(pointer:pointer+framesamples-1,:)=framedata;
% >>     pointer=pointer+framesamples;
% >> end;
% >> sound(wave,fs)

persistent ai fs maxsamples;

if isnumeric(N)
    samples=getdata(ai,N); %get N samples
    if get(ai,'SamplesAvailable')>maxsamples; error('Potential build-up?'); end;
else
    if ischar(N)
        switch(N)
            case{'start'}
                if nargin>=2
                    fs=varargin{1};
                else
                    fs=44100;
                end;
                ai = analoginput('winsound');
                chan = addchannel(ai, [1 2]); %#ok<NASGU> %Omit this line for mono input
                set(ai, 'SampleRate', fs);
                set(ai, 'SamplesperTrigger', inf); %continue indefinititely
                start(ai)
            case{'stop'}
                stop(ai);
                delete(ai);
                clear ai fs maxsamples
            otherwise
                error('Unknown instruction: %s', N)
        end;
        if nargin>=3
            maxduration=varargin{2};
        else
            maxduration=2; %seconds;
        end;
        maxsamples=maxduration*fs; %if the processing falls two seconds behind
    else
        error('The first parameter should be the number of samples, ''start'', or ''stop''');
    end;
end;