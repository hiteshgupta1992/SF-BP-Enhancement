<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Is_In_SO_Field</fullName>
        <field>Is_In_Service_Order__c</field>
        <literalValue>1</literalValue>
        <name>Set Is In SO Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Is In SO field</fullName>
        <actions>
            <name>Set_Is_In_SO_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If SOLI is not null, then set this to true</description>
        <formula>IF( Service_Order_Line_Item__c != null,    True,    False )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
