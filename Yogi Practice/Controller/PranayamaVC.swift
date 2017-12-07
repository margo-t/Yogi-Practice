//
//  PranayamaVC.swift
//  Yogi Practice
//
//  Created by margot on 2017-09-29.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit
import AVFoundation

//TODO change layout from asana

class PranayamaVC: UIViewController {
    
    //set variables
    var Audios: Array<URL?> = []
    var practiceRecording: AVAudioPlayer?
    var playlist: Array<AudioFile> = []
    var soundURL = URL(string: "https://www.apple.com")
    
    
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var audioDescription: UITextView!
    
    
    var selectedType: String? = ""
    var counter: Int = 0
    
    //pause button
    @IBAction func pauseBtn(_ sender: UIButton) {
        
        if (practiceRecording?.isPlaying)! {
            practiceRecording?.pause()
            self.PauseButton.isHidden = true
            self.PlayButton.isHidden = false
        }
        
    }
    
    //next button
    @IBAction func nextBtn(_ sender: UIButton) {
        
        if practiceRecording?.isPlaying == true {
            practiceRecording?.pause()
        }
        
        if (counter<playlist.count-1){
            
            counter += 1
            setNextAudio()
            practiceRecording?.play()
        }
        else {
            
            let alert = UIAlertController(title: "Congratulations!", message: "You have finished the practice", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            counter = 0
            setNextAudio()
        }
        
    }
    
    //play button
    @IBAction func playBtn(_ sender: UIButton) {
        
        if practiceRecording?.isPlaying == false {
        
            practiceRecording?.play()
            self.PauseButton.isHidden = false 
            self.PlayButton.isHidden = true
        }
    }

    //restart button
    @IBAction func restartButton(_ sender: UIButton) {
        practiceRecording?.pause()
        practiceRecording?.currentTime = 0
        practiceRecording?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectedType;
        counter = 0
        gettingNames();
        setPlaylist(type: selectedType!);
        setNextAudio()
    }
    
    func setNextAudio(){
        audioTitle.text=playlist[counter].name;
        audioDescription.text=playlist[counter].description;
        soundURL = playlist[counter].URL
        do {
            try practiceRecording = AVAudioPlayer(contentsOf: (soundURL)!)} catch let err as NSError {
                print(err.debugDescription)
                
        }
    }
    
    
    func setPlaylist(type: String){
        switch type {
        case "Standard Class":
            playlist = StandardClass;
        case "Asana Class":
            playlist = StandardClass;
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
                var myAudio = audio.absoluteString
                
                if myAudio.contains(".aiff") {
                    print("this is myAudio----->"+myAudio)
                    let findString = myAudio.components(separatedBy: "/")
                    myAudio = findString[findString.count-1]
                    myAudio = myAudio.replacingOccurrences(of: "%20", with: " ")
                    myAudio = myAudio.replacingOccurrences(of: ".aiff", with: "")
                    print(myAudio)
                    
                    Audios.append(audio)
                    
                }
            }
            //            let audioPath = Bundle.main.path(forResource: "1openingPrayer", ofType: "aiff")
            //            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch {
            
        }
    }
    
    let StandardClass: Array<AudioFile> = [AudioFile(name: "Opening Prayer", description: "Dhyana Slokas (Gajananam)", URL: nil)]
    
    let PranayamaClass: Array<AudioFile> = [AudioFile(name: "Kapalabhati", description: "3 rounds", URL: nil),
                                            AudioFile(name: "Anuloma Viloma", description: "3 rounds", URL: nil)]
    
    

}
