identification division.
program-id. GetAttendeeStats is initial.

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

linkage section.
    01 AttendeeFileName pic x(20) value "attendees.dat".
    01 NumberKidsToArrive pic 99 value zero.
    01 NumberKidsOnSite pic 99 value zero.
    01 NumberOnSite pic 999 value zero.
    01 NumberToArrive pic 999 value zero.
    01 TotalAttendees pic 999 value zero.

procedure division using AttendeeFileName, by reference TotalAttendees, NumberOnSite, NumberToArrive, NumberKidsOnSite, NumberKidsToArrive.
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            evaluate true
                when AttendeeArrived of AttendeeRecord
                    add 1 to NumberOnSite
                    add NumberOfKids of AttendeeRecord to NumberKidsOnSite
                when AttendeeComing of AttendeeRecord
                    add 1 to NumberToArrive
                    add NumberOfKids of AttendeeRecord to NumberKidsToArrive
            end-evaluate
            add 1 to TotalAttendees
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile
    goback
    .

end program GetAttendeeStats.
