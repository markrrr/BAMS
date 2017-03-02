identification division.
program-id. AddScreen is initial.

environment division.
configuration section.
    repository.
        function createAuthCode.

data division.
working-storage section.
    copy Attendee.
    01 CurrentDayOfWeek pic 9 value zero.
    01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
        02 DayOfTheWeek pic x(3) occurs 7 times.

procedure division.

    initialize Attendee
    move createAuthCode to AuthCode of Attendee
    accept CurrentDayOfWeek from day-of-week
    move DayOfTheWeek(CurrentDayOfWeek) to ArrivalDay of Attendee
    set AttendeeArrived of Attendee to true
    set AttendeeNotPaid of Attendee to true
    move 40 to AmountToPay
    call "EditScreen" using by content Attendee
    goback
.

end program AddScreen.
