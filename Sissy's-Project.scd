/*https://composerprogrammer.com/teaching/supercollider/sctutorial/12.2%20Singing%20Voice%20Synthesis.html*/


//First Voice Synth
(
SynthDef(\voicesound1,{|voiced=1 freq=110 amp=0.1|
var source, filter;

//flag for voiced (periodic) or unvoiced (aperiodic, noise source)

source = if(voiced,Impulse.ar(freq),WhiteNoise.ar(0.2));
filter= BLowPass.ar(BPF.ar(source,2000,0.1, source),4000, 0.25,100);

//add a boost to source around 2000 Hz, and also low pass overall
Out.ar(0,amp*filter.dup)
}).add
)

a= Synth(\voicesound1);

//Random Notes...
/*Question: How can I change the major scale to pentatonic one and how can I insert the above mentioned Synths to Pbind*/

Pbind(\dur, 1, \degree, Pseq([1, 0, 2, 3, 5, 10, 9, 7, 8, 8, 2, 2], 3), \amp, 0.2).play;

//Second Voice Synth
(
SynthDef(\voicesound2,{|voiced=1 freq= 440 amp=0.1|
var formantfreqs, formantamps, formantbandwidths; //data for formants
var output;
formantfreqs= [800,1150,2900,3900,4950]; //centre frequencies of formants
formantamps= ([0 ,-6,-32,-20,-50]-6).dbamp; //peaks of formants
formantbandwidths=[80,90,120,130,140];  //bandwidths
output= Mix(SinOsc.ar(formantfreqs,0,formantamps))*amp;
Out.ar(0,output.dup)
}).add
)

b = Synth(\voicesound2);

//Third Voice Synth
(
SynthDef(\voicesound3,{|voiced=1 freq= 440 amp=0.1|
var formantfreqs, formantamps, formantbandwidths; //data for formants
var source, output;
formantfreqs= [800,1150,2900,3900,4950]; //centre frequencies of formants
formantamps= ([0 ,-6,-32,-20,-50]-6).dbamp; //peaks of formants
formantbandwidths=[80,90,120,130,140];  //bandwidths
source = if(voiced,Impulse.ar(freq),WhiteNoise.ar(0.2));
output= Mix(BPF.ar(source, formantfreqs,formantbandwidths/formantfreqs,formantamps))*10*amp;
Out.ar(0,output.dup)
}).add
)

c = Synth(\voicesound3);

//Fourth Voice Synth

(
SynthDef(\voicesound4,{|voiced=1 freq= 440 amp=0.1|
var formantfreqs, formantamps, formantbandwidths; //data for formants
var periodicsource, aperiodicsource, source, output;
var vibrato;
var vibratonoise= LFNoise1.kr(10);
formantfreqs= [800,1150,2900,3900,4950]; //centre frequencies of formants
formantamps= ([0 ,-6,-32,-20,-50]-6).dbamp; //peaks of formants
formantbandwidths=[80,90,120,130,140];  //bandwidths
//with vibrato up to quartertone, rate of vibrato around 6+-1 Hz

/*calculate vibrato in midi note (log frequency) domain; final .midicps takes it back to frequency*/

//line generator delays onset of vibrato like a real singer

vibrato= ((freq.cpsmidi)+(Line.kr(0.0,1.0,2.5)*SinOsc.kr(6+(1.0*vibratonoise),0,0.5))).midicps;

// low pass filter on Impulse to avoid high harmonics making it too bright

periodicsource= LPF.ar(Impulse.ar(vibrato),5000);

//pink noise drops off as frequency increases at -dB per octave,

aperiodicsource= PinkNoise.ar(0.7);

//take now as mixture of periodic and aperiodic

source = (voiced*periodicsource)+((1.0-voiced)*aperiodicsource);

output= Mix(BPF.ar(source, formantfreqs,formantbandwidths/formantfreqs,formantamps))*100*amp;

Out.ar(0,output.dup)
}).add
)

d = Synth(\voicesound4);

//Fifth Voice Synth

