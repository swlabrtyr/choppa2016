s.boot;
s.stop;


NetAddr.localAddr;

// Generic synth
(
SynthDef(\funsynth, {
	arg pitch=200;
	var sound = SinOsc.ar(pitch, mul:0.2);
	var linen = Env.linen(0.01, sustainTime:0, releaseTime:1);
	var env = EnvGen.kr(linen, doneAction:2);
	Out.ar(0, sound * env);
}).add;
)

// Multichannel expansion, Mantissa Mask
(
SynthDef.new(\multi, {
	arg pitch = 100;

	var sig, amp, env, mask, sigMask;

	env = EnvGen.kr(
		Env.new([0,1,0],[0.5,0.2],[1,-1]),
		doneAction:2
	);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0, 1);

	sig = SinOsc.ar(pitch);
	sig = sig * amp * env;

	mask = MantissaMask.ar(sig, 4);

	sigMask = Splay.ar(mask) * 0.5;

	Out.ar(0, sigMask);

	// Is amplitude changing? Does not appear to be
	amp.postln;
}).add;
)

x = Synth.new(\multi);
x.free;

// OSC receive from processing
(
OSCdef(\starlistener, {
	arg msg;
	Synth(\multi, [pitch:msg[1]*400+60, amp:msg[1]*0.002]);
	Synth(\funsynth, [pitch:msg[1]*400+60]);
}, "/mousex");
)

// OSC creating pbind pattern to sequence synthdef
(
OSCdef(\processing, {
	arg msg;
	p = Pbind (
		\type, \note,
		\instrument, \multi,
		\dur, Pseq([msg[1]/2000, msg[1]/2500, msg[1]/3000], 2).trace;
	).play;
p.stop;
}, "/mousey")
)

s.meter;


// Potential Delay
(
{
var signal;
var delaytime = MouseX.kr(0.001,0.2, 1);
signal = Impulse.ar(1); // the sound source

d =  DelayL.ar(signal, 0.6, delaytime);

[d, signal]
}.play
)
