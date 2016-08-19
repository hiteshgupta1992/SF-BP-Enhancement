<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AccountSearchTagsUpdate</fullName>
        <field>Search_Tags__c</field>
        <formula>IF(
	AND( Is_Vendor__c = true, Is_Customer__c = true ),
	&quot;IsCustomer IsVendor&quot;,
	IF(
		AND( Is_Vendor__c = true, Is_Customer__c = false ),
		&quot;IsVendor&quot;,
		IF(
			AND( Is_Vendor__c = false, Is_Customer__c = true ),
			&quot;IsCustomer&quot;,
			&quot;&quot;
		)
	)
)</formula>
        <name>AccountSearchTagsUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Number</fullName>
        <field>Customer_Number__c</field>
        <formula>Customer_Number_Autonum__c</formula>
        <name>Update Customer Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Customer Number</fullName>
        <actions>
            <name>Update_Customer_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Customer_Number_Autonum__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UpdateSearchTags</fullName>
        <actions>
            <name>AccountSearchTagsUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Account.Is_Customer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Search_Tags__c</field>
            <operation>notContain</operation>
            <value>IsCustomer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Is_Vendor__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Search_Tags__c</field>
            <operation>notContain</operation>
            <value>IsVendor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
