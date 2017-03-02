copy crt-key-codes.

identification division.
program-id. EditScreen is initial.

environment division.
configuration section.
    special-names.
        crt status is Operation.
        class HexNumber is "0" thru "9", "A" thru "F", "a" thru "f".

    repository.
        function createAuthCode.

data division.
local-storage section.
    01 Command pic x.

    01 CurrentDayOfWeek pic 9 value zero.
    01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
        02 DayOfTheWeek pic x(3) occurs 7 times.

    copy Operation.

    01 AddAttendeeFlag pic 9 value 0.
        88 AddAttendeeFlagOn value 1 when set to false is 0.

    01 AttendeesFileName pic x(20) value "attendees.dat".

linkage section.
    copy Attendee.

screen section.
    01 EditAttendeeScreen background-color 0 foreground-color 2.
        03 blank screen.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video highlight.
        03 line 2 column 1 value "AuthCode:".
        03 line 2 column 15 from AuthCode.
        03 line 4 column 1 value "Name:".
        03 line 4 column 15 using Name required.
        03 line 6 column 1 value "Email:".
        03 line 6 column 15 using Email.
        03 line 8 column 1 value "Telephone:".
        03 line 8 column 15 using Telephone.
        03 line 10 column 1 value "Arrival day:".
        03 line 10 column 15 from ArrivalDay.
        03 line 10 column plus 2 value "(Wed/Thu/Fri/Sat)".
        03 line 12 column 1 value "Status:".
        03 line 12 column 15 from AttendanceStatus.
        03 line 12 column plus 2 value "(A = arrived, C = coming, X = cancelled)".
        03 line 14 column 1 value "Kids:".
        03 pic 9 line 14 column 15 using NumberOfKids required.
        03 line 16 column 1 value "Pay amount:".
        03 pic 999 line 16 column 15 using AmountToPay required full.
        03 line 18 column 1 value "Paid?:".
        03 line 18 column 15 from PaymentStatus.
        03 line 20 column 1 value "Diet issues:".
        03 line 20 column 15 using Diet.
        03 line 24 column 1 value "Commands: F1 Home; Toggle: F5 Arrival, F6 Status, F7 Paid; F8 Save, F10 Exit  " reverse-video highlight.
        03 line 24 column 78 to Command.

procedure division using Attendee.

    if AuthCode of Attendee not equal to "000000" then
        set AddAttendeeFlagOn to false
    end-if

    perform until OperationIsBack or OperationIsExit or OperationIsSave
        accept EditAttendeeScreen from crt end-accept
        evaluate true
            when OperationIsSave
                evaluate true
                    when AddAttendeeFlagOn call "AddAttendee" using by content AttendeesFileName, Attendee
                    when not AddAttendeeFlagOn call "UpdateAttendee" using by content AttendeesFileName, Attendee
                end-evaluate
            when OperationIsTogglePaid
                evaluate true
                    when AttendeePaid set AttendeeNotPaid to true
                    when AttendeeNotPaid set AttendeePaid to true
                end-evaluate
            when OperationIsToggleArrivalDay
                evaluate true
                    when ArrivalDayIsWednesday set ArrivalDayIsThursday to true
                    when ArrivalDayIsThursday set ArrivalDayIsFriday to true
                    when ArrivalDayIsFriday set ArrivalDayIsSaturday to true
                    when ArrivalDayIsSaturday set ArrivalDayIsWednesday to true
                end-evaluate
            when OperationIsToggleStatus
                evaluate true
                    when AttendeeComing set AttendeeArrived to true
                    when AttendeeArrived set AttendeeCancelled to true
                    when AttendeeCancelled set AttendeeComing to true
                end-evaluate
        end-evaluate
    end-perform
    goback
.

end program EditScreen.
