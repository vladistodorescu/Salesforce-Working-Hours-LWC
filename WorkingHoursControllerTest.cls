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

        String testStartHour5;
        String testEndHour5;
        String testStartHour6;
        String testEndHour6;

        Boolean result1;
        Boolean result2;
        Boolean result3;

        Test.startTest();
        result1 = WorkingHoursController.intervalsDontOverlapAndSenseful(testStartHour1, testEndHour1, testStartHour2, testEndHour2);
        result2 = WorkingHoursController.intervalsDontOverlapAndSenseful(testStartHour3, testEndHour3, testStartHour4, testEndHour4);
        result3 = WorkingHoursController.intervalsDontOverlapAndSenseful(testStartHour5, testEndHour5, testStartHour6, testEndHour6);
        Test.stopTest();

        Assert.areEqual(false, result1, 'For overlapping intervals, the result is false!');
        Assert.areEqual(false, result2, 'For not senseful intervals, the result is false!');
    }

    @isTest
    static void testSaveScheduleForEmptyMap(){
        Map<String, String> testMap = new Map<String, String>();

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }   
        catch(AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testSaveScheduleForNull(){
        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(null);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch(AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testSaveScheduleNoValidFirstInterval(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', '08:00');
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', '17:00');
        testMap.put('mondayEndSecondInterval', '13:00');
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', '05:00');
        testMap.put('tuesdayStartSecondInterval', '10:00');
        testMap.put('tuesdayEndSecondInterval', '10:00');
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch(AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertWorkingScheduleIfOneCorrectFirstInterval(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', '08:00');
        testMap.put('mondayEndFirstInterval', '09:00');
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        WorkingHoursController.storeSchedule(testMap);
        Test.stopTest();

        List<Working_Schedule__c> schedules = [SELECT Id FROM Working_Schedule__c];
        Assert.areEqual(1, schedules.size(), 'There should have been exactly one created Working_Schedule__c record!');

        List<Working_Day__c> workingDays = [SELECT Id, Working_Schedule__c FROM Working_Day__c];
        Assert.areEqual(1, workingDays.size(), 'There should have been exactly one created Working_Day__c record!');
        Assert.areEqual(workingDays[0].Working_Schedule__c, schedules[0].Id, 'The created Working_Day__c record is not related to the according Working_Schedule__c record!');
    }

    @isTest
    static void testInsertUnsensefulIntervalsMonday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', '08:00');
        testMap.put('mondayEndFirstInterval', '10:00');
        testMap.put('mondayStartSecondInterval', '09:00');
        testMap.put('mondayEndSecondInterval', '11:00');
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertUnsensefulIntervalsTuesday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', '14:00');
        testMap.put('tuesdayEndFirstInterval', '16:00');
        testMap.put('tuesdayStartSecondInterval', '15:00');
        testMap.put('tuesdayEndSecondInterval', '22:00');
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertUnsensefulIntervalsWednesday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', '08:00');
        testMap.put('wednesdayEndFirstInterval', '17:00');
        testMap.put('wednesdayStartSecondInterval', '14:00');
        testMap.put('wednesdayEndSecondInterval', '23:00');
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertUnsensefulIntervalsThursday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', '12:00');
        testMap.put('thursdayEndFirstInterval', '16:00');
        testMap.put('thursdayStartSecondInterval', '14:00');
        testMap.put('thursdayEndSecondInterval', '22:00');
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertUnsensefulIntervalsFriday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', '08:00');
        testMap.put('fridayEndFirstInterval', '10:00');
        testMap.put('fridayStartSecondInterval', '09:00');
        testMap.put('fridayEndSecondInterval', '10:00');

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertInvalidSecondIntervalMonday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', '08:00');
        testMap.put('mondayEndFirstInterval', '10:00');
        testMap.put('mondayStartSecondInterval', '12:00');
        testMap.put('mondayEndSecondInterval', '09:00');
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertInvalidSecondIntervalTuesday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', '14:00');
        testMap.put('tuesdayEndFirstInterval', '16:00');
        testMap.put('tuesdayStartSecondInterval', '22:00');
        testMap.put('tuesdayEndSecondInterval', '16:00');
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertInvalidSecondIntervalWednesday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', '08:00');
        testMap.put('wednesdayEndFirstInterval', '17:00');
        testMap.put('wednesdayStartSecondInterval', '23:00');
        testMap.put('wednesdayEndSecondInterval', '20:00');
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertInvalidSecondIntervalThursday(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', '12:00');
        testMap.put('thursdayEndFirstInterval', '16:00');
        testMap.put('thursdayStartSecondInterval', '23:00');
        testMap.put('thursdayEndSecondInterval', '17:00');
        testMap.put('fridayStartFirstInterval', null);
        testMap.put('fridayEndFirstInterval', null);
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertInvalidSecondIntervalFriday(){
        Map<String, String> testMap = new Map<String, String>();
        
        testMap.put('mondayStartFirstInterval', null);
        testMap.put('mondayEndFirstInterval', null);
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', null);
        testMap.put('tuesdayEndFirstInterval', null);
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', null);
        testMap.put('wednesdayEndFirstInterval', null);
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', null);
        testMap.put('thursdayEndFirstInterval', null);
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', '08:00');
        testMap.put('fridayEndFirstInterval', '13:00');
        testMap.put('fridayStartSecondInterval', '22:00');
        testMap.put('fridayEndSecondInterval', '18:00');

        Test.startTest();
        try{
            WorkingHoursController.storeSchedule(testMap);
            Assert.fail('Expected AuraHandledException, but none was thrown');
        }
        catch (AuraHandledException e){
            System.debug(e.getMessage());
            Assert.areEqual('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testInsertAllDaysWithOneValidInterval(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', '08:00');
        testMap.put('mondayEndFirstInterval', '10:00');
        testMap.put('mondayStartSecondInterval', null);
        testMap.put('mondayEndSecondInterval', null);
        testMap.put('tuesdayStartFirstInterval', '16:00');
        testMap.put('tuesdayEndFirstInterval', '18:00');
        testMap.put('tuesdayStartSecondInterval', null);
        testMap.put('tuesdayEndSecondInterval', null);
        testMap.put('wednesdayStartFirstInterval', '10:00');
        testMap.put('wednesdayEndFirstInterval', '13:00');
        testMap.put('wednesdayStartSecondInterval', null);
        testMap.put('wednesdayEndSecondInterval', null);
        testMap.put('thursdayStartFirstInterval', '12:00');
        testMap.put('thursdayEndFirstInterval', '17:00');
        testMap.put('thursdayStartSecondInterval', null);
        testMap.put('thursdayEndSecondInterval', null);
        testMap.put('fridayStartFirstInterval', '08:00');
        testMap.put('fridayEndFirstInterval', '13:00');
        testMap.put('fridayStartSecondInterval', null);
        testMap.put('fridayEndSecondInterval', null);

        Test.startTest();
        WorkingHoursController.storeSchedule(testMap);
        Test.stopTest();

        List<Working_Schedule__c> workingSchedule = [SELECT Id FROM Working_Schedule__c];
        Assert.areEqual(1, workingSchedule.size(), 'There should be exactly one Working_Schedule__c record inserted!');

        List<Working_Day__c> workingDays = [SELECT Id, Working_Schedule__c, Start_Hour__c, End_Hour__c FROM Working_Day__c];
        Assert.areEqual(5, workingDays.size(), 'There should be exactly five Working_Day__c records inserted!');

        for(Working_Day__c workingDay : workingDays){
            Assert.areEqual(workingSchedule[0].Id, workingDay.Working_Schedule__c, 'One of the Working_Day__c records is not linked to the correct Master record!');
        }

        Assert.areEqual('08:00', workingDays[0].Start_Hour__c, 'The start hour for the first interval on Monday has not been correctly inserted!');
        Assert.areEqual('10:00', workingDays[0].End_Hour__c, 'The end hour for the first interval on Monday has not been correctly inserted!');

        Assert.areEqual('16:00', workingDays[1].Start_Hour__c, 'The start hour for the first interval on Tuesday has not been correctly inserted!');
        Assert.areEqual('18:00', workingDays[1].End_Hour__c, 'The end hour for the first interval on Tuesday has not been correctly inserted!');

        Assert.areEqual('10:00', workingDays[2].Start_Hour__c, 'The start hour for the first interval on Wednesday has not been correctly inserted!');
        Assert.areEqual('13:00', workingDays[2].End_Hour__c, 'The end hour for the first interval on Wednesday has not been correctly inserted!');

        Assert.areEqual('12:00', workingDays[3].Start_Hour__c, 'The start hour for the first interval on Thursday has not been correctly inserted!');
        Assert.areEqual('17:00', workingDays[3].End_Hour__c, 'The end hour for the first interval on Thursday has not been correctly inserted!');

        Assert.areEqual('08:00', workingDays[4].Start_Hour__c, 'The start hour for the first interval on Friday has not been correctly inserted!');
        Assert.areEqual('13:00', workingDays[4].End_Hour__c, 'The end hour for the first interval on Friday has not been correctly inserted!');
    }

    @isTest
    static void testInsertAllDaysWithTwoValidAndSensefulIntervals(){
        Map<String, String> testMap = new Map<String, String>();

        testMap.put('mondayStartFirstInterval', '08:00');
        testMap.put('mondayEndFirstInterval', '10:00');
        testMap.put('mondayStartSecondInterval', '12:00');
        testMap.put('mondayEndSecondInterval', '18:00');
        testMap.put('tuesdayStartFirstInterval', '16:00');
        testMap.put('tuesdayEndFirstInterval', '18:00');
        testMap.put('tuesdayStartSecondInterval', '19:00');
        testMap.put('tuesdayEndSecondInterval', '22:00');
        testMap.put('wednesdayStartFirstInterval', '10:00');
        testMap.put('wednesdayEndFirstInterval', '13:00');
        testMap.put('wednesdayStartSecondInterval', '14:00');
        testMap.put('wednesdayEndSecondInterval', '22:00');
        testMap.put('thursdayStartFirstInterval', '12:00');
        testMap.put('thursdayEndFirstInterval', '17:00');
        testMap.put('thursdayStartSecondInterval', '20:00');
        testMap.put('thursdayEndSecondInterval', '22:00');
        testMap.put('fridayStartFirstInterval', '08:00');
        testMap.put('fridayEndFirstInterval', '13:00');
        testMap.put('fridayStartSecondInterval', '14:00');
        testMap.put('fridayEndSecondInterval', '21:00');

        Test.startTest();
        WorkingHoursController.storeSchedule(testMap);
        Test.stopTest();

        List<Working_Schedule__c> workingSchedule = [SELECT Id FROM Working_Schedule__c];
        Assert.areEqual(1, workingSchedule.size(), 'There should be exactly one Working_Schedule__c record inserted!');

        List<Working_Day__c> workingDays = [SELECT Id, Working_Schedule__c, Start_Hour__c, End_Hour__c, Start_Hour_2nd_Interval__c, End_Hour_2nd_Interval__c FROM Working_Day__c];
        Assert.areEqual(5, workingDays.size(), 'There should be exactly five Working_Day__c records inserted!');

        for(Working_Day__c workingDay : workingDays){
            Assert.areEqual(workingSchedule[0].Id, workingDay.Working_Schedule__c, 'One of the Working_Day__c records is not linked to the correct Master record!');
        }

        Assert.areEqual('08:00', workingDays[0].Start_Hour__c, 'The start hour for the first interval on Monday has not been correctly inserted!');
        Assert.areEqual('10:00', workingDays[0].End_Hour__c, 'The end hour for the first interval on Monday has not been correctly inserted!');
        Assert.areEqual('12:00', workingDays[0].Start_Hour_2nd_Interval__c, 'The start hour for the second interval on Monday has not been correctly inserted!');
        Assert.areEqual('18:00', workingDays[0].End_Hour_2nd_Interval__c, 'The end hour for the second interval on Monday has not been correctly inserted!');

        Assert.areEqual('16:00', workingDays[1].Start_Hour__c, 'The start hour for the first interval on Tuesday has not been correctly inserted!');
        Assert.areEqual('18:00', workingDays[1].End_Hour__c, 'The end hour for the first interval on Tuesday has not been correctly inserted!');
        Assert.areEqual('19:00', workingDays[1].Start_Hour_2nd_Interval__c, 'The start hour for the second interval on Tuesday has not been correctly inserted!');
        Assert.areEqual('22:00', workingDays[1].End_Hour_2nd_Interval__c, 'The end hour for the second interval on Tuesday has not been correctly inserted!');

        Assert.areEqual('10:00', workingDays[2].Start_Hour__c, 'The start hour for the first interval on Wednesday has not been correctly inserted!');
        Assert.areEqual('13:00', workingDays[2].End_Hour__c, 'The end hour for the first interval on Wednesday has not been correctly inserted!');
        Assert.areEqual('14:00', workingDays[2].Start_Hour_2nd_Interval__c, 'The start hour for the second interval on Wednesday has not been correctly inserted!');
        Assert.areEqual('22:00', workingDays[2].End_Hour_2nd_Interval__c, 'The end hour for the second interval on Wednesday has not been correctly inserted!');

        Assert.areEqual('12:00', workingDays[3].Start_Hour__c, 'The start hour for the first interval on Thursday has not been correctly inserted!');
        Assert.areEqual('17:00', workingDays[3].End_Hour__c, 'The end hour for the first interval on Thursday has not been correctly inserted!');
        Assert.areEqual('20:00', workingDays[3].Start_Hour_2nd_Interval__c, 'The start hour for the second interval on Thursday has not been correctly inserted!');
        Assert.areEqual('22:00', workingDays[3].End_Hour_2nd_Interval__c, 'The end hour for the second interval on Thursday has not been correctly inserted!');

        Assert.areEqual('08:00', workingDays[4].Start_Hour__c, 'The start hour for the first interval on Friday has not been correctly inserted!');
        Assert.areEqual('13:00', workingDays[4].End_Hour__c, 'The end hour for the first interval on Friday has not been correctly inserted!');
        Assert.areEqual('14:00', workingDays[4].Start_Hour_2nd_Interval__c, 'The start hour for the second interval on Friday has not been correctly inserted!');
        Assert.areEqual('21:00', workingDays[4].End_Hour_2nd_Interval__c, 'The end hour for the second interval on Friday has not been correctly inserted!');
    }

}
