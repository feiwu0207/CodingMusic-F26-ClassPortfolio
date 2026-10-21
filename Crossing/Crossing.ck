// CROSSING - 60 seconds

// ================= SOUND SETUP =================
Gain master => dac;
0.38 => master.gain; // Lower master slightly to leave room for louder FX

SndBuf2 kick => master;
SndBuf2 snare => master;
me.dir() + "audio/kick_04.wav" => kick.read;
me.dir() + "audio/snare_02.wav" => snare.read;
kick.samples() => kick.pos;
snare.samples() => snare.pos;
0.42 => kick.gain;
0.25 => snare.gain;

TriOsc highsound => master;
0.0 => highsound.gain;

SndBuf2 fx03 => master;
SndBuf2 fx04 => master;
me.dir() + "audio/stereo_fx_03.wav" => fx03.read;
me.dir() + "audio/stereo_fx_04.wav" => fx04.read;
0.65 => fx03.rate;
1.0 => fx04.rate;
fx03.samples() => fx03.pos;
fx04.samples() => fx04.pos;
0.0 => fx03.gain;
0.0 => fx04.gain;

// ================= GLOBAL VARIABLES =================
60.0 => float totalTime;
0.0 => float currentTime;
0.0 => float drumClock;
0.0 => float oscClock;
0.8 => float drumStart;
0.1 => float drumEnd;
0.1 => float oscStart;
0.8 => float oscEnd;

[1,0,0,1,0,1,0,0] @=> int kickPattern[];
[0,0,1,0,0,0,1,0] @=> int snarePattern[];
[1,0,1,0,0,1,0,1] @=> int kickPatternB[];
[0,1,0,0,1,0,1,0] @=> int snarePatternB[];
// Last 6 seconds: denser rhythm, same continuously accelerating clock
[1,0,1,1,1,0,1,1] @=> int kickFinal[];
[0,1,0,1,0,1,1,0] @=> int snareFinal[];
[72,79,76,74,81,79,76,74] @=> int melodyPattern[];

0 => int drumStep;
0 => int oscStep;
0.04 => float pulseLength;
0.0 => float oscOffTime;
7.0 => float fx03Next;
15.0 => float fx04Next;

// ================= MAIN FUNCTION =================
fun void crossing()
{
    while (currentTime < totalTime)
    {
        currentTime / totalTime => float progress;
        drumStart + (drumEnd - drumStart) * progress => float drumInterval;
        oscStart + (oscEnd - oscStart) * progress => float oscInterval;

        // GROUP A: kick and snare share the same rhythm clock
        if (currentTime >= drumClock)
        {
            if (currentTime < 15.0)
            {
                if (kickPattern[drumStep % 8] == 1) { 0 => kick.pos; }
                if (snarePattern[drumStep % 8] == 1) { 0 => snare.pos; }
            }
            else if (currentTime < 54.0)
            {
                if (kickPatternB[drumStep % 8] == 1) { 0 => kick.pos; }
                if (snarePatternB[drumStep % 8] == 1) { 0 => snare.pos; }
            }
            else
            {
                if (kickFinal[drumStep % 8] == 1) { 0 => kick.pos; }
                if (snareFinal[drumStep % 8] == 1) { 0 => snare.pos; }
            }
            drumStep++;
            drumInterval +=> drumClock;
        }

        // DRUM MIX: slowly grow during final 15 seconds
        if (currentTime < 45.0)
        {
            0.42 => kick.gain;
            0.25 => snare.gain;
        }
        else
        {
            (currentTime - 45.0) / 15.0 => float drumRise;
            0.42 + 0.20 * drumRise => kick.gain;
            0.25 + 0.14 * drumRise => snare.gain;
        }

        // GROUP B: high oscillator (short notes -> gradual melody)
        if (currentTime >= oscOffTime)
        {
            0.0 => highsound.gain;
        }
        if (currentTime >= oscClock)
        {
            if (currentTime < 7.0)
            {
                Math.random2(0,7) => int randomIndex;
                Std.mtof(melodyPattern[randomIndex] + 12) => highsound.freq;
                0.04 => pulseLength;
            }
            else if (currentTime < 17.0)
            {
                (currentTime - 7.0) / 10.0 => float change;
                Math.random2(0,7) => int randomIndex;
                melodyPattern[randomIndex] + 12 - 12 * change => float note;
                Std.mtof(note) => highsound.freq;
                0.08 + 0.10 * change => pulseLength;
            }
            else
            {
                Std.mtof(melodyPattern[oscStep % 8]) => highsound.freq;
                0.18 => pulseLength;
            }

            // Oscillator recedes from 43s to 60s
            if (currentTime < 43.0)
            {
                0.12 => highsound.gain;
            }
            else
            {
                (currentTime - 43.0) / 17.0 => float fadeHigh;
                0.12 * (1.0 - fadeHigh) => highsound.gain;
            }
            currentTime + pulseLength => oscOffTime;
            oscStep++;
            oscInterval +=> oscClock;
        }

        // GROUP C: FX03 - louder atmosphere, steadier level
        // FX03 begins at 7s; fade in 7-9, hold 9-15, fade out 15-19.
        // The sample is repeated because its file is shorter than the section.
        if (currentTime >= 7.0 && currentTime < 19.0)
        {
            if (currentTime >= fx03Next && fx03.samples() > 0)
            {
                0 => fx03.pos;
                fx03.samples()::samp => dur fx03Length;
                currentTime + (fx03Length / second) / 0.65 => fx03Next;
            }
            if (currentTime < 9.0)
            {
                (currentTime - 7.0) / 2.0 => float fadeIn03;
                0.45 * fadeIn03 => fx03.gain;
            }
            else if (currentTime < 15.0)
            {
                0.45 => fx03.gain;
            }
            else
            {
                (currentTime - 15.0) / 4.0 => float fadeOut03;
                0.45 * (1.0 - fadeOut03) => fx03.gain;
            }
        }
        if (currentTime >= 19.0) { 0.0 => fx03.gain; }

        // FX04 begins exactly when Drum Pattern B enters (15 seconds)
        // More audible, longer steady section, gentle final lift then fade.
        if (currentTime >= 15.0 && currentTime < 60.0)
        {
            if (currentTime >= fx04Next && fx04.samples() > 0)
            {
                0 => fx04.pos;
                fx04.samples()::samp => dur fx04Length;
                currentTime + fx04Length / second => fx04Next;
            }
            if (currentTime < 18.0)
            {
                (currentTime - 15.0) / 3.0 => float fadeIn04;
                0.40 * fadeIn04 => fx04.gain;
            }
            else if (currentTime < 48.0)
            {
                0.40 => fx04.gain;
            }
            else if (currentTime < 56.0)
            {
                (currentTime - 48.0) / 8.0 => float fxRise;
                0.40 + 0.12 * fxRise => fx04.gain;
            }
            else if (currentTime < 58.0)
            {
                0.52 => fx04.gain;
            }
            else
            {
                (currentTime - 58.0) / 2.0 => float fxFade;
                0.52 * (1.0 - fxFade) => fx04.gain;
            }
        }

        // Advance ChucK time and our timeline together
        0.005::second => now;
        0.005 +=> currentTime;
    }
    0.0 => highsound.gain;
    0.0 => fx03.gain;
    0.0 => fx04.gain;
}

// ================= START =================
crossing();
