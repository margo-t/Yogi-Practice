//
//  MeditationVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-27.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import Firebase;
import GoogleSignIn;

class MeditationVC: UIViewController {
    
    var counterMinutes = 1800
    var TotalMeditationTime = 0
    var CurrentMeditationTime = 0
    var timer = Timer()
    var refHandle: UInt!
    var mediTime: Int = 0
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    
    @IBOutlet weak var timerSliderOutlet: UISlider!
    @IBOutlet weak var PlayButtonOutlet: UIButton!
    @IBOutlet weak var PauseButtonOutlet: UIButton!
    @IBOutlet weak var FinishButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").child(userID!).child("meditation").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get time value
            
            if let value = snapshot.value as? NSDictionary {
                //let value = snapshot.value as! NSDictionary
                self.mediTime = value["totalTime"] as? Int ?? 0
                print(self.mediTime)
                self.TotalMeditationTime = self.mediTime
                self.totalTime.text = self.formatTime(time: Int(self.TotalMeditationTime/60))+":"+self.formatTime(time: self.TotalMeditationTime%60)
            }
            else {
            
            self.totalTime.text = self.formatTime(time: Int(self.TotalMeditationTime/60))+":"+self.formatTime(time: self.TotalMeditationTime%60)
            }
    })
        
    }
    
    
    
    
    @IBAction func playButton(_ sender: UIButton) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MeditationVC.counter), userInfo: nil, repeats: true)
        timerSliderOutlet.isHidden = true
        PlayButtonOutlet.isHidden = true
        PauseButtonOutlet.isHidden = false
        FinishButtonOutlet.isHidden = true
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        timer.invalidate()
        PlayButtonOutlet.isHidden = false
        PauseButtonOutlet.isHidden = true
        FinishButtonOutlet.isHidden = false
        
    }
    
    
    @IBAction func finishButton(_ sender: UIButton) {
        TotalMeditationTime += CurrentMeditationTime
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let today = String(components.day!)+"-"+String(components.month!)+"-"+String(components.year!)
        print(today)
        
        //Update Firebase
        if CurrentMeditationTime > 0 {
            print("passed true for CurrentMeditationTime > 0")
            FinishButtonOutlet.isEnabled = false
            DataService.instance.updateMeditationTime(withTime: CurrentMeditationTime, andTotalTime: TotalMeditationTime,
                                                      forUid: (Auth.auth().currentUser?.uid)!, forDay: today, sendComplete: {(isComplete) in
                                                        if isComplete {
                                                            self.FinishButtonOutlet.isEnabled = true
                                                            print("sent to Firebase")
                                                            
                                                        }
                                                        else {
                                                            self.FinishButtonOutlet.isEnabled = true
                                                            print("Error sending")
                                                        }
            })
        }
        
        //Update UI
        totalTime.text = formatTime(time: Int(TotalMeditationTime/60))+":"+formatTime(time: TotalMeditationTime%60)
        FinishButtonOutlet.isHidden = true
        PlayButtonOutlet.isHidden = false
        timerSliderOutlet.isHidden = false
        counterMinutes = 1800
        CurrentMeditationTime = 0
        timerSliderOutlet.setValue(1800, animated: true)
        timerLabel.text = "30:00"
    }
    
    
    
    
    @IBAction func timerSlider(_ sender: UISlider) {
        counterMinutes = Int(sender.value)
        timerLabel.text = formatTime(time: Int(counterMinutes/60))+":"+formatTime(time: counterMinutes%60)
    }
    
    @objc func counter() {
        
        counterMinutes -= 1
        CurrentMeditationTime += 1
        timerLabel.text = formatTime(time: Int(counterMinutes/60))+":"+formatTime(time: counterMinutes%60)
        if (counterMinutes == 0) {
            timer.invalidate()
            
            PauseButtonOutlet.isHidden = true
            FinishButtonOutlet.isHidden = false
            PlayButtonOutlet.isHidden = true
            
        }
        
    }
    
    func formatTime(time: Int)->String{
        if (time/10 < 1) {
            return "0"+String(time)
        }
        else {
            return String(time)
            
        }
        
    }
    
    
    

    

    
    
}
