//
//  ShowDataTest2ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 26.05.21.
//

import UIKit

class ShowDataExercise1ViewController: UIViewController {
    var recognitionTest: Exercise1?
    @IBOutlet weak var dataLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var dataString = ""
        let imageNumberList = recognitionTest!.imageList
        for (index, _) in imageNumberList.enumerated(){
            let userReactions = recognitionTest!.userReactions
            let measuredReactions = recognitionTest!.measuredReactions
            dataString.append("Image:   \(index)  User Reaction:  \(userReactions[index]) Measured Reaction: \(measuredReactions[index]) \n")
        }
        dataLabel.text = dataString
        navigationItem.hidesBackButton = true
    }
}
