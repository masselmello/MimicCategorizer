//
//  FinishTest4ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 14.06.21.
//

import UIKit

class FinishExercise2ViewController: UIViewController {

    var recognitionTest: Exercise2?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ShowDataExercise2ViewController
        destination.recognitionTest = recognitionTest
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
