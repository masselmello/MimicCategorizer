//
//  FinishTest2ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 26.05.21.
//

import UIKit

class FinishExercise1ViewController: UIViewController {
    var recognitionTest: Exercise1?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ShowDataExercise1ViewController
        destination.recognitionTest = recognitionTest
    }
}
