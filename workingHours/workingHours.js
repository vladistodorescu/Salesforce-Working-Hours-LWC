import { LightningElement, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import WORKING_DAYS_OBJECT from '@salesforce/schema/Working_Day__c';
import HOURS_PICKLIST_FIELD from '@salesforce/schema/Working_Day__c.Start_Hour__c';

import storeSchedule from '@salesforce/apex/WorkingHoursController.storeSchedule';

const intervalKeys = [
    'mondayStartFirstInterval','mondayEndFirstInterval',
    'mondayStartSecondInterval','mondayEndSecondInterval',
    'tuesdayStartFirstInterval','tuesdayEndFirstInterval',
    'tuesdayStartSecondInterval','tuesdayEndSecondInterval',
    'wednesdayStartFirstInterval','wednesdayEndFirstInterval',
    'wednesdayStartSecondInterval','wednesdayEndSecondInterval',
    'thursdayStartFirstInterval','thursdayEndFirstInterval',
    'thursdayStartSecondInterval','thursdayEndSecondInterval',
    'fridayStartFirstInterval','fridayEndFirstInterval',
    'fridayStartSecondInterval','fridayEndSecondInterval'
];

export default class WorkingHours extends LightningElement {
    showWelcomeScreenBool = true;
    showSchedulerBool = false;

    recordTypeId;

    mondaySelected = false;
    tuesdaySelected = false;
    wednesdaySelected = false;
    thursdaySelected = false;
    fridaySelected = false;

    // remember to later verify later before saving, that the start time is before the end time
    mondayStartFirstInterval = null;
    mondayEndFirstInterval = null;
    mondayStartSecondInterval = null;
    mondayEndSecondInterval = null;

    tuesdayStartFirstInterval = null;
    tuesdayEndFirstInterval = null;
    tuesdayStartSecondInterval = null;
    tuesdayEndSecondInterval = null;

    wednesdayStartFirstInterval = null;
    wednesdayEndFirstInterval = null;
    wednesdayStartSecondInterval = null;
    wednesdayEndSecondInterval = null;

    thursdayStartFirstInterval = null;
    thursdayEndFirstInterval = null;
    thursdayStartSecondInterval = null;
    thursdayEndSecondInterval = null;

    fridayStartFirstInterval = null;
    fridayEndFirstInterval = null;
    fridayStartSecondInterval = null;
    fridayEndSecondInterval = null;

    // extra Comboboxes Booleans
    mondayExtraCombobox = false;
    tuesdayExtraCombobox = false;
    wednesdayExtraCombobox = false;
    thursdayExtraCombobox = false;
    fridayExtraCombobox = false;

    hoursPicklistOptions = [];

    isSaving = false;

    // show welcome screen until button presses, then switch to scheduler
    showScheduler() {
        this.showWelcomeScreenBool = false;
        this.showSchedulerBool = true;
    }

    // maybe also add spinner while saving
    async saveSchedule(){
        if (this.isSaving){
            return;
        }

        // Build the pairs explicitly and inspect them
        const pairs = intervalKeys.map(k => [k, this[k]]);
        console.log('pairs length:', pairs.length);
        console.log('pairs sample:', pairs.slice(0, 5)); // show first 5 [key,value] items

        // Build the Map and check its size
        const intervalsMap = new Map(pairs);
        console.log('map size:', intervalsMap.size);

        const payload = Object.fromEntries(pairs); // not from the Map, avoids proxy weirdness

        // JSON string if you plan to send to Apex
        console.log('payload JSON:', JSON.stringify(payload));

        try {
            this.isSaving = true; 
            await storeSchedule({ workingIntervals: payload });
            this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Saved',
                  message: 'Working schedule saved.',
                  variant: 'success'
                })
              );
            this.exitLWC(); 
          } catch (e) {
            this.dispatchEvent(
                new ShowToastEvent({
                  title: 'Error saving schedule',
                  message: e?.body?.message || 'Save failed.',
                  variant: 'error'
                })
            );
          } finally {
            this.isSaving = false;     // unlock
        }
    }

    exitLWC(){
        // go back to welcome screen
        this.showSchedulerBool = false;
        this.showWelcomeScreenBool = true;

        // reset all set time intervals
        intervalKeys.forEach(k => { this[k] = null; });

        // reset all extra comboboxes
        this.mondayExtraCombobox = false;
        this.tuesdayExtraCombobox = false;
        this.wednesdayExtraCombobox = false;
        this.thursdayExtraCombobox = false;
        this.fridayExtraCombobox = false;
    }

    // runs in current user's context, gets the right record type id for the Working_Days__c object
    @wire(getObjectInfo, {objectApiName: WORKING_DAYS_OBJECT})
    wiredRecordType({data, error}) {
        if (data) {
            this.recordTypeId = data.defaultRecordTypeId;
            console.log('recordTypeId: ' + this.recordTypeId);
        } else if (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error retrieving running user\'s recordTypeId',
                message: 'Error retrieving running user\'s recordTypeId!',
                variant: 'error'
            }));
        }
    }

    // retrieve the picklist values and store them
    @wire(getPicklistValues, {recordTypeId: '$recordTypeId', fieldApiName: HOURS_PICKLIST_FIELD})
    wiredPicklistOptions({data, error}) {
        if (data) {
            this.hoursPicklistOptions = data.values;
            console.log('hoursPicklistOptions: ' + this.hoursPicklistOptions);
        } else if (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error retrieving running user\'s picklist fields',
                message: 'Error retrieving running user\'s picklist fields!',
                variant: 'error'
            }));
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

    // class helpers (blue only when selected)
    get sunClass() { return 'day-chip'; }
    get satClass() { return 'day-chip'; }

    get monClass() { return `day-chip ${this.mondaySelected ? 'day-chip_on' : ''}`; }
    get tueClass() { return `day-chip ${this.tuesdaySelected ? 'day-chip_on' : ''}`; }
    get wedClass() { return `day-chip ${this.wednesdaySelected ? 'day-chip_on' : ''}`; }
    get thuClass() { return `day-chip ${this.thursdaySelected ? 'day-chip_on' : ''}`; }
    get friClass() { return `day-chip ${this.fridaySelected ? 'day-chip_on' : ''}`; }

    // Handlers for First Interval
    handleMondayStartFirstIntervalChange(event) { this.mondayStartFirstInterval = event.detail.value; }
    handleMondayEndFirstIntervalChange(event){ this.mondayEndFirstInterval = event.detail.value; }
    handleTuesdayStartFirstIntervalChange(event) { this.tuesdayStartFirstInterval = event.detail.value; }
    handleTuesdayEndFirstIntervalChange(event){ this.tuesdayEndFirstInterval = event.detail.value; } 
    handleWednesdayStartFirstIntervalChange(event){ this.wednesdayStartFirstInterval = event.detail.value; }
    handleWednesdayEndFirstIntervalChange(event){ this.wednesdayEndFirstInterval = event.detail.value; }
    handleThursdayStartFirstIntervalChange(event){ this.thursdayStartFirstInterval = event.detail.value; }
    handleThursdayEndFirstIntervalChange(event){ this.thursdayEndFirstInterval = event.detail.value; }
    handleFridayStartFirstIntervalChange(event){ this.fridayStartFirstInterval = event.detail.value; }
    handleFridayEndFirstIntervalChange(event){ this.fridayEndFirstInterval = event.detail.value; }

    // Handlers for Second Interval
    handleMondayStartSecondIntervalChange(event) { this.mondayStartSecondInterval = event.detail.value; }
    handleMondayEndSecondIntervalChange(event){ this.mondayEndSecondInterval = event.detail.value; }
    handleTuesdayStartSecondIntervalChange(event) { this.tuesdayStartSecondInterval = event.detail.value; }
    handleTuesdayEndSecondIntervalChange(event){ this.tuesdayEndSecondInterval = event.detail.value;} 
    handleWednesdayStartSecondIntervalChange(event){ this.wednesdayStartSecondInterval = event.detail.value; }
    handleWednesdayEndSecondIntervalChange(event){ this.wednesdayEndSecondInterval = event.detail.value; }
    handleThursdayStartSecondIntervalChange(event){ this.thursdayStartSecondInterval = event.detail.value; }
    handleThursdayEndSecondIntervalChange(event){ this.thursdayEndSecondInterval = event.detail.value; }
    handleFridayStartSecondIntervalChange(event){ this.fridayStartSecondInterval = event.detail.value; }
    handleFridayEndSecondIntervalChange(event){ this.fridayEndSecondInterval = event.detail.value; }

    // Methods for adding and removing extra comboboxes
    addMondayExtraCombobox(){ this.mondayExtraCombobox = true; }
    addTuesdayExtraCombobox(){ this.tuesdayExtraCombobox = true; }
    addWednesdayExtraCombobox(){ this.wednesdayExtraCombobox = true; }
    addThursdayExtraCombobox(){ this.thursdayExtraCombobox = true; }
    addFridayExtraCombobox(){ this.fridayExtraCombobox = true; }

    removeMondayExtraCombobox(){ this.mondayExtraCombobox = false; }
    removeTuesdayExtraCombobox(){ this.tuesdayExtraCombobox = false; }
    removeWednesdayExtraCombobox(){ this.wednesdayExtraCombobox = false; }
    removeThursdayExtraCombobox(){ this.thursdayExtraCombobox = false; }
    removeFridayExtraCombobox(){ this.fridayExtraCombobox = false; }

    // Methods for enabling day for scheduling
    toggleMonday(){ 
        this.mondaySelected = !this.mondaySelected;
        if (this.mondaySelected == false){
            this.mondayStartFirstInterval = null;
            this.mondayEndFirstInterval = null;
            this.mondayStartSecondInterval = null;
            this.mondayEndSecondInterval = null;
            this.mondayExtraCombobox = false;
        }
    }
    toggleTuesday(){ 
        this.tuesdaySelected = !this.tuesdaySelected;
        if (this.tuesdaySelected == false){
            this.tuesdayStartFirstInterval = null;
            this.tuesdayEndFirstInterval = null;
            this.tuesdayStartSecondInterval = null;
            this.tuesdayEndSecondInterval = null;
            this.tuesdayExtraCombobox = false;
        }
    }
    toggleWednesday(){ 
        this.wednesdaySelected = !this.wednesdaySelected;
        if (this.wednesdaySelected == false){
            this.wednesdayStartFirstInterval = null;
            this.wednesdayEndFirstInterval = null;
            this.wednesdayStartSecondInterval = null;
            this.wednesdayEndSecondInterval = null;
            this.wednesdayExtraCombobox = false;
        }
    }
    toggleThursday() { 
        this.thursdaySelected = !this.thursdaySelected;
        if (thursdaySelected == false){
            this.thursdayStartFirstInterval = null;
            this.thursdayEndFirstInterval = null;
            this.thursdayStartSecondInterval = null;
            this.thursdayEndSecondInterval = null;
            this.thursdayExtraCombobox = false;
        }
    }
    toggleFriday(){ 
        this.fridaySelected = !this.fridaySelected;
        if (this.fridaySelected == false){
            this.fridayStartFirstInterval = null;
            this.fridayEndFirstInterval = null;
            this.fridayStartSecondInterval = null;
            this.fridayEndSecondInterval = null;
            this.fridayExtraCombobox = false;
        }
    }
}
