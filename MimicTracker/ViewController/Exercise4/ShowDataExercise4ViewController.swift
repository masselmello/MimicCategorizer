//
//  ShowDataTest3ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 30.05.21.
//

import UIKit

class ShowDataExercise4ViewController: UIViewController {
    @IBOutlet weak var outPutLabel: UILabel!
    var recognitionTest: Exercise4?
    override func viewDidLoad() {
        super.viewDidLoad()
        var dataString = ""
        let imageNumberList = recognitionTest!.imageList
        let measuredReactions = recognitionTest!.measuredReactions
        let correctReactions = recognitionTest!.correctReaction
        for (index, _) in imageNumberList.enumerated(){
            dataString.append("Image:   \(index)  Measured Reaction: \(measuredReactions[index]) Correct: \(correctReactions[index]) \n")
        }
        outPutLabel.text = dataString
        navigationItem.hidesBackButton = true
    }
    
}
