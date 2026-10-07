// 9.23

SinOsc s => dac;
SinOsc r => dac;
0.5 => s.gain;
0.2 => r.gain;

for (0 => int i; i < 1; i++)
{
// 6
    220 => s.freq; 
    0.04::second => now;
 
for (0 => int i; i < 30; i++)
{
    Math.random2(100, 800) => r.freq;
    0.04::second => now;
}
    
    0 => r.gain;
// 5
    392 => s.freq;
    0.3::second => now;
    
// 6
    440 => s.freq;
    0.3::second => now;
    
// 6
    220 => s.freq;
    0.3::second => now;
    
// 2
    293 => s.freq;
    0.3::second => now;
    
    
// 3
    329 => s.freq;
    0.8::second => now;
    
// 4#
    369 => s.freq;
    0.3::second => now;
    
// 3
    329 => s.freq;
    0.5::second => now;
    
       
// 5
    392.00 => s.freq;
    0.8::second => now;
    
// 4#
    369 => s.freq;
    0.3::second => now;
    
// 2
    293 => s.freq;
    0.5::second => now;
    
// 3
    329 => s.freq;
    0.04::second => now;    
    
    0.2 => r.gain;
    for (0 => int i; i < 50; i++)
{
    Math.random2(100, 800) => r.freq;
    0.04::second => now;
 }

    0 => r.gain;  
// 6
    220 => s.freq; 
    0.5::second => now;
    
// 2
    293 => s.freq;
    0.3::second => now;
    
    
// 3
    329 => s.freq;
    0.3::second => now;    
    
// 6
    220 => s.freq; 
    0.3::second => now;
    
// 1
    261 => s.freq; 
    0.3::second => now;
    
//7   
    246 => s.freq;
    0.7::second => now;    
    
// 1
    261 => s.freq; 
    0.3::second => now;
    
//7   
    246 => s.freq;
    0.5::second => now;    
    
// 2
    293 => s.freq;
    0.8::second => now;    
    
//7   
    246 => s.freq;
    0.3::second => now;      
    
// 5
    196.00 => s.freq;
    0.5::second => now;
    
// 6
    220 => s.freq; 
    0.01::second => now;    
    0.2 => r.gain;
    for (0 => int i; i < 400; i++)
{
    100 + i => r. freq;
    0.009::second => now;
 }  
    
    
}