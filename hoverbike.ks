clearscreen.

lock currentPitch to 90 - VECTORANGLE(UP:VECTOR, SHIP:FACING:FOREVECTOR).
lock currentroll TO 90 - VECTORANGLE(UP:VECTOR, SHIP:FACING:STARVECTOR).
lock vert  to ship:verticalspeed.
lock g to constant:g * body:mass / (body:radius + ship:altitude)^2.
lock maxAccel to (maxThrust / ship:mass).

lock downForce to max(cos(currentPitch) * cos(currentRoll) * maxAccel, 1).
//lock downForce to max(maxAccel, 1).
lock TWR to downForce / g.

declare global altKp to 0.05.
declare global altKd to 0.15.

set veryIdealThrottle to 0.
set autoHover to false.

on ag5{
    if(autoHover){
        set autoHover to false.
        unlock throttle.
    }
    else{
        set autoHover to true.
        lock throttle to veryIdealThrottle.
    }
}

lock rollError to 0 - (ship:velocity:surface * ship:facing:starvector).
lock pitchError to 0 - (ship:velocity:surface * ship:facing:forevector).

set rollPid to pidLoop(0.05, 0, 0, -1, 1).
set pitchPid to pidLoop(0.05, 0, 0, -1, 1).

set rollPid:setpoint to 0.
set pitchPid:setpoint to 0.

set steer to up.
set stayStill to false.

on ag6{
    if(stayStill){
        set stayStill to false.
        unlock steering.
    }
    else{
        set stayStill to true.
        lock steering to steer.
    }
}

set tgtAlt to 100.
on ag9{
    set tgtAlt to tgtAlt + 50.
    preserve.
}
on ag8{
    set tgtAlt to tgtAlt - 50.
    preserve.
}

until false{
    set currAlt to ship:altitude.

    if ag5{
        set currAlt to alt:radar.
    }

    set steer to up + r(pitchPid:update(time:seconds, pitchError) * -30, 0, rollPid:update(time:seconds, rollError) * -30).
    set veryIdealThrottle to ((1/TWR) - (vert * altKd) + ((tgtAlt - currAlt) * altKp)).

    print "Current Downforce: " + (TWR * throttle) / g + "                      " at (0, 4).
    print "Ideal Throttle: " + (100/TWR) + "                       " at (0, 5).
    print "Even more ideal throttle: " + (veryIdealThrottle) * 100 + "                         " at (0, 6).
    print "Current target altitude: " + tgtAlt + "                        " at (0, 7).
    print "Pitch Error: " + pitchError + "                        " at (0, 8).
    print "Roll Error: " + rollError + "                        " at (0, 9).
    print "Vector to stay still: " + steer + "                        " at (0, 9).
    print "Terrain mode(AG5): " + ag5 + "                       " at (0, 10).
    print "Landing mode(AG6): " + ag6 + "                       " at (0, 11).
}
