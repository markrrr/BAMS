identification division.
program-id. AddAttendee is initial.

environment division.
input-output section.
    file-control.
        select optional AttendeesFile assign to AttendeeFileName
            organization is indexed
            access mode is dynamic
            record key is AuthCode
            file status is AttendeeStatus.

data division.
file section.
    fd AttendeesFile.
        copy Attendee replacing Attendee by
            ==AttendeeRecord.
            88 EndOfAttendeesFile value high-values==.

local-storage section.
    01 AttendeeStatus   pic x(2).
        88 Successful   value "00".
        88 RecordExists value "22".
        88 NoSuchRecord value "23".

    01 BackupFileName   pic x(20) value spaces.

linkage section.
    01 AttendeeFileName pic x(20) value "attendees.dat".
    copy Attendee replacing Attendee by ==ThisAttendee==.

procedure division using AttendeeFileName, ThisAttendee.
    move AttendeeFileName to BackupFileName
    inspect BackupFileName replacing all ".dat" by ".bak"
    call "C$COPY" using AttendeeFileName, BackupFileName, 0

    open i-o AttendeesFile
        write AttendeeRecord from ThisAttendee
            invalid key
                if RecordExists
                    display "Record for " Name of ThisAttendee "  already exists"
                else
                    display "Error - status is " AttendeeStatus
                end-if
        end-write
    close AttendeesFile
    goback
    .

end program AddAttendee.
