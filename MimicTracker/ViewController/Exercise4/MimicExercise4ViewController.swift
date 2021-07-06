//
//  MimicTest3ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 30.05.21.
//

import UIKit
import SceneKit
import ARKit
import CoreData

class MimicExercise4ViewController: UIViewController , ARSCNViewDelegate{
    
    
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    var emotions: [NSManagedObject] = []
    var recognitionTest: Exercise4? = Exercise4()
    var facePoseResult = ""
    var facePoseID = Emotion.neutralID
    var wantedPose = Emotion.neutralID
    var faceAnalyzer = FACSFaceAnalyzer()
    var currentImage = 0
    var endIndex = 0
    var lock = false
    var lastUserFeedback = 0
    var end = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking not available on this on this device model!")
        }
        
        outputView.layer.cornerRadius = 15
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        navigationItem.hidesBackButton = true
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        
        // Run the view's session
        //sceneView.session.run(configuration)
        loadCurrentImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FinishExercise4ViewController
        destination.recognitionTest = recognitionTest
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceMesh = ARSCNFaceGeometry(device: sceneView.device!)
        let node = SCNNode(geometry: faceMesh)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
            facePoseID = faceAnalyzer.analyzeFacePose(anchor: faceAnchor)
            
            DispatchQueue.main.async {
                //self.outputLabel.text = self.recognitionTest?.emotionList[self.facePoseID].name
                var reaction = self.recognitionTest?.measureReaction(facePoseID: self.facePoseID)
                switch reaction {
                case 1:
                    print("happy")
                    //Pause the recognition
                    self.sceneView.session.pause()
                    //saving last User feedback for the alert
                    self.lastUserFeedback = 1
                    self.currentImage += 1
                    self.recognitionTest?.positiveUserReaction()
                    self.endIndex = self.recognitionTest?.imageList.endIndex ?? 0
                    
                    if(self.endIndex == self.currentImage){
                        print("Ending test")
                        //end is now true test will be ended after Alert Action
                        self.end = true
                        self.showAlert()
                    }else{
                        print("Not ending...Load next image")
                        self.showAlert()
                    }
                case -1:
                    
                    print("disgust")
                    //Pause the recognition
                    self.sceneView.session.pause()
                    //saving last User feedback for the alert
                    self.lastUserFeedback = -1
                    self.currentImage += 1
                    self.recognitionTest?.negativeUserReaction()
                    self.endIndex = self.recognitionTest?.imageList.endIndex ?? 0
                    if(self.endIndex == self.currentImage){
                        print("Ending test")
                        //end is now true test will be ended after Alert Action
                        self.end = true
                        self.showAlert()
                    }else{
                        print("Not ending...Load next image")
                        self.showAlert()
                    }
                default:
                    print("do  nothing")
                }
            }
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    /**
     Loads the next image
     */
    func loadCurrentImage(){
        //self.currentImage += 1
        let image: UIImage = UIImage(named: (recognitionTest?.imageList[currentImage])!)!
        // Do any additional setup after loading the view.
        testImage.image = image
        lock = false
        timer()
        //Wait 7 seconds before restarting the recognition so user can have a look at the picture to minimize error due to micro expressions while thinking
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            let configuration = ARFaceTrackingConfiguration()
            //Start recognition again
            self.sceneView.session.run(configuration)
        }
    }
    
    /**
     Ends the test and launches the end screen
     */
    func endTest(){
        performSegue(withIdentifier: "finishTest3", sender: nil)
    }
    
    /**
     Creates a timer of 5 seconds before starting the recognition so the user can see how long he or she can look at the picture before adjusting his facial expression to minimize error due to micro expressions while thinking
     */
    func timer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.timeLabel.text = "5"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.timeLabel.text = "4"
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.timeLabel.text = "3"
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.timeLabel.text = "2"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.timeLabel.text = "1"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            self.timeLabel.text = "0"
        }
    }
    
    
    /**
     Alert that get shown to gather user feedback if the recognition did what the user wanted
     */
    func showAlert(){
        var positiveOrNegative = "neutral"
        if(lastUserFeedback == -1){
            positiveOrNegative = "negativ"
        }
        
        if(lastUserFeedback == 1){
            positiveOrNegative = "positiv"
        }
        let alert = UIAlertController(title: "Feedback", message: "Du hast das letzte Bild als \(positiveOrNegative) markiert. Ist das korrekt?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            self.recognitionTest?.gotUserCorrectionRight()
            if(!self.end){
                self.loadCurrentImage()
            }else{
                self.endTest()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Nein", style: .default, handler: { action in
            self.recognitionTest?.gotUserReactionWrong()
            if(!self.end){
                self.loadCurrentImage()
            }else{
                self.endTest()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }    
}
