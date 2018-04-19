// location of patch to run
~mainPatch = "/tmp/patch/main.scd".standardizePath;

// mother host output
~motherHost = NetAddr("127.0.0.1", 4001);
~motherHost.sendMsg("/patchLoaded",1);
~motherHost.sendMsg("/oled/setscreen",3);

// output for vumeter and volume control
~mainVolume = 0.8;
~mainOut = nil;
~outL = Bus.audio(s,1);
~outR = Bus.audio(s,1);
~mainOutDef = SynthDef(\mainOutput,
    {
        arg amp = 0.8;
        var insig,sig, peaksig;
        insig = SoundIn.ar([0,1]);
        sig = In.ar(~outL,2);
        sig = sig * amp;
        Out.ar(0,sig);
        peaksig=[insig[0],insig[1],sig[0],sig[1]];
        SendPeakRMS.kr(peaksig, 5, 3, "/audioLevel");
    }
);

/*
OSC outbound
/led i
/oled/line/1 args
/oled/vumeter 0-11

not implemented yet
/enablepatchsub 1
/gohome
*/

// oled function
~oled=();
~oled[\screen] = {
    arg self,line,str;
    ~motherHost.sendMsg(format("/oled/line/%",line), str);
};

~oled.screen(1,"SuperCollider loading");

~led = {
	arg i;
	~motherHost.sendMsg("/led", i.asInteger);
};

// notes callback, used for everything except aux key
~notes=();
~notes[\key_hit] = {
    arg self,key,vel;
    self.changed(\key,key+59,vel/127.0);
};

// knobs callbacks
~knobs=();
~knobValues = [0,0,0,0,0,0];

~knobs[\knob_changed] = {
	arg self, knob,val;
	if(~knobValues[knob] != val,
		{
			~knobValues[knob] = val;
			if(knob==4, {
				~mainVolume = val;
				~mainOut.set(\amp,~mainVolume);
			});

			self.changed(\knob,knob,val);
	});
};

// expr is actually a 'knob', but we separate like PD
~exp=();
~exp[\knob_changed] = {
    arg self, knob,val;
    if(~knobValues[knob] != val,
    {
        ~knobValues[knob] = val;
        self.changed(\exp,val);
    });
};

// aux callback
~aux=();
~aux[\key_hit] = {
    arg self,key,vel;
    self.changed(\aux,vel>0);
};

// encoder callbacks
~encoder_turn=();
~encoder_turn[\enc_turn] = {
    arg self,val;
    self.changed(\enc_turn,val);
};

~encoder_button=();
~encoder_button[\enc_hit] = {
    arg self,val;
    self.changed(\enc_button,val>0);
};

~footswitch=();
~footswitch[\fs_hit] = {
    arg self,val;
    self.changed(\fs,val>0);
};


/*
OSC Handling
Organelle OSC inbound messages
    /key ii 10 100
    /knobs iiiiii 604 342 451 64 666 1023
    /enc i 1
    /encbut i 1
    /fs  i 1

not implement yet
    /footSwitchPolarity
    /quit
    /midich

notes:
aux key = 0, C = 1 (and midi = 60)
knobs 1-4 = pots, 5 = volume , 6 = expr pedal
enc = 1 = clockwise, 0 anti

*/

OSCdef( \OrganelleKeys,
	{

		arg msg, time, addr, recvPort;
        // SC bug workaround 
        s.makeBundle(0.003, {
			if ( msg[1]>0,
				{~notes.key_hit(msg[1],msg[2]);},
				{~aux.key_hit(msg[1],msg[2]);}
			);
        });
	},
	"/key",
	recvPort:4000
);

OSCdef( \OrganelleKnobs,
	{
		arg msg, time, addr, recvPort;
		~knobs.knob_changed(0,msg[1]/1023.0);
		~knobs.knob_changed(1,msg[2]/1023.0);
		~knobs.knob_changed(2,msg[3]/1023.0);
		~knobs.knob_changed(3,msg[4]/1023.0);
		~knobs.knob_changed(4,msg[5]/1023.0);
		~exp.knob_changed(5,msg[6]/1023.0);
	},
	"/knobs",
	recvPort:4000
);

OSCdef( \OrganelleEncTurn,
	{
		arg msg, time, addr, recvPort;
		~encoder_turn.enc_turn(msg[1]);
	},
	"/enc",
	recvPort:4000
);

OSCdef( \OrganelleEncTurn,
	{
		arg msg, time, addr, recvPort;
		~encoder_button.enc_hit(msg[1]);
	},
	"/encbut",
	recvPort:4000
);

OSCdef( \OrganelleFootSwitch,
	{
		arg msg, time, addr, recvPort;
		~footswitch.fs_hit(msg[1]);
	},
	"/fs",
	recvPort:4000
);

OSCdef( \OrganelleAudioLevel,
	{
		arg msg, time, addr, recvPort;
		var peakInL,peakInR,peakOutL,peakOutR;
		peakInL = (msg[3] * 11).asInteger;
		peakInR = (msg[5] * 11).asInteger;
		peakOutL = (msg[7] * 11).asInteger;
		peakOutR = (msg[9] * 11).asInteger;

		~motherHost.sendMsg("/oled/vumeter", peakInL,peakInR,peakOutL,peakOutR);
	},
	"/audioLevel"
);


// boot the server
s.boot;
s.doWhenBooted {
	(
        Routine( {
        // SC 3.9 bug in boot completion 
        1.wait;
		~mainOut = ~mainOutDef.add.play;
		~mainPatch.load;
        }).play;
	)
};

