trigger TimeCardTrigger2 on Time_Card__c (before insert) {
    TimeCardService.TimeCardCallout(Trigger.new[0].id);
}