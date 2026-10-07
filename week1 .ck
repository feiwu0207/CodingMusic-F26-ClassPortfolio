SinOsc w1 => dac; 
PulseOsc w2 => dac;

160 => w1.freq;
240 => w2.freq;

0.4 => w1.gain;
0.09 => w2. gain;

1::second => now;

320 => w2.freq;
0.09 => w2.gain;

1.5::second =>now;

220 => w2.freq;
0.2 => w1.gain;
0.09 => w2.gain;

1::second => now; 

160 => w2.freq;
660 => w1.freq;
0.3 =>w2.gain;
0.9 => w1.gain;
2::second => now; 


