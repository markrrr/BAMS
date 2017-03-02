identification division.
program-id. BAMS.

data division.
working-storage section.
    01 AttendeesFileName pic x(20) value "attendees.dat".
    01 CommandLineArgumentCount pic 9 value zero.

procedure division.
    accept CommandLineArgumentCount from argument-number
    if CommandLineArgumentCount equal to 1 then
        accept AttendeesFileName from argument-value
    else
        move "attendees.dat" to AttendeesFileName
    end-if

    *> set environment 'COB_SCREEN_EXCEPTIONS' to 'Y'
    *> set environment 'COB_SCREEN_ESC' to 'Y'

    call "HomeScreen" using by content AttendeesFileName
    stop run.

end program BAMS.