(
SynthDef(\voicesound5,{|voiced=1 freq= 440 amp=0.03|
var formantfreqs, formantamps, formantbandwidths; //data for formants
var periodicsource, aperiodicsource, source, output;
var vibrato;
var vibratonoise= LFNoise1.kr(10);
formantfreqs= [800,1150,2900,3900,4950]; //centre frequencies of formants
formantamps= ([0 ,-6,-32,-20,-50]-6).dbamp; //peaks of formants
formantbandwidths=[80,90,120,130,140];  //bandwidths

//with vibrato up to quartertone, rate of vibrato around 6+-1 Hz

/*calculate vibrato in midi note (log frequency) domain; final .midicps takes it back to frequency*/

//line generator delays onset of vibrato like a real singer

vibrato= ((freq.cpsmidi)+(Line.kr(0.0,1.0,2.5)*SinOsc.kr(6+(1.0*vibratonoise),0,0.5))).midicps;

// low pass filter to avoid high harmonics making it too bright

periodicsource= LPF.ar(Pulse.ar(vibrato,LFNoise2.kr(LFNoise1.kr(1,0.25,0.5),0.1,0.5)),5000);

//pink noise drops off as frequency increases at -dB per octave,

aperiodicsource= PinkNoise.ar(0.7);

//take now as mixture of periodic and aperiodic

source= (voiced*periodicsource)+((1.0-voiced)*aperiodicsource);
output= Mix(BPF.ar(source, formantfreqs,(formantbandwidths+LFNoise2.kr(LFNoise1.kr(1,0.5,4),10))/formantfreqs,formantamps))*100*amp;
Out.ar(0,output.dup)
}).add
)

e = Synth(\voicesound5);

//Sixth Voice Synth

(
SynthDef(\voicesound6,{|voiced=1 freq= 440 amp=0.04 resonancescaling=5|
var formantfreqs, formantamps, formantbandwidths; //data for formants
var periodicsource, aperiodicsource, source, output;
var vibrato;
var vibratonoise= LFNoise1.kr(10);
formantfreqs= [800,1150,2900,3900,4950]; //centre frequencies of formants
formantamps= ([0 ,-6,-32,-20,-50]-6).dbamp; //peaks of formants
formantbandwidths=[80,90,120,130,140];  //bandwidths

//with vibrato up to quartertone, rate of vibrato around 6+-1 Hz

/*calculate vibrato in midi note (log frequency) domain; final .midicps takes it back to frequency*/

//line generator delays onset of vibrato like a real singer

vibrato= ((freq.cpsmidi)+(Line.kr(0.0,1.0,2.5)*SinOsc.kr(6+(1.0*vibratonoise),0,0.5))).midicps;

// low pass filter on Impulse to avoid high harmonics making it too bright

periodicsource= LPF.ar(Impulse.ar(vibrato),5000);

//pink noise drops off as frequency increases at -dB per octave,

aperiodicsource= PinkNoise.ar(0.3);

//take now as mixture of periodic and aperiodic

source= (voiced*periodicsource)+((1.0-voiced)*aperiodicsource);

/*the decaytime of the formlet is the filter's resonant decay time; a small bandwidth corresponds to a long decay (a 'ringing' filter). So I take the reciprocal of the formant bandwidth as an estimate of decaytime here, multiplied by a scaling factor for degree of resonance*/

output= Mix(Formlet.ar(source, formantfreqs, 0.001, resonancescaling*formantbandwidths.reciprocal, formantamps))*10*amp;
Out.ar(0,output.dup)
}).add
)

f = Synth(\voicesound6);

//Seventh... idk i just found it online
(
SynthDef(\vocoder,{|freq=200 voiced=1 amp=4|
var centrefreqs, amps, bandwidths, rq; //data for formants
var analysissignal, synthesissignal, periodicsource, aperiodicsource;
var analysisfilters, synthesisfilters;
centrefreqs= (1..10)*440; //choose centre frequencies
amps= (0.dup(10)).dbamp;
bandwidths= 300.dup(10); //(1..10)*200;  //bandwidths
rq= bandwidths/centrefreqs;	//reciprocal of q; bandwidth/centrefreq
analysissignal= SoundIn.ar; //analyze audio input on machine
periodicsource=Saw.ar(freq);

//pink noise drops off as frequency increases at -dB per octave

aperiodicsource= PinkNoise.ar(0.7);

//take now as mixture of periodic and aperiodic

synthesissignal= (voiced*periodicsource)+((1.0-voiced)*aperiodicsource);

//do the analysis in the specified bands, finding the amplitude in each band

analysisfilters = Amplitude.kr(BPF.ar(analysissignal, centrefreqs, rq));

//modulate bandwise the resynthesis

synthesisfilters = analysisfilters*BPF.ar(synthesissignal, centrefreqs, rq);

//amp compensates for energy lost by filters

Out.ar(0,(amp*Mix(synthesisfilters)).dup)
}).add
)

g = Synth(\vocoder);

