//
//  HomeVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-29.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase
//import UserNotifications


class HomeVC: UIViewController {
    
    weak var delegate: DirectionDelegate?
    
    var quoteList: Array<String> = []
    var totalMeditation = 0
    var totalPractice = 0
    
    var medTime = 0
    var pracTime = 0
    var quote = ""
    var scheduled = false
    
   
    @IBOutlet weak var totalTimeLabel: UIButton!

    @IBAction func testB(_ sender: Any) {
        
//        //let notification = UNMutableNotificationContent()
//        notification.title = "Your Daily Quote"
//        updateQuote(quoteList: getQuoteList());
//
//        notification.body = quote
//        notification.sound = UNNotificationSound.default()
//
//        // Configure the trigger for a 7am wakeup.
//        var dateInfo = DateComponents()
//        dateInfo.hour = 7
//        dateInfo.minute = 0
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
//        //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //initNotificationSetupCheck()
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        scheduled = (UserDefaults.standard.value(forKey: "scheduled") as? Bool) ?? false
        let notificationPref = (UserDefaults.standard.value(forKey: "notifications") as? Bool) ?? false
        
        if (notificationPref && !scheduled) {
        
//            print("scheduling notification")
//            UserDefaults.standard.set(true, forKey: "scheduled")
//            let notification = UNMutableNotificationContent()
//            notification.title = "Your Daily Quote"
//            updateQuote(quoteList: getQuoteList());
//
//            notification.body = quote
//            notification.sound = UNNotificationSound.default()
//
//            // Configure the trigger for a 7am wakeup.
//            var dateInfo = DateComponents()
//            dateInfo.hour = 7
//            dateInfo.minute = 0
//
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
//            //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//            let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: trigger)
//
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
    }
        
        
        if userID != nil {
        ref.child("users").child(userID!).child("meditation").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get time value
            
            if let value = snapshot.value as? NSDictionary {
                
                self.medTime = value["totalTime"] as? Int ?? 0
                //print(self.medTime)
                
                self.totalMeditation = (self.medTime%3600)/60
                //print(self.totalMeditation)
               
            }
            
                    ref.child("users").child(userID!).child("practice").observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get time value
            
                        if let value = snapshot.value as? NSDictionary {
            
                            self.pracTime = value["totalTime"] as? Int ?? 0
                            //print(self.pracTime)
            
                            self.totalPractice = (self.pracTime%3600)/60
                            
                            let title = "Total Practice Time: \(self.totalMeditation+self.totalPractice) mins"
                            
                            self.totalTimeLabel.setTitle(title, for: .normal)
                        }
                    })
            
        })
        

        }
        SetDate();
        quoteList = getQuoteList();
        
        updateQuote(quoteList: getQuoteList());
        
        
    }
    
    
    
    func updateQuote(quoteList: Array<String>){
        let userDefaults = UserDefaults.standard
        
        if let lastRetrieval = userDefaults.dictionary(forKey: "lastRetrieval") {
            if let lastDate = lastRetrieval["date"] as? NSDate {
                if let index = lastRetrieval["index"] as? Int {
                    if abs(lastDate.timeIntervalSinceNow) > 86400 {
                        //print(true)
                        //86400 { // seconds in 24 hours
                        // Time to change the label
                        let nextIndex = selectQuote(quoteList: quoteList);
                            //index + 1
                        quote = self.quoteList[nextIndex]
                        self.quoteLabel.text = quote
                        
                        let lastRetrieval : [NSObject : AnyObject] = [
                            "date" as NSObject : NSDate(),
                            "index" as NSObject : nextIndex as AnyObject
                        ]
                        
                        userDefaults.set(lastRetrieval, forKey: "lastRetrieval")
                        userDefaults.synchronize()
                    }
                //print(false)
                    // Do nothing, not enough time has elapsed to change labels
                    quote = self.quoteList[index]
                    self.quoteLabel.text = self.quoteList[index]
                }
            }
        } else {
            
            // No dictionary found, show first quote
            quote = self.quoteList.first!
            self.quoteLabel.text = quote
            
            // Make new dictionary and save to NSUserDefaults
            let lastRetrieval : [NSObject : AnyObject] = [
                "date" as NSObject : NSDate(),
                "index" as NSObject : 0 as AnyObject
            ]
            
            userDefaults.set(lastRetrieval, forKey: "lastRetrieval")
            userDefaults.synchronize()
        }
    }
    
    
    func SetDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var quoteLabel: UITextView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromPractice" {
            let nextScene =  segue.destination as! PranayamaVC
            
            // Pass the selected object to the new view controller.
                let type = "Standard Class"
                nextScene.selectedType = type
        }
        
        else if segue.identifier == "summary" {
            let nextScene =  segue.destination as! SummaryVC

            // Pass the selected object to the new view controller.
            //let type = "Pranayama Class"
            nextScene.practiceTime = totalPractice
            nextScene.meditationTime = totalMeditation
        }
    }
    

    
    func selectQuote(quoteList: Array<String>) -> Int{
        let randomIndex = Int(arc4random_uniform(UInt32(quoteList.count)))
        return randomIndex
    }

    func getQuoteList()->Array<String>{
        
        //ar text2: String
        var  quotes: Array<String> = []
        
        
        // get the file path for the file "test.json" in the playground bundle
        let filePath = Bundle.main.path(forResource: "quotes", ofType: "txt")
        
        // get the contentData
        let contentData = FileManager.default.contents(atPath: filePath!)
        
        // get the string
        let content = String(data: contentData!, encoding: .utf8)
        
        
        if let c = content {
            //print("content: \n\(c)")
            quotes = c.components(separatedBy: "\n")
            //print(quotes.count)
            print(quotes[quotes.count-1])
            quotes.removeLast()
            //print(quotes[quotes.count-1])
        }
        
        return quotes;
    }
    
    
//    func initNotificationSetupCheck() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
//        { (success, error) in
//            if success {
//                print("Permission Granted")
//            } else {
//                print("There was a problem!")
//            }
//        }
//    }
}
