//
//  FinishTest1ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 30.04.21.
//

import UIKit

class FinishExercise3ViewController: UIViewController {
    
    var recognitionTest: Exercise3?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var emotions: Array<Emotion> = recognitionTest!.emotionList
        var data = ""
        for emotion in emotions {
            data.append(emotion.name + " " + emotion.recognized.description + " ")
        }
        navigationItem.hidesBackButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ShowDataExercise3ViewController
        destination.recognitionTest = recognitionTest
    }
}
