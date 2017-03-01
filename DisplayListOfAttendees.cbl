identification division.
program-id. DisplayListOfAttendees is initial.

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

working-storage section.
    01 AttendeeStatus   pic x(2).
        88 Successful   value "00".
        88 RecordExists value "22".
        88 NoSuchRecord value "23".

linkage section.
    01 AttendeeFileName pic x(20) value "attendees.dat".

procedure division using AttendeeFileName.
    move zeroes to AuthCode of AttendeeRecord
    start AttendeesFile key is greater than AuthCode of AttendeeRecord
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            display AttendeeRecord
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile
    goback
    .

end program DisplayListOfAttendees.
