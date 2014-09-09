var sr71 = func
{
var IAS = getprop("/velocities/airspeed-kt");
var mach = getprop("/velocities/mach");
var alt = getprop("/position/altitude-ft");
var t0=getprop("/controls/engines/engine[0]/throttle");
var t1=getprop("/controls/engines/engine[1]/throttle");
var spoilers = 0.15*(mach+1)*(1-((t0+t1)/2));
var a0=t0*t0;
var a1=t1*t1;
var a = getprop("/orientation/alpha-deg");
var slats = 0;
var a_stall = (1.5-0.5*mach)*8;

if (getprop("/controls/gear/gear-down")) {spoilers = spoilers+0.05;}

if ((mach > 3.40) and (mach < 3.50))
{
a0 = a0*(1-(mach-3.40)/0.10);
a1 = a1*(1-(mach-3.40)/0.10);
spoilers = spoilers+(mach-3.40)/0.10;
}

if ((alt > 90000) and (alt < 95000))
{
a0 = a0*(1-(alt-90000)/5000);
a1 = a1*(1-(alt-90000)/5000);
spoilers = spoilers+(alt-90000)/5000;
}

if ((mach >= 3.50) or (alt >= 95000))
{
a0 = 0;
a1 = 0;
spoilers = 1;
}

if (IAS > 550) {spoilers = spoilers+(IAS-550)/100;}
if ((mach > 0.9) and (mach <= 1.0)) {spoilers = spoilers+0.3*(mach-0.9)/0.1;}
if ((mach > 1.0) and (mach < 1.15)) {spoilers = spoilers+0.3*(1.15-mach)/0.15;}
if (spoilers > 1) {spoilers = 1;}

if (a_stall < 6) {a_stall = 6;}
if (a > a_stall) {slats=(a-a_stall)*0.25;}
if (slats > 1) {slats = 1;}

setprop("/controls/flight/slats",slats);
setprop("/controls/engines/engine[0]/afterburner", a0);
setprop("/controls/engines/engine[1]/afterburner", a1);
setprop("/controls/flight/spoilers",spoilers);
settimer(sr71, 0.1);

}

setlistener("sim/signals/fdm-initialized",sr71);