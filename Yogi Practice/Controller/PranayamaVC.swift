//
//  PranayamaVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-29.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import GoogleSignIn

//TODO change layout from asana

class PranayamaVC: UIViewController, UITableViewDelegate {
    
    //set variables
    var Audios: Array<URL?> = []
    var practiceRecording: AVPlayer?
    var playlist: Array<AudioFile> = []
    var soundURL = URL(string: "https://www.apple.com")
    
    var CurrentPracticeTime = 0
    var PracTime = 0
    var TotalPracticeTime = 0
    var timer = Timer()
    
    
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var audioDescription: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedType: String? = ""
    var counter: Int = 0
    
    // pause button
    @IBAction func pauseBtn(_ sender: UIButton) {
        
            practiceRecording?.pause()
            timer.invalidate()
            self.PauseButton.isHidden = true
            self.PlayButton.isHidden = false
        
        
    }
    
    // next button
    @IBAction func nextBtn(_ sender: UIButton) {
        
        
        practiceRecording?.pause()
         if (counter<=playlist.count-1){
//
            counter += 1
            setNextAudio()
            //practiceRecording?.play()
        }
        else {

//            savePractice()
//
//            let alert = UIAlertController(title: "Congratulations!", message: "You have finished the practice", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//            counter = 0
            setNextAudio()
        }
        
    }
    
    //play button
    @IBAction func playBtn(_ sender: UIButton) {
        
        setObserver()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PranayamaVC.counterTimer), userInfo: nil, repeats: true)
        
        practiceRecording?.play()
        self.PauseButton.isHidden = false
        self.PlayButton.isHidden = true
        
    }
    

    //restart button
    @IBAction func restartButton(_ sender: UIButton) {
        
        self.practiceRecording?.seek(to: kCMTimeZero)
        self.practiceRecording?.play()
        
//        practiceRecording?.s
//        practiceRecording?.time = 0
//        practiceRecording?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidLoad()
        
        practiceRecording?.pause()
        timer.invalidate()
        self.PauseButton.isHidden = true
        self.PlayButton.isHidden = false
        
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("users").child(userID!).child("practice").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get time value
            if let value = snapshot.value as? NSDictionary {
                
                self.PracTime = value["totalTime"] as? Int ?? 0
                self.TotalPracticeTime = self.PracTime
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //HomeVC.delegate = self
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.title = selectedType;
        counter = 0
        gettingNames();
        setPlaylist(type: selectedType!);
        setNextAudio()
    }
    

    
    func setNextAudio(){
        
        if (counter<=playlist.count-1){
            
            //counter += 1
            //setNextAudio()
            //practiceRecording?.play()
            
            
            audioTitle.text=playlist[counter].name;
            audioDescription.text=playlist[counter].description;
            soundURL = playlist[counter].URL
            
            practiceRecording = AVPlayer(url: (soundURL)!)
            
            if counter != 0{
                setObserver()
                self.practiceRecording?.play()
            }
        }
        else {
            print("ready to save - ")
            print(CurrentPracticeTime)
            savePractice()
            
            let alert = UIAlertController(title: "Congratulations!", message: "You have finished the practice", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            counter = 0
            //readyToSend()
            //setNextAudio()
            
            
        }
    }
    
    func setObserver(){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.practiceRecording?.currentItem, queue: .main) { _ in
            
            self.counter += 1
            print("--observer - AVPlayerItemDidPlayToEndTime---")
            print(self.counter)
            self.setNextAudio()
            
            
        }
    }
    
    
    func setPlaylist(type: String){
        switch type {
        case "Standard Class":
            playlist = StandardClass;
            playlist[0].URL=Audios[0]
            playlist[1].URL=Audios[1]
            playlist[2].URL=Audios[2]
            playlist[3].URL=Audios[3]
            playlist[4].URL=Audios[4]
            playlist[5].URL=Audios[5]
            playlist[6].URL=Audios[6]
            playlist[7].URL=Audios[7]
            playlist[8].URL=Audios[8]
            playlist[9].URL=Audios[9]
            playlist[10].URL=Audios[10]
            playlist[11].URL=Audios[11]
            playlist[12].URL=Audios[12]
            playlist[13].URL=Audios[13]
            playlist[14].URL=Audios[14]
            playlist[15].URL=Audios[15]
            playlist[16].URL=Audios[16]
            playlist[17].URL=Audios[17]
            playlist[18].URL=Audios[18]
            playlist[19].URL=Audios[19]
            playlist[20].URL=Audios[20]
        case "Asana Class":
            playlist = AsanaClass;
            playlist[0].URL=Audios[3]
            playlist[1].URL=Audios[4]
            playlist[2].URL=Audios[5]
            playlist[3].URL=Audios[6]
            playlist[4].URL=Audios[7]
            playlist[5].URL=Audios[8]
            playlist[6].URL=Audios[9]
            playlist[7].URL=Audios[10]
            playlist[8].URL=Audios[11]
            playlist[9].URL=Audios[12]
            playlist[10].URL=Audios[13]
            playlist[11].URL=Audios[14]
            playlist[12].URL=Audios[15]
            playlist[13].URL=Audios[16]
            playlist[14].URL=Audios[17]
            playlist[15].URL=Audios[18]
            playlist[16].URL=Audios[19]
            
            
            
        case "Pranayama Class":
            playlist = PranayamaClass;
            playlist[0].URL=Audios[0]
            playlist[1].URL=Audios[1]
        default:
            playlist = StandardClass;
        }
    }
    
    


    func gettingNames() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do {
            
            let audioPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for audio in audioPath {
                let myAudio = audio.absoluteString
                
                if myAudio.contains(".mp3") {
                    //print("this is myAudio----->"+myAudio)
//                    let findString = myAudio.components(separatedBy: "/")
//                    myAudio = findString[findString.count-1]
//                    myAudio = myAudio.replacingOccurrences(of: "%20", with: " ")
//                    myAudio = myAudio.replacingOccurrences(of: ".mp3", with: "")
                    //print(myAudio)
                    
                    Audios.append(audio)
                    }
            }
        }
        catch {
            
        }
    }
    
