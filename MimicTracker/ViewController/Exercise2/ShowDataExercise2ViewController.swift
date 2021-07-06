//
//  ShowDataTest4ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 14.06.21.
//

import UIKit

class ShowDataExercise2ViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    var recognitionTest: Exercise2?
    override func viewDidLoad() {
        super.viewDidLoad()
        var dataString = ""
        let imageNumberList = recognitionTest!.imageList
        let measuredReactions = recognitionTest!.measuredReactions
        let correctReactions = recognitionTest!.correctReaction
        for (index, _) in imageNumberList.enumerated(){
            dataString.append("Image:   \(index)  Measured Reaction: \(measuredReactions[index]) Correct: \(correctReactions[index]) \n")
        }
        outputLabel.text = dataString
        navigationItem.hidesBackButton = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
