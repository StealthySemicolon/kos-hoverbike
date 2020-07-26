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

    print "Current Downforce: " + (TWR * throttle) / g + "                      " at (0, 4).
    print "Ideal Throttle: " + (100/TWR) + "                       " at (0, 5).
    print "Even more ideal throttle: " + ((1/TWR) - (vert * altKd) + ((tgtAlt - currAlt) * altKp)) * 100 + "                         " at (0, 6).
    print "Current target altitude: " + tgtAlt + "                        " at (0, 7).
    print "Landing mode(AG5): " + ag5 + "                       " at (0, 8).
    if ag2 = true{
        lock throttle to ((1/TWR) - (vert * altKd) + ((tgtAlt - currAlt) * altKp)).
    }
    else{
        unlock throttle.
    }
}
