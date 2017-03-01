identification division.
program-id. GetFinancialStats is initial.

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
    01 TotalPaid pic 9(4) value zero.
    01 TotalToPay pic 9(4) value zero.

procedure division using AttendeeFileName, by reference TotalPaid, TotalToPay.
    initialize TotalPaid, TotalToPay
    open input AttendeesFile
        read AttendeesFile next record
            at end set EndOfAttendeesFile to true
        end-read
        perform until EndOfAttendeesFile
            evaluate true
                when AttendeePaid of AttendeeRecord
                    add AmountPaid of AttendeeRecord to TotalPaid
                when AttendeeNotPaid of AttendeeRecord
                    add AmountToPay of AttendeeRecord to TotalToPay
            end-evaluate
            read AttendeesFile next record
                at end set EndOfAttendeesFile to true
            end-read
        end-perform
    close AttendeesFile
    goback
    .

end program GetFinancialStats.
