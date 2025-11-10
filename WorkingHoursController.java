// the file's name does not have ".java" extension, but APEX classes are very similar to Java code
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

        // check if the first intervals are null, if so throw an exception
        if ((monday.Start_Hour__c == null && monday.End_Hour__c == null) &&
            (tuesday.Start_Hour__c == null && tuesday.End_Hour__c == null) &&
            (wednesday.Start_Hour__c == null && wednesday.End_Hour__c == null) &&
            (thursday.Start_Hour__c == null && thursday.End_Hour__c == null) &&
            (friday.Start_Hour__c == null && friday.End_Hour__c == null)){
                throw new AuraHandledException('At least one of the first Intervals must be filled, in order to save the schedule!');
        }

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

        // insert the Working_Schedule__c record
        insert workingSchedule;

        // verify if interval is not empty, then assign the Day_In_The_Week__c and the Working_Schedule__c to the Working_Day__c records, and group in List for insert
        if (monday.Start_Hour__c != null && monday.End_Hour__c != null){
            monday.Day_In_The_Week__c = 'Monday';
            monday.Working_Schedule__c = workingSchedule.Id;
            workingDaysToInsert.add(monday);
        }
        if (tuesday.Start_Hour__c != null && tuesday.End_Hour__c != null){
            tuesday.Day_In_The_Week__c = 'Tuesday';
            tuesday.Working_Schedule__c = workingSchedule.Id;
            workingDaysToInsert.add(tuesday);
        }
        if (wednesday.Start_Hour__c != null && wednesday.End_Hour__c != null){
            wednesday.Day_In_The_Week__c = 'Wednesday';
            wednesday.Working_Schedule__c = workingSchedule.Id;
            workingDaysToInsert.add(wednesday);    
        }
        if (thursday.Start_Hour__c != null && thursday.End_Hour__c != null){
            thursday.Day_In_The_Week__c = 'Thursday';
            thursday.Working_Schedule__c = workingSchedule.Id;
            workingDaysToInsert.add(thursday);
        }
        if (friday.Start_Hour__c != null && friday.End_Hour__c != null){
            friday.Day_In_The_Week__c = 'Friday';
            friday.Working_Schedule__c = workingSchedule.Id;
            workingDaysToInsert.add(friday);
        }

        // insert the Working_Days__c records
        if (!workingDaysToInsert.isEmpty()){
            insert workingDaysToInsert;
        }
    }
}
