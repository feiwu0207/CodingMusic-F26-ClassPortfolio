// 1. MELODY ARRAY
// MIDI note numbers
// Based on the MIDI note table

[60, 62, 64, 67, 69, 67, 64, 62,
60, 64, 67, 72, 71, 69, 67, 64] @=> int melody[];


// 2. DURATION ARRAY
// Each number controls how long each note lasts

[0.25, 0.25, 0.50, 0.50,
0.25, 0.25, 0.50, 0.50,
0.25, 0.25, 0.50, 0.50,
0.25, 0.25, 0.50, 1.00] @=> float duration[];


// 3. PAN ARRAY
// -1 = left
//  0 = center
//  1 = right

[-1.0, -0.7, -0.4, 0.0,
0.4, 0.7, 1.0, 0.5,
0.0, -0.5, -1.0, -0.5,
0.0, 0.5, 1.0, 0.0] @=> float panPosition[];


// 4. BASS ARRAY

[36, 36, 43, 43,
41, 41, 38, 38] @=> int bassNotes[];

// 5. BASS DURATION

[0.5, 0.5, 0.5, 0.5,
0.5, 0.5, 0.5, 0.5] @=> float bassDuration[];


// 6. CREATE SOUND

SinOsc melodyOsc => Pan2 melodyPan => dac;

TriOsc bassOsc => Pan2 bassPan => dac;

SinOsc clickOsc => dac;
0 => clickOsc.gain;

// 7. EVENT
// This represents:
// "WHEN the beat happens..."

Event beat;

// 8. METRONOME FUNCTION
// -----------------------------------------------------

fun void metronome()
{
    while(true)
    {
        // Trigger the event
        beat.signal();
        
        // Wait 250 milliseconds
        250::ms => now;
    }
}



// 9. BEAT SOUND
// This waits for the beat event

fun void beatSound()
{
    while(true)
    {
        // WAIT until the beat event happens
        beat => now;
        
        // Short click
        1000 => clickOsc.freq;
        0.09 => clickOsc.gain;
        
        30::ms => now;
        
        0 => clickOsc.gain;
    }
}


// 10. MELODY

fun void playMelody()
{
    while(true)
    {
        // Go through the entire melody array
        for(0 => int i; i < melody.cap(); i++)
        {
            // Convert MIDI note number to frequency
            Std.mtof(melody[i]) => melodyOsc.freq;
            
            
            // IF / ELSE
            // Change volume depending on pitch
               
            if(melody[i] >= 67)
            {
                0.7 => melodyOsc.gain;
            }
            else
            {
                0.13 => melodyOsc.gain;
            }
            
            
            // -----------------------------------------
            // ARRAY CONTROLS PANNING
            // -----------------------------------------
            
            panPosition[i] => melodyPan.pan;
            
            
            // ADVANCE TIME
                
            duration[i]::second => now;
            
            // Turn sound off between notes
            0 => melodyOsc.gain;
        }
    }
}

// 11. BASS

fun void playBass()
{
    while(true)
    {
        for(0 => int i; i < bassNotes.cap(); i++)
        {
            // MIDI -> frequency
            Std.mtof(bassNotes[i]) => bassOsc.freq;
            
            // Bass stays near center
            0.0 => bassPan.pan;
            
            // Bass volume
            0.5 => bassOsc.gain;
            
            // Play bass note
            bassDuration[i]::second => now;
            
            0 => bassOsc.gain;
        }
    }
}


// 12. BACKGROUND MOVING SOUND
// Math.sin() controls the pan


fun void spaceSound()
{
    Noise noise => Pan2 spacePan => dac;
    
    0.02 => noise.gain;
    
    0.0 => float phase;
    
    while(true)
    {
        // Math.sin() produces a value
        // between approximately -1 and 1
        
        Math.sin(phase) => spacePan.pan;
        
        // Slowly increase phase
        0.03 +=> phase;
        
        // Update every 20 ms
        20::ms => now;
    }
}

// 13. START ALL PARTS

spork ~ metronome();
spork ~ beatSound();
spork ~ playMelody();
spork ~ playBass();
spork ~ spaceSound();


// 14. KEEP THE PROGRAM ALIVE
while(true)
{
    1::second => now;
}