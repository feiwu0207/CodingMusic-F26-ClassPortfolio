// EIGHT-STEP TECHNO: INTRO, SYNCOPATION AND DRUM FILLS
// Put this .ck beside the audio folder containing your WAV files.

// 1. Sound chain
Gain master => dac;
0.25 => master.gain;
SndBuf2 kick => master;
SndBuf2 snare => master;
SndBuf2 hihat => master;
SndBuf2 clap => master;
SndBuf2 cowbell => master;
SndBuf2 fx1 => master;
SndBuf2 fx2 => master;
SndBuf2 fx3 => master;
SndBuf2 fx4 => master;
SndBuf2 fx5 => master;
SinOsc bass => Pan2 bassPan => master;

// 2. Sound files: use filenames exactly as shown on  Mac
me.dir() + "/audio/kick_01.wav" => kick.read;
me.dir() + "/audio/snare_01.wav" => snare.read;
me.dir() + "/audio/hihat_01.wav" => hihat.read;
me.dir() + "/audio/clap_01.wav" => clap.read;
me.dir() + "/audio/cowbell_01.wav" => cowbell.read;
me.dir() + "/audio/stereo_fx_01.wav" => fx1.read;
me.dir() + "/audio/stereo_fx_02.wav" => fx2.read;
me.dir() + "/audio/stereo_fx_03.wav" => fx3.read;
me.dir() + "/audio/stereo_fx_04.wav" => fx4.read;
me.dir() + "/audio/stereo_fx_05.wav" => fx5.read;

// 3. Do not play the files until triggered
kick.samples() => kick.pos;
snare.samples() => snare.pos;
hihat.samples() => hihat.pos;
clap.samples() => clap.pos;
cowbell.samples() => cowbell.pos;
fx1.samples() => fx1.pos;
fx2.samples() => fx2.pos;
fx3.samples() => fx3.pos;
fx4.samples() => fx4.pos;
fx5.samples() => fx5.pos;
0.0 => bass.gain;

// 4. Individual instrument volumes
0.68 => kick.gain;
0.48 => snare.gain;
0.21 => hihat.gain;
0.35 => clap.gain;
0.20 => cowbell.gain;
0.23 => fx1.gain;
0.20 => fx2.gain;
0.18 => fx3.gain;
0.19 => fx4.gain;
0.17 => fx5.gain;

// 5. Eight-step patterns. 1 means trigger; 0 means rest.
[1,0,0,0,1,0,0,0] @=> int kickStraight[];
[1,0,0,1,1,0,1,0] @=> int kickSyncopated[];
[0,0,1,0,0,0,1,0] @=> int snareStraight[];
[0,0,1,0,0,1,1,0] @=> int snareVariation[];
[0,0,1,0,1,0,1,0] @=> int hatSparse[];
[1,1,1,1,1,1,1,1] @=> int hatBusy[];
[0,0,1,0,0,0,1,0] @=> int clapPattern[];
[0,0,0,1,0,0,0,1] @=> int bellPattern[];
[36,0,0,36,43,0,39,0] @=> int bassNotes[];
0.0 => float phase;

// 6. Twenty bars, eight steps per bar
for(0 => int counter; counter < 160; counter++)
{
    counter % 8 => int beat;
    counter / 8 => int bar;

    // KICK: No kick until bar 4. A break at bar 14.
    if(bar >= 4 && bar != 14 && bar < 19)
    {
        if(bar < 6 && beat == 0)
        {
            0 => kick.pos;
        }
        else if(bar >= 6 && bar < 10 && kickStraight[beat] == 1)
        {
            0 => kick.pos;
        }
        else if(bar >= 10 && bar < 14 && kickSyncopated[beat] == 1)
        {
            0 => kick.pos;
        }
        else if(bar >= 15 && bar < 19 && kickSyncopated[beat] == 1)
        {
            0 => kick.pos;
        }
    }

    // SNARE: starts in bar 6 and changes rhythm later
    if(bar >= 6 && bar < 19 && bar != 14)
    {
        if(bar < 10 && snareStraight[beat] == 1)
        {
            Math.random2f(0.90, 1.10) => snare.rate;
            0 => snare.pos;
        }
        else if(bar >= 10 && snareVariation[beat] == 1)
        {
            Math.random2f(0.85, 1.15) => snare.rate;
            0 => snare.pos;
        }
    }

    // HI-HAT: intro is FX-only; then sparse, then busy, then sparse again
    if(bar >= 2 && bar < 19)
    {
        if((bar < 6 || bar == 14) && hatSparse[beat] == 1)
        {
            Math.random2f(0.90, 1.20) => hihat.rate;
            0 => hihat.pos;
        }
        else if(bar >= 6 && bar != 14 && hatBusy[beat] == 1)
        {
            Math.random2f(0.85, 1.30) => hihat.rate;
            0 => hihat.pos;
        }
    }

    // CLAP joins the powerful sections
    if(((bar >= 9 && bar < 14) || (bar >= 16 && bar < 19)) && clapPattern[beat] == 1)
    {
        0 => clap.pos;
    }

    // COWBELL adds syncopated accents
    if(((bar >= 11 && bar < 14) || (bar >= 16 && bar < 19)) && bellPattern[beat] == 1)
    {
        Math.random2f(0.90, 1.10) => cowbell.rate;
        0 => cowbell.pos;
    }

    // BASS starts later, stops for the break and ending
    if(bar >= 7 && bar < 19 && bar != 14 && bassNotes[beat] > 0)
    {
        Std.mtof(bassNotes[beat]) => bass.freq;
        0.09 => bass.gain;
    }
    else
    {
        0.0 => bass.gain;
    }

    // Gentle movement of bass from left to right
    Math.sin(phase) => bassPan.pan;
    0.12 +=> phase;

    // Five FX files mark introductions, changes and ending
    if((bar == 0 || bar == 19) && beat == 0) { 0 => fx1.pos; }
    if((bar == 2 || bar == 10) && beat == 0) { 0 => fx2.pos; }
    if((bar == 4 || bar == 14) && beat == 0) { 0 => fx3.pos; }
    if((bar == 7 || bar == 15) && beat == 0) { 0 => fx4.pos; }
    if((bar == 9 || bar == 13 || bar == 18) && beat == 6)
    {
        Math.random2f(0.85, 1.15) => fx5.rate;
        0 => fx5.pos;
    }

    <<< "Bar:", bar, "Beat:", beat >>>;

    // First half of the beat (125 ms)
    125::ms => now;

    // Additional quick hits BETWEEN regular steps, making double hits / fills
    if((bar == 9 || bar == 13 || bar == 18) && (beat == 6 || beat == 7))
    {
        Math.random2f(0.95, 1.20) => snare.rate;
        0 => snare.pos;
    }
    if((bar == 11 || bar == 17) && (beat == 3 || beat == 7))
    {
        0 => kick.pos;
    }
    if(bar >= 10 && bar < 19 && bar != 14 && beat % 2 == 1)
    {
        Math.random2f(0.95, 1.25) => hihat.rate;
        0 => hihat.pos;
    }

    // Second half of the beat (another 125 ms)
    125::ms => now;
}

// 7. Leave four seconds for ending FX tail
0.0 => bass.gain;
4::second => now;
