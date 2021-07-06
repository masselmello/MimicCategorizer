//
//  FinishTest3ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 30.05.21.
//

import UIKit

class FinishExercise4ViewController: UIViewController {
    
    var recognitionTest: Exercise4?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ShowDataExercise4ViewController
        destination.recognitionTest = recognitionTest
    }
    
}
