//
//  ShowDataTest1ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 07.05.21.
//

import UIKit

class ShowDataExercise3ViewController: UIViewController {
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var sadLabel: UILabel!
    @IBOutlet weak var angryLabel: UILabel!
    @IBOutlet weak var surprisedLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    @IBOutlet weak var fearLabel: UILabel!
    @IBOutlet weak var disgustLabel: UILabel!
    @IBOutlet weak var contemptLabel: UILabel!
    var recognitionTest: Exercise3?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let age = recognitionTest?.age ?? 0 //Is not needed anymore so setting it to zero for all users until taken out
        let ageText = String(age)
        ageLabel.text = ageText
        happyLabel.text = "\((recognitionTest?.emotionList[1].recognized.description) ?? "error") - \(recognitionTest?.emotionList[1].recognizedEmotion ?? "error")"
        // happyLabel.text = "\(happyRec) - \(happyEmo)"
        sadLabel.text = "\((recognitionTest?.emotionList[2].recognized.description) ?? "error") - \(recognitionTest?.emotionList[2].recognizedEmotion ?? "error")"
        angryLabel.text = "\((recognitionTest?.emotionList[3].recognized.description) ?? "error") - \(recognitionTest?.emotionList[3].recognizedEmotion ?? "error")"
        surprisedLabel.text = "\((recognitionTest?.emotionList[4].recognized.description) ?? "error") - \(recognitionTest?.emotionList[4].recognizedEmotion ?? "error")"
        neutralLabel.text = "\((recognitionTest?.emotionList[0].recognized.description) ?? "error") - \(recognitionTest?.emotionList[0].recognizedEmotion ?? "error")"
        fearLabel.text = "\((recognitionTest?.emotionList[5].recognized.description) ?? "error") - \(recognitionTest?.emotionList[5].recognizedEmotion ?? "error")"
        disgustLabel.text = "\((recognitionTest?.emotionList[6].recognized.description) ?? "error") - \(recognitionTest?.emotionList[6].recognizedEmotion ?? "error")"
        contemptLabel.text = "\((recognitionTest?.emotionList[7].recognized.description) ?? "error") - \(recognitionTest?.emotionList[7].recognizedEmotion ?? "error")"
        navigationItem.hidesBackButton = true
    }
}
