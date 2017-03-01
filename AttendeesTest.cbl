identification division.
program-id. AttendeesTest.

environment division.
configuration section.
    repository.
        function all intrinsic
        function createAuthCode.

data division.
working-storage section.

    copy Attendee replacing Attendee by AttendeeExpected.
    copy Attendee replacing Attendee by AttendeeReturned.

    01 AttendeesFileName pic x(20) value "attendees-test.dat".
    01 SourceFileName pic x(20) value spaces.

    01 AttendeesToArriveReturned pic 999 value zero.
    01 AttendeesOnSiteReturned pic 999 value zero.
    01 NewAuthCode      pic x(6) value all "0".
    01 NumberOfAttendeesReturned pic 999 value zero.
    01 NumberOfKidsOnSiteReturned pic 99 value zero.
    01 NumberOfKidsReturned pic 99 value zero.
    01 NumberOfKidsToArriveReturned pic 99 value zero.
    01 TotalPaidReturned pic 9(4) value zero.
    01 TotalToPayReturned pic 9(4) value zero.

procedure division.

SetupInitialData.
    initialize AttendeeExpected
    .

InitialiseAttendeesFile.
    call "C$COPY" using "test-data.dat", "attendees-test.dat", 0
    .

TestListAttendees.
    call "DisplayListOfAttendees" using by content AttendeesFileName
    .

TestImportedRecordExists.
    *> Given
    move "ABCDEF" to AuthCode of AttendeeExpected
    move "Zak Mindwarp" to Name of AttendeeExpected.
    move "zak@mindwarp.io" to Email of AttendeeExpected.
    move "01234 567 890" to Telephone of AttendeeExpected.
    move 50 to AmountToPay of AttendeeExpected.
    set AttendeePaid of AttendeeExpected to true.
    move 50 to AmountPaid of AttendeeExpected.
    move "20170101" to DatePaid of AttendeeExpected.
    set AttendeeComing of AttendeeExpected to true.
    set ArrivalDayIsWednesday of AttendeeExpected to true.
    move 0 to NumberOfKids of AttendeeExpected.
    move "I eat anything" to Diet of AttendeeExpected.

    *> When
    call "GetAttendeeByAuthCode"
        using by content AttendeesFileName,
        by content AuthCode of AttendeeExpected,
        by reference AttendeeReturned

    *> Then
    call "AssertEquals" using by content AttendeeReturned, by content AttendeeExpected
        by content "TestImportedRecordExists: Result returns the correct details for first Attendee"
    .

TestShouldUpdateAttendeeDetails.
    *> Given
    call "GetAttendeeByAuthCode"
        using by content AttendeesFileName,
        by content "EF1234",
        by reference AttendeeReturned

    move "Cover Broken" to Name of AttendeeReturned
    call "UpdateAttendee"
        using by content AttendeesFileName,
        by content AttendeeReturned

    *> When
    call "GetAttendeeByAuthCode"
        using by content AttendeesFileName,
        by content AuthCode of AttendeeExpected,
        by reference AttendeeReturned

    *> Then
    call "AssertEquals" using by content AttendeeReturned, by content AttendeeExpected
        by content "TestShouldUpdateAttendeeDetails: Result returns the correct details for added Attendee with AuthCode of " NewAuthCode
    .

TestCanAddAttendee.
    *> Given
    initialize AttendeeExpected
    move "Jose Cuervo" to Name of AttendeeExpected
    move "jose@cuervo.es" to Email of AttendeeExpected
    move 3 to NumberOfKids of AttendeeExpected
    set ArrivalDayIsWednesday of AttendeeExpected to true
    move createAuthCode() to AuthCode of AttendeeExpected
    set AttendeeComing of AttendeeExpected to true

    call "AddAttendee"
        using by content AttendeesFileName,
        by content AttendeeExpected

    *> When
    call "GetAttendeeByAuthCode"
        using by content AttendeesFileName,
        by content AuthCode of AttendeeExpected,
        by reference AttendeeReturned

    *> Then
    call "AssertEquals" using by content AttendeeReturned, by content AttendeeExpected
        by content "TestCanAddAnotherAttendee: Result returns the correct details for added Attendee"
    .

TestAttendeeStats.
    *> Given
    call "GetAttendeeByAuthCode"
        using by content AttendeesFileName,
        by content "CDEF12",
        by reference AttendeeReturned
    set AttendeeArrived of AttendeeReturned to true
    call "UpdateAttendee"
        using by content AttendeesFileName,
        by content AttendeeReturned

    *> When
    call "GetAttendeeStats"
        using by content AttendeesFileName,
        by reference
            NumberOfAttendeesReturned, AttendeesOnSiteReturned, AttendeesToArriveReturned,
            NumberOfKidsOnSiteReturned, NumberOfKidsToArriveReturned

    *> Then
    call "AssertEquals" using by content NumberOfAttendeesReturned, by content 8,
        by content "TestAttendeeStats: Correct TOTAL number of attendees returned: 8".

    call "AssertEquals" using by content AttendeesOnSiteReturned, by content 1,
        by content "TestAttendeeStats: Correct number of attendees ON-Site returned: 1".

    call "AssertEquals" using by content AttendeesToArriveReturned, by content 7,
        by content "TestAttendeeStats: Correct number of attendees TO ARRIVE returned: 7".

    call "AssertEquals" using by content NumberOfKidsToArriveReturned, by content 4,
        by content "TestAttendeeStats: Correct number of kids TO ARRIVE returned: 4".

    call "AssertEquals" using by content NumberOfKidsOnSiteReturned, by content 2,
        by content "TestAttendeeStats: Correct number of kids On-Site returned: 2".

TestFetchAttendeesToArriveOnDay.
    *> Given/When
    call "GetAttendeesToArriveOnDay"
        using by content AttendeesFileName,
        by content "Wed"
        by reference AttendeesToArriveReturned, NumberOfKidsToArriveReturned

    *> Then
    call "AssertEquals" using by content AttendeesToArriveReturned by content 3
        by content "TestFetchAttendeesToArriveOnDay: Correct number of attendees returned for Wednesday arrivals"

    call "AssertEquals" using by content NumberOfKidsToArriveReturned by content 3
        by content "TestFetchAttendeesToArriveOnDay: Correct number of kids returned for Wednesday arrivals"

    *> Given/When
    call "GetAttendeesToArriveOnDay"
        using by content AttendeesFileName,
        by content "Fri"
        by reference AttendeesToArriveReturned, NumberOfKidsToArriveReturned

    *> Then
    call "AssertEquals" using by content AttendeesToArriveReturned by content 4
        by content "TestFetchAttendeesToArriveOnDay: Correct number of attendees returned for Friday arrivals"

    call "AssertEquals" using by content NumberOfKidsToArriveReturned by content 1
        by content "TestFetchAttendeesToArriveOnDay: Correct number of kids returned for Friday arrivals"
    .

TestCanFetchTotalOfMoney.
    *> Given/When
    call "GetFinancialStats"
        using by content AttendeesFileName,
        by reference TotalPaidReturned, TotalToPayReturned

    *> Then
    call "AssertEquals" using by content TotalPaidReturned by content 50
        by content "TestCanFetchTotalOfMoney: Correct amount of money paid returned"

    *> Then
    call "AssertEquals" using by content TotalToPayReturned by content 225
        by content "TestCanFetchTotalOfMoney: Correct amount of money to pay returned"
    .

EndTests.
    call "DisplayListOfAttendees" using by content AttendeesFileName
    stop run.

end program AttendeesTest.
