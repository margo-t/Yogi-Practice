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

class PranayamaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //set variables
    var audios: Array<URL?> = []
    var practiceRecording: AVPlayer?
    var playlist: Array<AudioFile> = []
    var soundURL = URL(string: "https://www.apple.com")
    
    var CurrentPracticeTime = 0
    var PracTime = 0
    var TotalPracticeTime = 0
    var timer = Timer()
    
    
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var audioDescription: UILabel!
    @IBOutlet weak var infoLabel: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
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
        counter += 1
        setNextAudio()
    }
    
    //play button
    @IBAction func playBtn(_ sender: UIButton) {
        
        tableView.isHidden = true;
        detailView.isHidden = false;
        showDetails(index: counter)
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
        
    }
    
    
    @IBAction func infoButton(_ sender: UIButton) {
        
        if audioDescription.isHidden
        {
            audioDescription.isHidden = false
            imageView.isHidden = true
            
        }
        else {
            audioDescription.isHidden = true
            imageView.isHidden = false
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("View DID dissapear")
        
        practiceRecording?.pause()
        timer.invalidate()
        self.PauseButton.isHidden = true
        self.PlayButton.isHidden = false

        UIApplication.shared.isIdleTimerDisabled = false
        self.navigationController?.popToRootViewController(animated: false)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcersizeCell", for: indexPath) as! ExersizeCell
        let row = indexPath.row
        cell.titleLabel.text = playlist[row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        counter = indexPath.row
        tableView.isHidden = true;
        detailView.isHidden = false;
        showDetails(index: indexPath.row)
        
        setObserver()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PranayamaVC.counterTimer), userInfo: nil, repeats: true)
        
        practiceRecording?.play()
        self.PauseButton.isHidden = false
        self.PlayButton.isHidden = true
        
    };

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.rowHeight = 100
        UIApplication.shared.isIdleTimerDisabled = true

        self.title = selectedType;
        counter = 0
        gettingNames();
        
        setPlaylist(type: selectedType!);
        initialSetup()
    }
    
    func showDetails(index: Int)
    {
        audioTitle.text = playlist[index].name
        audioDescription.text = playlist[index].description
        
        //Set images
        
        let imageNamed = "\(playlist[index].name).png"
        let asanaImage: UIImage? = UIImage(named: imageNamed)
        soundURL = playlist[index].URL
        
        
        if asanaImage == nil {
            infoLabel.isHidden = true
        }
        else
        {
            imageView.image = asanaImage
        }
        
    }
    
    func initialSetup(){
        
        soundURL = playlist[counter].URL
        practiceRecording = AVPlayer(url: (soundURL)!)
        
    }
    
    func setNextAudio(){
        
        imageView.isHidden = true
        audioDescription.isHidden = false
        infoLabel.isHidden = false
        
        if (counter<=playlist.count-1){
            
            showDetails(index: counter)
            soundURL = playlist[counter].URL
            print("sound url comes next")
            print(playlist[counter].URL ?? "Wrong sound URL")
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
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertActionStyle.default,
                                          handler: {action in self.navigationController?.popToRootViewController(animated: false)}))
            self.present(alert, animated: true, completion: nil)
            
            counter = 0

        }
    }
    
    func goBack(){
        
    }
    
    func setObserver(){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.practiceRecording?.currentItem, queue: .main) { _ in
        self.counter += 1
        self.setNextAudio()
        }
    }
    
    func setPlaylist(type: String){
        switch type {
        case "Standard Class":
            playlist = StandardClass;
            playlist[0].URL=audios[0]
            playlist[1].URL=audios[1]
            playlist[2].URL=audios[2]
            playlist[3].URL=audios[3]
            playlist[4].URL=audios[4]
            playlist[5].URL=audios[5]
            playlist[6].URL=audios[6]
            playlist[7].URL=audios[7]
            playlist[8].URL=audios[8]
            playlist[9].URL=audios[9]
            playlist[10].URL=audios[10]
            playlist[11].URL=audios[11]
            playlist[12].URL=audios[12]
            playlist[13].URL=audios[13]
            playlist[14].URL=audios[14]
            playlist[15].URL=audios[15]
            playlist[16].URL=audios[16]
            playlist[17].URL=audios[17]
            playlist[18].URL=audios[18]
            playlist[19].URL=audios[19]
            playlist[20].URL=audios[20]
        case "Asana Class":
            playlist = AsanaClass;
            playlist[0].URL=audios[3]
            playlist[1].URL=audios[4]
            playlist[2].URL=audios[5]
            playlist[3].URL=audios[6]
            playlist[4].URL=audios[7]
            playlist[5].URL=audios[8]
            playlist[6].URL=audios[9]
            playlist[7].URL=audios[10]
            playlist[8].URL=audios[11]
            playlist[9].URL=audios[12]
            playlist[10].URL=audios[13]
            playlist[11].URL=audios[14]
            playlist[12].URL=audios[15]
            playlist[13].URL=audios[16]
            playlist[14].URL=audios[17]
            playlist[15].URL=audios[18]
            playlist[16].URL=audios[19]
            
            
            
        case "Pranayama Class":
            playlist = PranayamaClass;
            playlist[0].URL=audios[1]
            playlist[1].URL=audios[2]
        default:
            playlist = StandardClass;
        }
    }
    
    


    func gettingNames() {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        var audioString = [String]();
        var initURLArray = [URL?]();
        
        do {
            
            let audioPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for audio in audioPath {
                let myAudio = audio.absoluteString
                
                if myAudio.contains(".mp3")
                {
                    initURLArray.append(audio)
                    audioString.append(audio.absoluteString)
                }
            }
        }
        catch {
            // no catch ideas this time ;(
        }
        
        audioString.sort()
        
        for audioItem in audioString {
            audios.append(URL(string: audioItem))
        }
        //print(audios)
    }

    
    func savePractice() {
        TotalPracticeTime += CurrentPracticeTime
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let today = String(components.day!)+"-"+String(components.month!)+"-"+String(components.year!)
        //print("today: "+today)
        
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
                                                            //print("Error sending")
                                                        }
            })
            
        }
    }
    
    let StandardClass: Array<AudioFile> = [AudioFile(name: "Opening Prayer",
                                                     description: "At the beginning of any class, we chant the Dhyana Slokas. This helps to tune the mind to the divine in its different aspects. This chant invokes several energies to help us to remove obstacles, destroy all internal and external negative forces, guide us in our lives and bring auspiciousness for all our undertaking.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Kapalabhati",
                                                     description: "In Sanskrit, kapala means ‘skull’ and bhati means ‘shines’. Therefore the term Kapalabhati means an exercise that makes the skull shine. It is considered to be so cleansing to the entire system that, when practiced on a regular basis, the face shines with good health and radiance.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Anuloma Viloma",
                                                     description: "Anuloma Viloma, or Alternate Nostril Breathing, is one of the main forms of Prāṇāyāma, or breath control. Alternate Nostril Breathing corrects many negative breathing habits, as well as helping us to balance how we use the two sides of our brain – the logical left side and the creative right side.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "The Sun Salutation",
                                                     description: "The Sun Salutation is a 12-part warm-up exercise. It is a series of gentle flowing movements synchronized with the breath. The sun salutation gives an initial stretch to the body in preparation for the asanas proper. It helps to regulate the breathing and focus the mind. It also recharges the solar plexus and stimulates the cardio-vascular system.",
                                                     URL: nil),
                                        
                                           AudioFile(name: "Single leg raises",
                                                     description: "The legs exercises prepare the body for asanas, strenghtening in particular the abdominal and lower back muscles used to come up into the headstead and trimming the waist and thights. Regular practice of single leg raises helps to overcome muscles stiffness in the calf and hamstring muscles. The double leg raises helps strenghtening the abdominal muscles.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Double leg raises",
                                                     description: "The legs exercises prepare the body for asanas, strenghtening in particular the abdominal and lower back muscles used to come up into the headstead and trimming the waist and thights. Regular practice of single leg raises helps to overcome muscles stiffness in the calf and hamstring muscles. The double leg raises helps strenghtening the abdominal muscles.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Headstand",
                                                     description: "Known as the “King of the Āsanas” because of its remarkable benefits, the Headstand is the first of the 12 āsanas and is excellent for improving concentration, increasing memory, and transforming libido into powerful life force. In addition, people who practice Śīrṣāsana on a regular basis tend to have slower rates of respiration and heart rate.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Shoulderstand",
                                                     description: "This āsana strengthens the entire body; it gives many of the benefits of the Headstand, but here the circulation is directed to the thyroid gland instead of the head. The thyroid is an important gland of the endocrine system and this exercise gives it a rich supply of blood, improving the metabolism of every cell in the body. Other benefits include stimulating cheerfulness, promoting clear thinking, and helping to cure depression.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Plough",
                                                     description: "Halāsana, the Sanskrit name for the Plough, helps to keep the whole spine youthful. It stretches the back of the body completely which invigorates the entire spine. It also loosens tight hamstrings. It is said that he/she who practices Halāsana is very nimble, agile, and full of energy.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Fish",
                                                     description: "On the physical level this asana is very effective in correcting any tendency to round the shoulders as well as helping to tone the nerves of the neck and the back area. On the mental level, with chest stretched wide open, this āsana does wonders for opening our hearts to the world. After we practice Matsyāsana, we find that we experience a much deeper relaxation in the resting position of śavāsana.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Sitting Forward bend",
                                                     description: "This asana encourages conscious letting go by allowing gravity to pull the spine into the pose. As an added bonus, regular practice of Paścimottānāsana also helps to counter the typical postural problems developed working a desk job by keeping the spine supple, the joints mobile, the internal organs toned, and the nervous system invigorated.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Inclined Plane",
                                                     description: "The Inclined Plane is the counterpose to the Forward Bend. It complements the forward stretch that your body is given in the previous pose, and increase the strength and flexibility of your arms. In this āsana your hips are pushed upward, and your body is held straight and balanced on your hands and feet",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Cobra",
                                                     description: "Bhujaṅgāsana, or the Cobra, is practiced as the first in the series of backward-bending exercises. Major benefits of this āsana is that it works, massages, and tones the back muscles, particularly in the lumbar region. The arching of the spine also increases flexibility, rejuvenates spinal nerves, and provides a rich blood supply.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Locust",
                                                     description: "Of all the āsanas, Śalabhāsana is the one that works most on developing will power. The physical benefits of this pose is that all the internal organs are massaged, especially the pancreas, liver, and kidneys. It also gives a backward bend to the spine and opens the chest, bringing an increased blood supply to the neck and throat region.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Bow",
                                                     description: "The Bow works all parts of your back simultaneously, increasing suppleness in the spine and hips. In this āsana, our head, chest, and legs are lifted, while our body rests on our abdomen. Dhanurāsana combines and enhances the benefits of both the Cobra and the Locust. The whole body rests on the abdomen, giving a good massage to the abdominal region, especially the digestive organs.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Spinal twist",
                                                     description: "After the forward and backward bending of the spine, the Half Spinal Twist provides a lateral stretch which helps to relieve general lower back pain and muscular rheumatism of the back and hips. This āsana has many beneficial effects on the gall bladder, spleen, kidneys, liver, and intestines. The abdominal muscles are massaged and the large intestine in particular is stimulated. It helps to relieve constipation, indigestion, and other digestive issues.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Crow or Peacock",
                                                     description: "The Crow is one of the most beneficial of balancing poses. Besides increasing physical and mental balance, the Crow develops mental tranquility and also strengthens our arms, wrists, and shoulders. The muscles of fingers, wrists, and forearms are also stretched. Kakāsana helps to increase the powers of concentration and remove lethargy.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Standing forward bend",
                                                     description: "Pada Hastāsana, whose Sanskrit name literally means hands to foot pose, is a veritable elixir of youth. This pose quickly lengthens the muscles and ligaments of the entire posterior side of the body – from our heels to the middle of our back. The Standing Forward Bend stretches our spine and increase the blood supply to our brain.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Triangle",
                                                     description: "The triangle provides a very good lateral movement to the spine and stretches and strengthens several muscles on the side of the body at the same time. It also helps with balance. It augments the movement of the Half Spinal Twist.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Final relaxation",
                                                     description: "The class ends with a final relaxation that allows to release all tensions and to assimilate all the benefits of the class. The teacher guides you through the three levels of the relaxation process: physical relaxation, mental relaxation and spiritual relaxation.",
                                                     URL: nil),
                                           
                                           AudioFile(name: "Final Prayers",
                                                     description: "At the end of any class, we sing Maha Mrityunjaya Mantra. It is a life-giving mantra which has a great curative effect for diseases. Repeated every day, it will bestow on you health, long life, liberation and prosperity.",
                                                     URL: nil)]
    
    let PranayamaClass: Array<AudioFile> = [AudioFile(name: "Kapalabhati",
                                                      description: "In Sanskrit, kapala means ‘skull’ and bhati means ‘shines’. Therefore the term Kapalabhati means an exercise that makes the skull shine. It is considered to be so cleansing to the entire system that, when practiced on a regular basis, the face shines with good health and radiance.",
                                                      URL: nil),
                                            
                                            AudioFile(name: "Anuloma Viloma",
                                                      description: "Anuloma Viloma, or Alternate Nostril Breathing, is one of the main forms of Prāṇāyāma, or breath control. Alternate Nostril Breathing corrects many negative breathing habits, as well as helping us to balance how we use the two sides of our brain – the logical left side and the creative right side.",
                                                      URL: nil)]
    
    let AsanaClass: Array<AudioFile> = [AudioFile(name: "The Sun Salutation",
                                                 description: "The Sun Salutation is a 12-part warm-up exercise. It is a series of gentle flowing movements synchronized with the breath. The sun salutation gives an initial stretch to the body in preparation for the asanas proper. It helps to regulate the breathing and focus the mind. It also recharges the solar plexus and stimulates the cardio-vascular system.",
                                                 URL: nil),
                                        
                                        AudioFile(name: "Single leg raises",
                                                  description: "The legs exercises prepare the body for asanas, strenghtening in particular the abdominal and lower back muscles used to come up into the headstead and trimming the waist and thights. Regular practice of single leg raises helps to overcome muscles stiffness in the calf and hamstring muscles. The double leg raises helps strenghtening the abdominal muscles.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Double leg raises",
                                                  description: "The legs exercises prepare the body for asanas, strenghtening in particular the abdominal and lower back muscles used to come up into the headstead and trimming the waist and thights. Regular practice of single leg raises helps to overcome muscles stiffness in the calf and hamstring muscles. The double leg raises helps strenghtening the abdominal muscles.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Headstand",
                                                  description: "Known as the “King of the Āsanas” because of its remarkable benefits, the Headstand is the first of the 12 āsanas and is excellent for improving concentration, increasing memory, and transforming libido into powerful life force. In addition, people who practice Śīrṣāsana on a regular basis tend to have slower rates of respiration and heart rate.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Shoulderstand",
                                                  description: "This āsana strengthens the entire body; it gives many of the benefits of the Headstand, but here the circulation is directed to the thyroid gland instead of the head. The thyroid is an important gland of the endocrine system and this exercise gives it a rich supply of blood, improving the metabolism of every cell in the body. Other benefits include stimulating cheerfulness, promoting clear thinking, and helping to cure depression.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Plough",
                                                  description: "Halāsana, the Sanskrit name for the Plough, helps to keep the whole spine youthful. It stretches the back of the body completely which invigorates the entire spine. It also loosens tight hamstrings. It is said that he/she who practices Halāsana is very nimble, agile, and full of energy.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Fish",
                                                  description: "On the physical level this asana is very effective in correcting any tendency to round the shoulders as well as helping to tone the nerves of the neck and the back area. On the mental level, with chest stretched wide open, this āsana does wonders for opening our hearts to the world. After we practice Matsyāsana, we find that we experience a much deeper relaxation in the resting position of śavāsana.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Sitting Forward bend",
                                                  description: "This asana encourages conscious letting go by allowing gravity to pull the spine into the pose. As an added bonus, regular practice of Paścimottānāsana also helps to counter the typical postural problems developed working a desk job by keeping the spine supple, the joints mobile, the internal organs toned, and the nervous system invigorated.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Inclined Plane",
                                                  description: "The Inclined Plane is the counterpose to the Forward Bend. It complements the forward stretch that your body is given in the previous pose, and increase the strength and flexibility of your arms. In this āsana your hips are pushed upward, and your body is held straight and balanced on your hands and feet",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Cobra",
                                                  description: "Bhujaṅgāsana, or the Cobra, is practiced as the first in the series of backward-bending exercises. Major benefits of this āsana is that it works, massages, and tones the back muscles, particularly in the lumbar region. The arching of the spine also increases flexibility, rejuvenates spinal nerves, and provides a rich blood supply.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Locust",
                                                  description: "Of all the āsanas, Śalabhāsana is the one that works most on developing will power. The physical benefits of this pose is that all the internal organs are massaged, especially the pancreas, liver, and kidneys. It also gives a backward bend to the spine and opens the chest, bringing an increased blood supply to the neck and throat region.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Bow",
                                                  description: "The Bow works all parts of your back simultaneously, increasing suppleness in the spine and hips. In this āsana, our head, chest, and legs are lifted, while our body rests on our abdomen. Dhanurāsana combines and enhances the benefits of both the Cobra and the Locust. The whole body rests on the abdomen, giving a good massage to the abdominal region, especially the digestive organs. ",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Spinal twist",
                                                  description: "After the forward and backward bending of the spine, the Half Spinal Twist provides a lateral stretch which helps to relieve general lower back pain and muscular rheumatism of the back and hips. This āsana has many beneficial effects on the gall bladder, spleen, kidneys, liver, and intestines. The abdominal muscles are massaged and the large intestine in particular is stimulated. It helps to relieve constipation, indigestion, and other digestive issues.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Crow or Peacock",
                                                  description: "The Crow is one of the most beneficial of balancing poses. Besides increasing physical and mental balance, the Crow develops mental tranquility and also strengthens our arms, wrists, and shoulders. The muscles of fingers, wrists, and forearms are also stretched. Kakāsana helps to increase the powers of concentration and remove lethargy.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Standing forward bend",
                                                  description: "Pada Hastāsana, whose Sanskrit name literally means hands to foot pose, is a veritable elixir of youth. This pose quickly lengthens the muscles and ligaments of the entire posterior side of the body – from our heels to the middle of our back. The Standing Forward Bend stretches our spine and increase the blood supply to our brain.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Triangle",
                                                  description: "The triangle provides a very good lateral movement to the spine and stretches and strengthens several muscles on the side of the body at the same time. It also helps with balance. It augments the movement of the Half Spinal Twist.",
                                                  URL: nil),
                                        
                                        AudioFile(name: "Final relaxation",
                                                  description: "The class ends with a final relaxation that allows to release all tensions and to assimilate all the benefits of the class. The teacher guides you through the three levels of the relaxation process: physical relaxation, mental relaxation and spiritual relaxation.",
                                                  URL: nil)
                                        ]
    
    
    @objc func counterTimer() {
        
        CurrentPracticeTime += 1
        //print(CurrentPracticeTime)
    }
    
    
}
