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

    // Handlers for First Interval

    handleMondayStartFirstIntervalChange(event) {
        this.mondayStartFirstInterval = event.detail.value;
    }

    handleMondayEndFirstIntervalChange(event){
        this.mondayEndFirstInterval = event.detail.value;
    }

    handleTuesdayStartFirstIntervalChange(event) {
        this.tuesdayStartFirstInterval = event.detail.value;
    }

    handleTuesdayEndFirstIntervalChange(event){
        this.tuesdayEndFirstInterval = event.detail.value;
    } 

    handleWednesdayStartFirstIntervalChange(event){
        this.wednesdayStartFirstInterval = event.detail.value;
    }

    handleWednesdayEndFirstIntervalChange(event){
        this.wednesdayEndFirstInterval = event.detail.value;
    }

    handleThursdayStartFirstIntervalChange(event){
        this.thursdayStartFirstInterval = event.detail.value;
    }

    handleThursdayEndFirstIntervalChange(event){
        this.thursdayEndFirstInterval = event.detail.value;
    }

    handleFridayStartFirstIntervalChange(event){
        this.fridayStartFirstInterval = event.detail.value;
    }

    handleFridayEndFirstIntervalChange(event){
        this.fridayEndFirstInterval = event.detail.value;
    }

    // Handlers for Second Interval

    handleMondayStartSecondIntervalChange(event) {
        this.mondayStartSecondInterval = event.detail.value;
    }

    handleMondayEndSecondIntervalChange(event){
        this.mondayEndSecondInterval = event.detail.value;
    }

    handleTuesdayStartSecondIntervalChange(event) {
        this.tuesdayStartSecondInterval = event.detail.value;
    }

    handleTuesdayEndSecondIntervalChange(event){
        this.tuesdayEndSecondInterval = event.detail.value;
    } 

    handleWednesdayStartSecondIntervalChange(event){
        this.wednesdayStartSecondInterval = event.detail.value;
    }

    handleWednesdayEndSecondIntervalChange(event){
        this.wednesdayEndSecondInterval = event.detail.value;
    }

    handleThursdayStartSecondIntervalChange(event){
        this.thursdayStartSecondInterval = event.detail.value;
    }

    handleThursdayEndSecondIntervalChange(event){
        this.thursdayEndSecondInterval = event.detail.value;
    }

    handleFridayStartSecondIntervalChange(event){
        this.fridayStartSecondInterval = event.detail.value;
    }

    handleFridayEndSecondIntervalChange(event){
        this.fridayEndSecondInterval = event.detail.value;
    }

    saveSchedule(){}

    exitLWC(){
        this.showSchedulerBool = false;
        this.showWelcomeScreenBool = true;

        this.mondayStart = null;
        this.mondayEnd = null;
        this.tuesdayStart = null;
        this.tuesdayEnd = null;
        this.wednesdayStart = null;
        this.wednesdayEnd = null;
        this.thursdayStart = null;
        this.thursdayEnd = null;
        this.fridayStart = null;
        this.fridayEnd = null;
    }

    addExtraCombobox(){

    }

    addMondayExtraCombobox(){
        this.mondayExtraCombobox = true;
    }

    addTuesdayExtraCombobox(){
        this.tuesdayExtraCombobox = true;
    }

    addWednesdayExtraCombobox(){
        this.wednesdayExtraCombobox = true;
    }

    addThursdayExtraCombobox(){
        this.thursdayExtraCombobox = true;
    }
    
    addFridayExtraCombobox(){
        this.fridayExtraCombobox = true;
    }

    removeMondayExtraCombobox(){
        this.mondayExtraCombobox = false;
    }

    removeTuesdayExtraCombobox(){
        this.tuesdayExtraCombobox = false;
    }

    removeWednesdayExtraCombobox(){
        this.wednesdayExtraCombobox = false;
    }

    removeThursdayExtraCombobox(){
        this.thursdayExtraCombobox = false;
    }
    
    removeFridayExtraCombobox(){
        this.fridayExtraCombobox = false;
    }

}
