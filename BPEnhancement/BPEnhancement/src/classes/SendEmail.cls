public with sharing class SendEmail {
	
	public static void send(List<String> emailStrList, String subject, String htmlBody, String soHeaderId) {
		if(emailStrList.size() == 0) {
			return;
		}
		
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		String sentFromEmailString = Configurations__c.getInstance().Sent_From_Email_Id__c;
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> sendTo = emailStrList;
		mail.setToAddresses(sendTo);
		mail.setReplyTo(sentFromEmailString);
		mail.setSenderDisplayName('BlackPurl Team');
		
		List<String> ccTo = new List<String>();
		//ccTo.add('tarun.khandelwal@metacube.com');
		mail.setCcAddresses(ccTo);
		
		List<Messaging.EmailFileAttachment> emailAttachmentList = new List<Messaging.EmailFileAttachment>();
		Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
		emailAttachment.setFileName('Service Order Preview.pdf');
		
		PageReference soInfoPreviewPDFPage = Page.SOInfoPrintPreviewPDF;
		soInfoPreviewPDFPage.getparameters().put('id', soHeaderId);
		Blob pageContent;
		if(!Test.isRunningTest()) {
			pageContent = soInfoPreviewPDFPage.getContentAsPdf();
		} else {
			pageContent = Blob.valueof('Test String');
		}
		emailAttachmentList.add(emailAttachment);
		emailAttachment.setBody(pageContent);
		mail.setFileAttachments(emailAttachmentList);
		
		mail.setSubject(subject);
		mail.setHtmlBody(htmlBody);
		mails.add(mail);
		Messaging.sendEmail(mails);
	}
	
	
	
	public static void sendSupportMail(List<String> emailStrList, String subject, String htmlBody) {
		if(emailStrList.size() == 0) {
			return;
		}  
		
		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		String sentFromEmailString = Configurations__c.getOrgDefaults().Sent_From_Email_Id__c;
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> sendTo = emailStrList;
		mail.setToAddresses(sendTo);
		mail.setReplyTo(sentFromEmailString);
		mail.setSenderDisplayName('BlackPurl Team');
		
		//List<String> ccTo = new List<String>();
		//ccTo.add('hitesh.gupta@metacube.com');
		//mail.setCcAddresses(ccTo);
		mail.setSubject(subject);
		mail.setHtmlBody(htmlBody);
		mails.add(mail);
		Messaging.sendEmail(mails);
	}
}