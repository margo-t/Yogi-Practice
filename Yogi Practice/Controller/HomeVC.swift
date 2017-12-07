//
//  HomeVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-29.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    var quoteList: Array<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        SetDate();
        quoteList = getQuoteList();
        print(quoteList)
        
        updateQuote(quoteList: getQuoteList());
        
    }
    
    func updateQuote(quoteList: Array<String>){
        let userDefaults = UserDefaults.standard
        
        if let lastRetrieval = userDefaults.dictionary(forKey: "lastRetrieval") {
            if let lastDate = lastRetrieval["date"] as? NSDate {
                if let index = lastRetrieval["index"] as? Int {
                    if abs(lastDate.timeIntervalSinceNow) > 86400 {
                        print(true)
                        //86400 { // seconds in 24 hours
                        // Time to change the label
                        let nextIndex = selectQuote(quoteList: quoteList);
                            //index + 1
                        
                        self.quoteLabel.text = self.quoteList[nextIndex]
                        
                        let lastRetrieval : [NSObject : AnyObject] = [
                            "date" as NSObject : NSDate(),
                            "index" as NSObject : nextIndex as AnyObject
                        ]
                        
                        userDefaults.set(lastRetrieval, forKey: "lastRetrieval")
                        userDefaults.synchronize()
                    }
                print(false)
                    // Do nothing, not enough time has elapsed to change labels
                    self.quoteLabel.text = self.quoteList[index]
                }
            }
        } else {
            
            // No dictionary found, show first quote
            self.quoteLabel.text = self.quoteList.first!
            
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
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
                self.present(LoginVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        
        logoutPopup.popoverPresentationController?.sourceView = self.view
        logoutPopup.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        logoutPopup.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        present(logoutPopup, animated: true, completion: nil)
        
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
            //print(quotes[quotes.count-1])
            quotes.removeLast()
            //print(quotes[quotes.count-1])
        }
        
        return quotes;
    }
}
