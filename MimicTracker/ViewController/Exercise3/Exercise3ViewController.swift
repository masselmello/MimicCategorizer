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

class Exercise3ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var outPutLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    var emotions: [NSManagedObject] = []
    var recognitionTest: Exercise3? = nil
    var facePoseResult = ""
    var facePoseID = Emotion.neutralID
    var wantedPose = Emotion.neutralID
    var faceAnalyzer = FACSFaceAnalyzer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        guard let endTest = recognitionTest?.nextTest(currentMimicID: facePoseID) else { return  }
        
        if(endTest){
            nextButton.isEnabled = false
            performSegue(withIdentifier: "finishTest1", sender: nil)
        }
        changeExerciseText(emotion: recognitionTest?.getCurrentEmotionName() ?? "unknown")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FinishExercise3ViewController
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
                self.outPutLabel.text = self.recognitionTest?.emotionList[self.facePoseID].name
            }
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Error in Face tracking")
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session was interrupted")
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session interruption ended")
        
    }
    
    func changeExerciseText(emotion: String){
        var exerciseText = "Bitte mach ein Gesicht passend zur Emotion: "
        exerciseText = exerciseText.appending(emotion)
        exerciseLabel.text = exerciseText
    }
    
}
