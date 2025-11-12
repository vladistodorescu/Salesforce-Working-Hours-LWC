@isTest
private class WorkingHoursControllerTest {

    @isTest
    static void testIsValidIntervalForValidInterval() {
        String testStartHour = '08:00';
        String testEndHour = '12:00';

        Boolean result;

        Test.startTest();
        result = WorkingHoursController.isValidInterval(testStartHour, testEndHour);
        Test.stopTest();

        Assert.areEqual(true, result, 'For a valid interval, the result is true!');
    }

    @isTest
    static void testIsValidIntervalForInvalidIntervals(){
        String testStartHour1 = '12:00';
        String testEndHour1 = '08:00';

        String testStartHour2 = '11:00';
        String testEndHour2 = '11:00';

        Boolean result1;
        Boolean result2;

        Test.startTest();
        result1 = WorkingHoursController.isValidInterval(testStartHour1, testEndHour1);
        result2 = WorkingHoursController.isValidInterval(testStartHour2, testEndHour2);
        Test.stopTest();

        Assert.areEqual(false, result1, 'For an invalid interval (a > b), the result is false!');
        Assert.areEqual(false, result2, 'For an invalid interval (a = b), the result is false!');
    }

    @isTest
    static void testIntervalsDontOverlapAndSensefulForValidIntervals(){
        String testStartHour1 = '08:00';
        String testEndHour1 = '12:00';

        String testStartHour2 = '13:00';
        String testEndHour2 = '17:00';

        Boolean result;

        Test.startTest();
        result = WorkingHoursController.intervalsDontOverlapAndSenseful(testStartHour1, testEndHour1, testStartHour2, testEndHour2);
        Test.stopTest();

        Assert.areEqual(true, WorkingHoursController.intervalsDontOverlapAndSenseful(testStartHour1, testEndHour1, testStartHour2, testEndHour2), 'For not overlapping and senseful intervals, the result is true!');
    }

    @isTest
    static void testIntervalsDontOverlapAndSensefulForInvalidIntervals(){
        String testStartHour1 = '08:00';
        String testEndHour1 = '12:00';

        String testStartHour2 = '11:00';
        String testEndHour2 = '13:00';

        String testStartHour3 = '13:00';
        String testEndHour3 = '17:00';

        String testStartHour4 = '08:00';
        String testEndHour4 = '12:00';

        Boolean result1;
        Boolean result2;

        Test.startTest();
        result1 = WorkingHoursController.intervalsDontOverlapAndSenseful(testStartHour1, testEndHour1, testStartHour2, testEndHour2);
        result2 = WorkingHoursController.intervalsDontOverlapAndSenseful(testStartHour3, testEndHour3, testStartHour4, testEndHour4);
        Test.stopTest();

        Assert.areEqual(false, result1, 'For overlapping intervals, the result is false!');
        Assert.areEqual(false, result2, 'For not senseful intervals, the result is false!');
    }
}
