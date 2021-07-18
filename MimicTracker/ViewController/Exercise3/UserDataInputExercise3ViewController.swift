//
//  UserDataInputTest1ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 29.04.21.
//

import UIKit

class UserDataInputExercise3ViewController: UIViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nutzerdaten"
        
        //Tries to recognize any taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        /*
         self.ageTextField.delegate = self
         ageTextField.keyboardType = .numberPad
         */
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /**
     // Dismiss keyboard
     */
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let age: Int? = 0
        let recognitionTest = Exercise3(age: age ?? 0)
        let destination = segue.destination as! Exercise3ViewController
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
