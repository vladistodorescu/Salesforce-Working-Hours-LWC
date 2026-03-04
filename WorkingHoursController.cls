public with sharing class WorkingHoursController {

    @AuraEnabled
    public static void storeSchedule(Map<String, String> workingIntervals){
        if (workingIntervals == null || workingIntervals.isEmpty()){
            throw new AuraHandledException('The Intervals Map is empty!');
        }
        
        Working_Day__c monday = new Working_Day__c();
        Working_Day__c tuesday = new Working_Day__c();
        Working_Day__c wednesday = new Working_Day__c();
        Working_Day__c thursday = new Working_Day__c();
        Working_Day__c friday = new Working_Day__c();

        Working_Schedule__c workingSchedule = new Working_Schedule__c();

        List<Working_Day__c> workingDaysToInsert = new List<Working_Day__c>();

        for (String key : workingIntervals.keySet()){
            String value = workingIntervals.get(key);
            // check key for day, start/end and first/second Interval, then if value not null, assign to Working_Day__c the value
            if (key != null && key.contains('monday')){
                if (key.contains('FirstInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            monday.Start_Hour__c = value;
                        }

                    }
                    if (key.contains('End')){
                        if(workingIntervals.get(key) != null){
                            monday.End_Hour__c = value;
                        }
                    }
                }

                if (key.contains('SecondInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            monday.Start_Hour_2nd_Interval__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            monday.End_Hour_2nd_Interval__c = value;
                        }
                    }
                }
            }

            if (key != null && key.contains('tuesday')){
                if (key.contains('FirstInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            tuesday.Start_Hour__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            tuesday.End_Hour__c = value;
                        }
                    }
                }
                if (key.contains('SecondInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            tuesday.Start_Hour_2nd_Interval__c = value;
                        }
                    }
                    if(key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            tuesday.End_Hour_2nd_Interval__c = value;
                        }
                    }
                }
            }

            if (key != null && key.contains('wednesday')){
                if (key.contains('FirstInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            wednesday.Start_Hour__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            wednesday.End_Hour__c = value;
                        }
                    }
                }

                if (key.contains('SecondInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            wednesday.Start_Hour_2nd_Interval__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            wednesday.End_Hour_2nd_Interval__c = value;
                        }
                    }
                }
            }

            if (key != null && key.contains('thursday')){
                if (key.contains('FirstInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            thursday.Start_Hour__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            thursday.End_Hour__c = value;
                        }
                    }
                }

                if (key.contains('SecondInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            thursday.Start_Hour_2nd_Interval__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            thursday.End_Hour_2nd_Interval__c = value;
                        }
                    }
                }
            }

            if (key != null && key.contains('friday')){
                if (key.contains('FirstInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            friday.Start_Hour__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            friday.End_Hour__c = value;
                        }
                    }
                }

                if (key.contains('SecondInterval')){
                    if (key.contains('Start')){
                        if (workingIntervals.get(key) != null){
                            friday.Start_Hour_2nd_Interval__c = value;
                        }
                    }
                    if (key.contains('End')){
                        if (workingIntervals.get(key) != null){
                            friday.End_Hour_2nd_Interval__c = value;
                        }
                    }
                }
            }
        }

        // only insert the Working_Schedule__c record, if we have at least one valid first interval
        if (isValidInterval(monday.Start_Hour__c, monday.End_Hour__c) || 
            isValidInterval(tuesday.Start_Hour__c, tuesday.End_Hour__c) || 
            isValidInterval(wednesday.Start_Hour__c, wednesday.End_Hour__c) || 
            isValidInterval(thursday.Start_Hour__c, thursday.End_Hour__c) ||
            isValidInterval(friday.Start_Hour__c, friday.End_Hour__c)){
                // assign the timezone of current running user
                String timezoneID = UserInfo.getTimeZone().getID();
                for (Schema.PicklistEntry pe : Working_Schedule__c.Timezone__c.getDescribe().getPicklistValues()){
                    if (pe.getValue() == timezoneID){
                        workingSchedule.Timezone__c = pe.getValue();
                        break;
                    } 
                }

                // assign running user to the schedule
                workingSchedule.User_Lookup__c = UserInfo.getUserId();

                insert workingSchedule;
        }
        else{
            throw new AuraHandledException('At least one of the first Intervals must be filled and valid, in order to save the schedule!');
        }

        // verify if 1st interval for the day is valid, if not move on to next day
        // if it's valid, verify if we have values for 2nd Interval, if not continue to inserting the 1st Interval
        // if we have values for the 2nd Interval, verify if valid Interval, if not throw exception
        // if it's valid verify the Intervals don't overlap and are senseful, if not throw exception
        // if 2nd Interval meets the criterias, insert it as well
        if (isValidInterval(monday.Start_Hour__c, monday.End_Hour__c)){
            if (monday.Start_Hour_2nd_Interval__c != null && monday.End_Hour_2nd_Interval__c != null){
                if (isValidInterval(monday.Start_Hour_2nd_Interval__c, monday.End_Hour_2nd_Interval__c)){
                    if (intervalsDontOverlapAndSenseful(monday.Start_Hour__c, monday.End_Hour__c, monday.Start_Hour_2nd_Interval__c, monday.End_Hour_2nd_Interval__c)){
                        monday.Day_In_The_Week__c = 'Monday';
                        monday.Working_Schedule__c = workingSchedule.Id;
                        workingDaysToInsert.add(monday);
                    }
                    else{
                        throw new AuraHandledException('The 2 intervals of Monday must be senseful and not overlap, in order to save the schedule!');
                    }
                }
                else{
                    throw new AuraHandledException('The 2nd Interval of Monday is not valid!');
                }
            }
            else{
                monday.Day_In_The_Week__c = 'Monday';
                monday.Working_Schedule__c = workingSchedule.Id;
                workingDaysToInsert.add(monday);
            }
        }
        if (isValidInterval(tuesday.Start_Hour__c, tuesday.End_Hour__c)){
            if (tuesday.Start_Hour_2nd_Interval__c != null && tuesday.End_Hour_2nd_Interval__c != null){
                if (isValidInterval(tuesday.Start_Hour_2nd_Interval__c, tuesday.End_Hour_2nd_Interval__c)){
                    if (intervalsDontOverlapAndSenseful(tuesday.Start_Hour__c, tuesday.End_Hour__c, tuesday.Start_Hour_2nd_Interval__c, tuesday.End_Hour_2nd_Interval__c)){
                        tuesday.Day_In_The_Week__c = 'Tuesday';
                        tuesday.Working_Schedule__c = workingSchedule.Id;
                        workingDaysToInsert.add(tuesday);
                    }
                    else{
                        throw new AuraHandledException('The 2 intervals of Tuesday must be senseful and not overlap, in order to save the schedule!');
                    }
                }
                else{
                    throw new AuraHandledException('The 2nd Interval of Tuesday is not valid!');
                }
            }
            else{
                tuesday.Day_In_The_Week__c = 'Tuesday';
                tuesday.Working_Schedule__c = workingSchedule.Id;
                workingDaysToInsert.add(tuesday);
            }
        }
        if (isValidInterval(wednesday.Start_Hour__c, wednesday.End_Hour__c)){
            if (wednesday.Start_Hour_2nd_Interval__c != null && wednesday.End_Hour_2nd_Interval__c != null){
                if (isValidInterval(wednesday.Start_Hour_2nd_Interval__c, wednesday.End_Hour_2nd_Interval__c)){
                    if (intervalsDontOverlapAndSenseful(wednesday.Start_Hour__c, wednesday.End_Hour__c, wednesday.Start_Hour_2nd_Interval__c, wednesday.End_Hour_2nd_Interval__c)){
                        wednesday.Day_In_The_Week__c = 'Wednesday';
                        wednesday.Working_Schedule__c = workingSchedule.Id;
                        workingDaysToInsert.add(wednesday);
                    }
                    else{
                        throw new AuraHandledException('The 2 intervals of Wednesday must be senseful and not overlap, in order to save the schedule!');
                    }
                }
                else{
                    throw new AuraHandledException('The 2nd Interval of Wednesday is not valid!');
                }
            }
            else{
                wednesday.Day_In_The_Week__c = 'Wednesday';
                wednesday.Working_Schedule__c = workingSchedule.Id;
                workingDaysToInsert.add(wednesday);
            }  
        }
        if (isValidInterval(thursday.Start_Hour__c, thursday.End_Hour__c)){
            if (thursday.Start_Hour_2nd_Interval__c != null && thursday.End_Hour_2nd_Interval__c != null){
                if (isValidInterval(thursday.Start_Hour_2nd_Interval__c, thursday.End_Hour_2nd_Interval__c)){
                    if (intervalsDontOverlapAndSenseful(thursday.Start_Hour__c, thursday.End_Hour__c, thursday.Start_Hour_2nd_Interval__c, thursday.End_Hour_2nd_Interval__c)){
                        thursday.Day_In_The_Week__c = 'Thursday';
                        thursday.Working_Schedule__c = workingSchedule.Id;
                        workingDaysToInsert.add(thursday);
                    }
                    else{
                        throw new AuraHandledException('The 2 intervals of Thursday must be senseful and not overlap, in order to save the schedule!');
                    }
                }
                else{
                    throw new AuraHandledException('The 2nd Interval of Thursday is not valid!');
                }
            }
            else{
                thursday.Day_In_The_Week__c = 'Thursday';
                thursday.Working_Schedule__c = workingSchedule.Id;
                workingDaysToInsert.add(thursday);
            }  
        }
        if (isValidInterval(friday.Start_Hour__c, friday.End_Hour__c)){
            if (friday.Start_Hour_2nd_Interval__c != null && friday.End_Hour_2nd_Interval__c != null){
                if (isValidInterval(friday.Start_Hour_2nd_Interval__c, friday.End_Hour_2nd_Interval__c)){
                    if (intervalsDontOverlapAndSenseful(friday.Start_Hour__c, friday.End_Hour__c, friday.Start_Hour_2nd_Interval__c, friday.End_Hour_2nd_Interval__c)){
                        friday.Day_In_The_Week__c = 'Friday';
                        friday.Working_Schedule__c = workingSchedule.Id;
                        workingDaysToInsert.add(friday);
                    }
                    else{
                        throw new AuraHandledException('The 2 intervals of Friday must be senseful and not overlap, in order to save the schedule!');
                    }
                }
                else{
                    throw new AuraHandledException('The 2nd Interval of Friday is not valid!');
                }
            }
            else{
                friday.Day_In_The_Week__c = 'Friday';
                friday.Working_Schedule__c = workingSchedule.Id;
                workingDaysToInsert.add(friday);
            }  
        }

        // insert the Working_Days__c records
        if (!workingDaysToInsert.isEmpty()){
            insert workingDaysToInsert;
        }
    }

    // check startHour < endHour for all intervals
    public static Boolean isValidInterval(String startHour, String endHour){
        if (String.isBlank(startHour) || String.isBlank(endHour) ){
            return false;
        }
        return startHour < endHour;
    }

    // check if interval1 is before interval2 and they dont overlap
    public static Boolean intervalsDontOverlapAndSenseful(String startHour1, String endHour1, String startHour2, String endHour2){
        if (String.isBlank(startHour1) || String.isBlank(endHour1) || String.isBlank(startHour2) || String.isBlank(endHour2)){
            return false;
        }
        return startHour1 < endHour2 && endHour1 < startHour2;
    }
}
