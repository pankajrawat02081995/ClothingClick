//
//  Untitled.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 19/11/24.
//

import UIKit
import MessageUI

class CommunicationHelper: NSObject, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    static let shared = CommunicationHelper()
    
    private override init() {}
    
    // Call Function
    func callNumber(phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Device cannot make phone calls.")
        }
    }
    
    // Email Function
    func sendEmail(to email: String, subject: String = "", body: String = "", viewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([email])
            mailComposeVC.setSubject(subject)
            mailComposeVC.setMessageBody(body, isHTML: false)
            viewController.present(mailComposeVC, animated: true, completion: nil)
        } else {
            if let emailURL = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            } else {
                print("Cannot open the mail app.")
            }
        }
    }
    
    // SMS Function
    func sendTextMessage(to phoneNumber: String, body: String = "", viewController: UIViewController) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeVC = MFMessageComposeViewController()
            messageComposeVC.messageComposeDelegate = self
            messageComposeVC.recipients = [phoneNumber]
            messageComposeVC.body = body
            viewController.present(messageComposeVC, animated: true, completion: nil)
        } else {
            if let smsURL = URL(string: "sms:\(phoneNumber)") {
                UIApplication.shared.open(smsURL, options: [:], completionHandler: nil)
            } else {
                print("Cannot send text messages.")
            }
        }
    }
    
    // MARK: - Delegates for Email and Message
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
