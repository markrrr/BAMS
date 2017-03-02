copy crt-key-codes.

identification division.
program-id. HomeScreen is initial.

environment division.
configuration section.
    special-names.
        crt status is Operation.

data division.
local-storage section.
    01 BarnCampStats.
        02 PeopleOnSite pic 999 value zero.
        02 PeopleSignedUp pic 999 value zero.
        02 PeopleToArrive pic 999 value zero.
        02 PeopleToArriveToday pic 999 value zero.
        02 KidsOnSite pic 99 value zero.
        02 KidsToArrive pic 99 value zero.
        02 KidsToArriveToday pic 99 value zero.
        02 NumberOfCancellations pic 99 value zero.
        02 TotalEstimatedAttendees pic 999 value zero.
        02 TotalEstimatedKids pic 99 value zero.

    01 Command pic x.
    01 CurrentDayOfWeek pic 9 value zero.
    01 DaysOfTheWeek value "MonTueWedThuFriSatSun".
        02 DayOfTheWeek pic x(3) occurs 7 times.

    copy Operation.

    01 AttendeesFileName pic x(20) value "attendees.dat".

screen section.
    01 HomeScreen background-color 0 foreground-color 2 highlight.
        03 blank screen background-color 0 foreground-color 5.
        03 line 1 column 1 value "    BarnCamp Attendee Management System v1.0   (c) copyleft 2017 HacktionLab    " reverse-video.
        03 line 5 column 34 value "Welcome to BAMS" underline.
        03 line 7 column 36 value "Today is ".
        03 line 7 column plus 1 from DayOfTheWeek(CurrentDayOfWeek).
        03 line 10 column 5 value "People on site: ".
        03 pic zzz9 line 10 column plus 3 from PeopleOnSite.
        03 line 11 column 5 value "People to arrive: ".
        03 pic zzz9 line 11 column plus 1 from PeopleToArrive.
        03 line 12 column 5 value "                " underline.
        03 line 13 column 5 value "Total attendees: ".
        03 pic zzz9 line 13 column plus 2 from TotalEstimatedAttendees.
        03 line 16 column 5 value "To arrive today: ".
        03 pic zzz9 line 16 column plus 2 from PeopleToArriveToday.
        03 line 10 column 50 value "Kids on-site: ".
        03 pic z9 line 10 column plus 5 from KidsOnSite.
        03 line 11 column 50 value "Kids to arrive: ".
        03 pic z9 line 11 column plus 3 from KidsToArrive.
        03 line 12 column 50 value "           " underline.
        03 line 13 column 50 value "Total kids:".
        03 pic z9 line 13 column plus 8 from TotalEstimatedKids.
        03 line 16 column 45 value "Kids to arrive today: ".
        03 pic z9 line 16 column plus 2 from KidsToArriveToday.
        03 line 24 column 1 value "Commands: F2 View, F3 Add, F10 Exit                                           " reverse-video.
        03 line 24 column 78 to Command.

procedure division.
    perform until OperationIsExit
        call "GetAttendeeStats"
            using by content AttendeesFileName,
            by reference PeopleSignedUp, PeopleOnSite, PeopleToArrive, KidsOnSite, KidsToArrive
        add PeopleToArrive to PeopleOnSite giving TotalEstimatedAttendees
        add KidsToArrive to KidsOnSite giving TotalEstimatedKids

        accept CurrentDayOfWeek from day-of-week
        call "ThoseToArriveOnDay"
            using by content AttendeesFileName,
            by content DayOfTheWeek(CurrentDayOfWeek),
            by reference PeopleToArriveToday, KidsToArriveToday
        accept HomeScreen from crt end-accept
        evaluate true
            when OperationIsView call "ViewScreen"
            when OperationIsAdd  call "AddScreen"
        end-evaluate
    end-perform

    goback
    .

end program HomeScreen.
