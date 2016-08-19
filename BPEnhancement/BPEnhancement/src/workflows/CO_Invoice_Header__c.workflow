<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Invoice_Date</fullName>
        <description>Populate invoice date</description>
        <field>Invoice_Date__c</field>
        <formula>Now()</formula>
        <name>Invoice Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Invoice Date</fullName>
        <actions>
            <name>Invoice_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is the time when invoice is finalizing i.e. the status is changed from Active To Closed</description>
        <formula>AND(  (ISPICKVAL(PRIORVALUE(Invoice_Status__c), &apos;Active&apos;)),  ISPICKVAL(Invoice_Status__c, &apos;Closed&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
