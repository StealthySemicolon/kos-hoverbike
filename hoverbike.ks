clearscreen.

lock currentPitch to 90 - VECTORANGLE(UP:VECTOR, SHIP:FACING:FOREVECTOR).
lock currentroll TO 90 - VECTORANGLE(UP:VECTOR, SHIP:FACING:STARVECTOR).
lock vert  to ship:verticalspeed.
lock g to constant:g * body:mass / body:radius^2.
lock maxAccel to (maxThrust / ship:mass).

//lock downForce to max(cos(currentPitch) * cos(currentRoll) * maxAccel, 1).
lock downForce to max(maxAccel, 1).
lock upG to downForce / g.

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

    print "Current Downforce: " + (upG * throttle) / g + "        " at (0, 4).
    print "Ideal Throttle: " + (100/upG) + "        " at (0, 5).
    print "Even more ideal throttle: " + ((1/upG) - (vert * 0.1) + ((tgtAlt - currAlt) * 0.01)) * 100 + "        " at (0, 6).
    print "Current target altitude: " + tgtAlt + "        " at (0, 7).
    print "Landing mode(AG5): " + ag5 + "        " at (0, 8).
    if ag2 = true{
        lock throttle to ((1/upG) - (vert * 0.1) + ((tgtAlt - currAlt) * 0.01)).
    }
    else{
        unlock throttle.
    }
}
