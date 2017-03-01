identification division.
program-id. GetAttendeeByAuthCode is initial.

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
    01 ThisAuthCode pic x(6) value all "0".
    copy Attendee replacing Attendee by ==AttendeeRecordReturned==.

procedure division using AttendeeFileName, ThisAuthCode, by reference AttendeeRecordReturned.

    open input AttendeesFile
        move ThisAuthCode to AuthCode of AttendeeRecord
        read AttendeesFile record into AttendeeRecord
            key is AuthCode of AttendeeRecord
            invalid key display "Record for " ThisAuthCode " not found"
        end-read
    close AttendeesFile
    move AttendeeRecord to AttendeeRecordReturned
    goback
    .

end program GetAttendeeByAuthCode.