//    func readyToSend(){
//        //let nextViewController = HomeVC
//
//        navigationController?.pushViewController(HomeVC, animated: false)
//    }
    
    func savePractice() {
        TotalPracticeTime += CurrentPracticeTime
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let today = String(components.day!)+"-"+String(components.month!)+"-"+String(components.year!)
        print("today: "+today)
        
        //Update Firebase
        if CurrentPracticeTime > 0 {
            print("passed true for CurrentMeditationTime > 0")
            DataService.instance.updateMeditationTime(withTime: CurrentPracticeTime, andTotalTime: TotalPracticeTime,
                                                      forUid: (Auth.auth().currentUser?.uid)!, toRef: "practice", forDay: today, sendComplete: {(isComplete) in
                                                        if isComplete {
                                        
                                                            self.timer.invalidate()
                                            
                                                            self.CurrentPracticeTime = 0
                                                            print("sent to Firebase")
                                                            
                                                        }
                                                        else {
                                                            self.timer.invalidate()
                                                            print("Error sending")
                                                        }
            })
            
        }
    }
    
    let StandardClass: Array<AudioFile> = [AudioFile(name: "Opening Prayer", description: "Dhyana Slokas (Gajananam)", URL: nil),
                                           AudioFile(name: "Kapalabhati", description: "3 rounds", URL: nil),
                                           AudioFile(name: "Anuloma Viloma", description: "3 rounds", URL: nil),
                                           AudioFile(name: "The Sun Salutation - Surya Namaskar",
                                                     description: "A sequence of twelve positions performed as one continuous exercise",
                                                     URL: nil),
                                        
                                           AudioFile(name: "Single leg raises",
                                                     description: "Warm-up exersize to prepear for asanas",
                                                     URL: nil),
                                           AudioFile(name: "Double leg raises",
                                                     description: "Warm-up exersize to prepear for asanas",
                                                     URL: nil),
                                           AudioFile(name: "Headstand - Sirshasana",
                                                     description: "An asana in which you balance on your elbows, arms, and head",
                                                     URL: nil),
                                           AudioFile(name: "Sarvangasana-Shoulderstand",
                                                     description: "An inverted pose, with your body resting on your shoulders.",
                                                     URL: nil),
                                           AudioFile(name: "Plough - Halasana",
                                                     description: "Objective: To stretch your cervical and thoracic regions.",
                                                     URL: nil),
                                           AudioFile(name: "Fish - Matsyasana",
                                                     description: "Lying on your back and arching your chest.",
                                                     URL: nil),
                                           AudioFile(name: "Sitting Forward bend - Paschimothanasana",
                                                     description: "Stretching your spine forward",
                                                     URL: nil),
                                           AudioFile(name: "Inclined Plane - Purvothanasan",
                                                     description: "Counter stretch for the spine",
                                                     URL: nil),
                                           AudioFile(name: "Cobra - Bhujangasana",
                                                     description: "Coiling your upper body up and back.",
                                                     URL: nil),
                                           AudioFile(name: "Locust - Shalabhasana",
                                                     description: "Lying face down with lifted legs.",
                                                     URL: nil),
                                           AudioFile(name: "Bow - Dhanurasana",
                                                     description: "Balancing on your abdomen, in the shape of a bow.",
                                                     URL: nil),
                                           AudioFile(name: "Spinal twist - Ardha Matsyendrasana",
                                                     description: "A lateral stretch for your entire spine.",
                                                     URL: nil),
                                           AudioFile(name: "Crow - Kakasana or Peacock - Mayurasana",
                                                     description: "Balancing pose",
                                                     URL: nil),
                                           AudioFile(name: "Standing forward bend - Pada Hasthasana",
                                                     description: "Bending forward in a standing position.",
                                                     URL: nil),
                                           AudioFile(name: "Triangle - Trikonasana",
                                                     description: "A lateral bend resembling a triangle.",
                                                     URL: nil),
                                           AudioFile(name: "Final relaxation",
                                                     description: "Full body and mind relaxation.",
                                                     URL: nil),
                                           AudioFile(name: "Final Prayers",
                                                     description: "Maha Mrityunjaya Mantra (Om Tryambakam)",
                                                     URL: nil)]
    
    let PranayamaClass: Array<AudioFile> = [AudioFile(name: "Kapalabhati", description: "3 rounds", URL: nil),
                                            AudioFile(name: "Anuloma Viloma", description: "3 rounds", URL: nil)]
    
    let AsanaClass: Array<AudioFile> = [AudioFile(name: "The Sun Salutation - Surya Namaskar",
                                                 description: "A sequence of twelve positions performed as one continuous exercise",
                                                 URL: nil),
                                        AudioFile(name: "Single leg raises",
                                                  description: "Warm-up exersize to prepear for asanas",
                                                  URL: nil),
                                        AudioFile(name: "Double leg raises",
                                                  description: "Warm-up exersize to prepear for asanas",
                                                  URL: nil),
                                        AudioFile(name: "Headstand - Sirshasana",
                                                  description: "An asana in which you balance on your elbows, arms, and head",
                                                  URL: nil),
                                        AudioFile(name: "Sarvangasana-Shoulderstand",
                                                  description: "An inverted pose, with your body resting on your shoulders.",
                                                  URL: nil),
                                        AudioFile(name: "Plough - Halasana",
                                                  description: "Objective: To stretch your cervical and thoracic regions.",
                                                  URL: nil),
                                        AudioFile(name: "Fish - Matsyasana",
                                                  description: "Lying on your back and arching your chest.",
                                                  URL: nil),
                                        AudioFile(name: "Sitting Forward bend - Paschimothanasana",
                                                  description: "Stretching your spine forward",
                                                  URL: nil),
                                        AudioFile(name: "Inclined Plane - Purvothanasan",
                                                  description: "Counter stretch for the spine",
                                                  URL: nil),
                                        AudioFile(name: "Cobra - Bhujangasana",
                                                  description: "Coiling your upper body up and back.",
                                                  URL: nil),
                                        AudioFile(name: "Locust - Shalabhasana",
                                                  description: "Lying face down with lifted legs.",
                                                  URL: nil),
                                        AudioFile(name: "Bow - Dhanurasana",
                                                  description: "Balancing on your abdomen, in the shape of a bow.",
                                                  URL: nil),
                                        AudioFile(name: "Spinal twist - Ardha Matsyendrasana",
                                                  description: "A lateral stretch for your entire spine.",
                                                  URL: nil),
                                        AudioFile(name: "Crow - Kakasana or Peacock - Mayurasana",
                                                  description: "Balancing pose",
                                                  URL: nil),
                                        AudioFile(name: "Standing forward bend - Pada Hasthasana",
                                                  description: "Bending forward in a standing position.",
                                                  URL: nil),
                                        AudioFile(name: "Triangle - Trikonasana",
                                                  description: "A lateral bend resembling a triangle.",
                                                  URL: nil),
                                        AudioFile(name: "Final relaxation",
                                                  description: "Full body and mind relaxation.",
                                                  URL: nil)
                                        ]
    
    
    @objc func counterTimer() {
        
        CurrentPracticeTime += 1
        print(CurrentPracticeTime)
    }
    
    
}
