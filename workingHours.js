import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import WORKING_DAYS_OBJECT from '@salesforce/schema/Working_Day__c';
import HOURS_PICKLIST_FIELD from '@salesforce/schema/Working_Day__c.Start_Hour__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

export default class WorkingHours extends LightningElement {
    showWelcomeScreenBool = true;
    showSchedulerBool = false;

    recordTypeId;
    // remember to later verify later before saving, that the start time is before the end time
    mondayStart = null;
    mondayEnd = null;
    tuesdayStart = null;
    tuesdayEnd = null;
    wednesdayStart = null;
    wednesdayEnd = null;
    thursdayStart = null;
    thursdayEnd = null;
    fridayStart = null;
    fridayEnd = null;


    hoursPicklistOptions = [];

    // show welcome screen until button presses, then switch to scheduler
    showScheduler() {
        this.showWelcomeScreenBool = false;
        this.showSchedulerBool = true;
    }

    // runs in current user's context, gets the right record type id for the Account object
    @wire(getObjectInfo, {objectApiName: WORKING_DAYS_OBJECT})
    wiredRecordType({data, error}) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
            console.log('recordTypeId: ' + this.recordTypeId);
        } else if (error) {
            console.log('Error when retrieving the recordTypeId for the running user: ' + error);
        }
    }

    // retrieve the picklist values and store them
    @wire(getPicklistValues, {recordTypeId: '$recordTypeId', fieldApiName: HOURS_PICKLIST_FIELD})
    wiredPicklistOptions({data, error}) {
        if (data) {
            this.hoursPicklistOptions = data.values;
            console.log('hoursPicklistOptions: ' + this.hoursPicklistOptions);
        } else if (error) {
            console.log('Error when retrieving the picklist values for the hours field: ' + error);
        }
    }

    // getter for combobox values, create a label-value pair array for the combobox
    get hourOptions(){
        if (!this.hoursPicklistOptions){
            return [];
        }

        const opts = []; 
        for (let i = 0; i < this.hoursPicklistOptions.length; i++){
            opts.push({
                label: this.hoursPicklistOptions[i].label,
                value: this.hoursPicklistOptions[i].value
            });
        }
        return opts;   
    }

    handleMondayStartChange(event) {
        this.mondayStart = event.detail.value;
    }

    handleMondayEndChange(event){
        this.mondayEnd = event.detail.value;
    }

    handleTuesdayStartChange(event) {
        this.tuesdayStart = event.detail.value;
    }

    handleTuesdayEndChange(event){
        this.tuesdayEnd = event.detail.value;
    }

    handleWednesdayStartChange(event){
        this.wednesdayStart = event.detail.value;
    }

    handleWednesdayEndChange(event){
        this.wednesdayEnd = event.detail.value;
    }

    handleThursdayStartChange(event){
        this.thursdayStart = event.detail.value;
    }

    handleThursdayEndChange(event){
        this.thursdayEnd = event.detail.value;
    }

    handleFridayStartChange(event){
        this.fridayStart = event.detail.value;
    }

    handleFridayEndChange(event){
        this.fridayEnd = event.detail.value;
    }

}
