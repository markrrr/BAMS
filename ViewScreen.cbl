copy crt-key-codes.

identification division.
program-id. ViewScreen is initial.

environment division.
configuration section.
    special-names.
        crt status is Operation.
        class HexNumber is "0" thru "9", "A" thru "F", "a" thru "f".

data division.
local-storage section.
    copy Attendee.
    01 AttendeesFileName pic x(20) value "attendees.dat".
    01 Command pic x.
    copy Operation.

screen section.
    01 ViewAttendeeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 from Name.
        03 line 6 column 1 value "Email:".
        03 line 6 column 15 from Email.
        03 line 8 column 1 value "Telephone:".
        03 line 8 column 15 from Telephone.
        03 line 10 column 1 value "Arrival day:".
        03 line 10 column 15 from ArrivalDay.
        03 line 12 column 1 value "Status:".
        03 line 12 column 15 from AttendanceStatus.
        03 line 14 column 1 value "Kids:".
        03 line 14 column 15 from NumberOfKids.
        03 line 16 column 1 value "Pay amount:".
        03 pic 999 line 16 column 15 from AmountToPay.
        03 line 18 column 1 value "Paid?:".
        03 line 18 column 15 from PaymentStatus.
        03 line 20 column 1 value "Diet issues:".
        03 line 20 column 15 from Diet.
        03 line 24 column 1 value "Commands: F1 Home, F4 Edit, F10 Exit                                         " reverse-video highlight.
        03 line 24 column 78 to Command.

    01 SearchByAuthCodeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 2 column 1 value "Enter AuthCode and press enter, F2 to find:".
        03 line 2 column plus 2 to AuthCode required.
        03 line 24 column 1 value "Commands: F1 Home, F2 Find, F10 Exit - type in authcode and press ENTER               " reverse-video highlight.

procedure division.

    initialize Attendee
    perform SearchAttendee

    call "AttendeeByAuthCode"
        using by content AttendeesFileName,
        by content Authcode of Attendee,
        by reference Attendee

    if Name of Attendee is equal to high-values or AuthCode is not HexNumber then
        display "Invalid authcode or authcode not found"
    else
        perform until OperationIsBack or OperationIsExit
            accept ViewAttendeeScreen from crt end-accept
            evaluate true
                when OperationIsEdit call "EditScreen" using by content Attendee
            end-evaluate
        end-perform
    end-if

    goback
.

SearchAttendee section.
    move spaces to AuthCode
    accept SearchByAuthCodeScreen from crt end-accept
    evaluate true
        when OperationIsView call "ListAttendeesScreen" using by reference Authcode of Attendee
        when other move function upper-case(AuthCode) to AuthCode
    end-evaluate
.

end program ViewScreen.
