//
//  MimicTest1ViewController.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 29.04.21.
//

import UIKit
import SceneKit
import ARKit
import CoreData

class Exercise1ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var outPutLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var feedBackView: UIView!
    var emotions: [NSManagedObject] = []
    var recognitionTest: Exercise1? = Exercise1()
    var facePoseResult = ""
    var facePoseID = 0;
    var wantedPose = 0
    var faceAnalyzer = FACSFaceAnalyzer()
    var currentImage = 0
    private var recognitionOn = false
    @IBOutlet weak var testImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentImage()
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking not available on this on this device model!")
        }
        
        outputView.layer.cornerRadius = 15
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        changeExerciseText(emotion: recognitionTest?.getCurrentEmotionName() ?? "unknown")
        navigationItem.hidesBackButton = true
    }
    
    
    // MARK: - Navigation
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        recognitionOn = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func neutralButtonClick(_ sender: Any) {
        recognitionTest?.neutralUserReaction()
        currentImage += 1
        if(self.recognitionTest?.imageList.endIndex ?? self.currentImage == self.currentImage){
            endTest()
        }else{
            loadCurrentImage()
        }
        /*if(endTest){
         nextButton.isEnabled = false
         performSegue(withIdentifier: "finishTest1", sender: nil)
         }*/
        //changeExerciseText(emotion: recognitionTest?.getCurrentEmotionName() ?? "unknown")
    }
    @IBAction func positiveButtonClick(_ sender: Any) {
        recognitionTest?.positiveUserReaction()
        currentImage += 1
        if(self.recognitionTest?.imageList.endIndex ?? self.currentImage == self.currentImage){
            endTest()
        }else{
            sceneView.session.pause()
            feedBackView.isHidden = false
            positiveButton.isEnabled = false
            negativeButton.isEnabled = false
            neutralButton.isEnabled = false
            pauseRecognition()
            loadCurrentImage()
        }
    }
    @IBAction func negativeButtonClick(_ sender: Any) {
        recognitionTest?.negativeUserReaction()
        currentImage += 1
        if((self.recognitionTest?.imageList.endIndex ?? self.currentImage) == self.currentImage){
            endTest()
        }else {
            pauseRecognition()
            loadCurrentImage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FinishExercise1ViewController
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
            recognitionTest?.measureTime(facePoseID: facePoseID)
            
            DispatchQueue.main.async {
                self.outPutLabel.text = self.recognitionTest?.emotionList[self.facePoseID].name
            }
            
        }
    }
    
    func nextExercise(currentExerciseID: Int){
        
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
        exerciseLabel.text = exerciseText
    }
    
    func loadCurrentImage(){
        let image: UIImage = UIImage(named: (self.recognitionTest?.imageList[self.currentImage])!)!
        self.testImage.image = image
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `1.0` to the desired number of seconds.
            self.runRecognition()
        }
    }
    
    func endTest(){
        performSegue(withIdentifier: "finishTest2", sender: nil)
    }
    
    func runRecognition(){
        let configuration = ARFaceTrackingConfiguration()
        self.sceneView.session.run(configuration)
        self.feedBackView.isHidden = true
        self.positiveButton.isEnabled = true
        self.negativeButton.isEnabled = true
        self.neutralButton.isEnabled = true
        recognitionOn = true
    }
    
    func pauseRecognition(){
        sceneView.session.pause()
        feedBackView.isHidden = false
        positiveButton.isEnabled = false
        negativeButton.isEnabled = false
        neutralButton.isEnabled = false
        recognitionOn = false
    }
    
}
