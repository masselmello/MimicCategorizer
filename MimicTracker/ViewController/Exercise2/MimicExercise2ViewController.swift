//
//  MimicTest4ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 14.06.21.
//

import UIKit
import SceneKit
import ARKit
import CoreData

class MimicExercise2ViewController: UIViewController, ARSCNViewDelegate{
    //
    //  MimicTest1ViewController.swift
    //  MimicTracker
    //
    //  Created by Marcel Knupfer on 29.04.21.
    //
/*
        @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sceneView: UIImageView!
    @IBOutlet weak var outPutLabel: UILabel!
        @IBOutlet weak var exerciseLabel: UILabel!
        @IBOutlet weak var outputView: UIView!
        @IBOutlet weak var feedBackView: UIView!
        @IBOutlet weak var nextButton: UIButton!
 */
    /*@IBOutlet weak var outputView: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var outPutLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var testImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var feedBackView: UIView!
 */
    
    

    @IBOutlet weak var myScene: ARSCNView!
    @IBOutlet weak var myImage: UIImageView!
    
    var emotions: [NSManagedObject] = []
        var recognitionTest: Exercise2? = Exercise2()
        var facePoseResult = ""
        var facePoseID = 0;
        var wantedPose = 0
        var faceAnalyzer = FACSFaceAnalyzer()
        var currentImage = 0
        private var recognitionOn = false
    
    
        var end = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            loadCurrentImage()
            guard ARFaceTrackingConfiguration.isSupported else {
                fatalError("Face tracking not available on this on this device model!")
            }
            
           // outputView.layer.cornerRadius = 15
            // Set the view's delegate
            myScene.delegate = self
            
            // Show statistics such as fps and timing information
            myScene.showsStatistics = true
            changeExerciseText(emotion: recognitionTest?.getCurrentEmotionName() ?? "unknown")
            navigationItem.hidesBackButton = true
        }
        
        
        // MARK: - Navigation
        
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARFaceTrackingConfiguration()
            
            // Run the view's session
            myScene.session.run(configuration)
            recognitionOn = true
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            myScene.session.pause()
        }
    
    @IBAction func nextClick(_ sender: Any) {
        pauseRecognition()
        var feedback = recognitionTest?.calcUserFeedbackFromMimic() ?? 0
        currentImage += 1
        if(self.recognitionTest?.imageList.endIndex ?? self.currentImage == self.currentImage){
            end = true
           showAlert(feedback: feedback)
        }else{
           // loadCurrentImage()
            showAlert(feedback: feedback)
        }
    }

        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destination = segue.destination as! FinishExercise2ViewController
            destination.recognitionTest = recognitionTest
        }
        // MARK: - ARSCNViewDelegate
        
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let faceMesh = ARSCNFaceGeometry(device: myScene.device!)
            let node = SCNNode(geometry: faceMesh)
            node.geometry?.firstMaterial?.fillMode = .lines
            return node
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
                faceGeometry.update(from: faceAnchor.geometry)
                facePoseID = faceAnalyzer.analyzeFacePose(anchor: faceAnchor)
                recognitionTest?.measureTime(facePoseID: facePoseID)
                
                DispatchQueue.main.async {
                    //self.outPutLabel.text = self.recognitionTest?.emotionList[self.facePoseID].name
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
        
        func changeExerciseText(emotion: String){
            var exerciseText = "Bitte mach ein Gesicht passend zur Emotion: "
            exerciseText = exerciseText.appending(emotion)
            //exerciseLabel.text = exerciseText
        }
        
        func loadCurrentImage(){
            let image: UIImage = UIImage(named: (self.recognitionTest?.imageList[self.currentImage])!)!
            self.myImage.image = image
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                self.runRecognition()
            }
        }
        
        func endTest(){
            performSegue(withIdentifier: "finishTest4", sender: nil)
        }
        
        func runRecognition(){
            let configuration = ARFaceTrackingConfiguration()
            self.myScene.session.run(configuration)
            //self.feedBackView.isHidden = true
            recognitionOn = true
        }
        
        func pauseRecognition(){
            myScene.session.pause()
            //feedBackView.isHidden = false
            recognitionOn = false
        }
    
    /**
     Alert that get shown to gather user feedback if the recognition did what the user wanted
     */
    func showAlert(feedback: Int){
        var positiveOrNegative = "weder positiv noch negativ"
        if(feedback == -1){
            positiveOrNegative = "negativ"
        }
        
        if(feedback == 1){
            positiveOrNegative = "positiv"
        }
        let alert = UIAlertController(title: "Feedback", message: "Du fandest den letzten Inhalt \(positiveOrNegative). Ist das korrekt?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { action in
            self.recognitionTest?.gotUserCorrectionRight()
            self.recognitionTest?.nextButtonClick(feedBack: feedback)
            if(!self.end){
                self.loadCurrentImage()
            }else{
                self.endTest()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Nein", style: .default, handler: { action in
            self.recognitionTest?.gotUserReactionWrong()
            self.recognitionTest?.nextButtonClick(feedBack: feedback)
            if(!self.end){
                self.loadCurrentImage()
            }else{
                self.endTest()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


