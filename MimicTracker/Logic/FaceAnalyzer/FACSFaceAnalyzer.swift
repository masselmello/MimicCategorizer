//
//  FaceAnalyzerFACS2.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 12.06.21.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import CoreData

class FACSFaceAnalyzer{

    var facePoseID = 0;
    var facePoseResult = ""
    var emotionNamesAndIDs = [Int : String]()
    
    init() {
        emotionNamesAndIDs[Emotion.neutralID] = "Neutral"
        emotionNamesAndIDs[Emotion.happyID] = "Freude"
        emotionNamesAndIDs[Emotion.sadID] = "Traurigkeit"
        emotionNamesAndIDs[Emotion.angryID] = "Wut"
        emotionNamesAndIDs[Emotion.surpriseID] = "Überraschung"
        emotionNamesAndIDs[Emotion.fearID] = "Angst"
        emotionNamesAndIDs[Emotion.disgustID] = "Ekel"
        emotionNamesAndIDs[Emotion.contemptID] = "Verachtung"
    }
    
    func analyzeFacePose(anchor: ARFaceAnchor) -> Int {
        var emotionsAndRates = [Int : Decimal]()
        
        emotionsAndRates[Emotion.fearID] = checkFear(anchor: anchor)
        emotionsAndRates[Emotion.surpriseID] = checkSurprise(anchor: anchor)
        emotionsAndRates[Emotion.happyID] = checkHappy(anchor: anchor)
        emotionsAndRates[Emotion.sadID] = checkSadness(anchor: anchor)
        emotionsAndRates[Emotion.angryID] = checkAnger(anchor: anchor)
        emotionsAndRates[Emotion.disgustID] = checkDisgust(anchor: anchor)
        emotionsAndRates[Emotion.contemptID] = checkContempt(anchor: anchor)
        
        let mostProbably = emotionsAndRates.max{ a, b in a.value < b.value }
        
        if(mostProbably?.value ?? 0 > 0.1){
            facePoseResult = emotionNamesAndIDs[mostProbably?.key ?? Emotion.neutralID] ?? "Neutral"
            return mostProbably?.key ?? Emotion.neutralID
        }
        return 0
    }

    //CHECK FUNCTIONS FOR THE SIX PRIMARY EMOTIONS
    
    //Surprise
    func checkSurprise(anchor: ARFaceAnchor)-> Decimal{

        let browInnerUp = anchor.blendShapes[.browInnerUp]?.decimalValue ?? 0
        let browUpLeft = anchor.blendShapes[.browOuterUpLeft]?.decimalValue ?? 0
        let browUpRight = anchor.blendShapes[.browOuterUpRight]?.decimalValue ?? 0
        let eyeWideRight = anchor.blendShapes[.eyeWideRight]?.decimalValue ?? 0
        let eyeWideLeft = anchor.blendShapes[.eyeWideLeft]?.decimalValue ?? 0
        let jawOpen = anchor.blendShapes[.jawOpen]?.decimalValue ?? 0
        
        let browsUp =  max(browUpLeft, browUpRight)
        let eyesWide = max(eyeWideLeft, eyeWideRight)
        
        let surpriseRate = (browsUp + eyesWide + browInnerUp + jawOpen) / 4
        
        return surpriseRate
    }
    
    //Happiness
    func checkHappy(anchor: ARFaceAnchor) -> Decimal {
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]?.decimalValue ?? 0
        let smileRight = anchor.blendShapes[.mouthSmileRight]?.decimalValue ?? 0
        let cheekSquintRight = anchor.blendShapes[.cheekSquintRight]?.decimalValue ?? 0
        let cheekSquintLeft = anchor.blendShapes[.cheekSquintLeft]?.decimalValue ?? 0
        
        let cheekSquint = max(cheekSquintRight, cheekSquintLeft)
        let smile = max(smileLeft, smileRight)
        let happyRate = (cheekSquint + smile)/2
        
        return happyRate
    }
    
    //Sadness
    func checkSadness(anchor: ARFaceAnchor) -> Decimal {
        let browInnerUp = anchor.blendShapes[.browInnerUp]?.decimalValue ?? 0
        let mouthDownRight = anchor.blendShapes[.mouthFrownRight]?.decimalValue ?? 0
        let mouthDownLeft = anchor.blendShapes[.mouthFrownLeft]?.decimalValue ?? 0
        let browDownLeft = anchor.blendShapes[.browDownLeft]?.decimalValue ?? 0
        let browDownRight = anchor.blendShapes[.browDownRight]?.decimalValue ?? 0
        
        let mouthDown = max(mouthDownRight, mouthDownLeft)
        let browDown = max(browDownLeft, browDownRight)
        
        let sadnessRate = (browInnerUp + mouthDown + browDown) / 3
        
        return sadnessRate
    }
    
    //Anger
    func checkAnger(anchor: ARFaceAnchor) -> Decimal {
        let eyeWideRight = anchor.blendShapes[.eyeWideRight]?.decimalValue ?? 0
        let eyeWideLeft = anchor.blendShapes[.eyeWideLeft]?.decimalValue ?? 0
        let eyeSquintRight = anchor.blendShapes[.eyeSquintRight]?.decimalValue ?? 0
        let eyeSquintLeft = anchor.blendShapes[.eyeSquintLeft]?.decimalValue ?? 0
        let browDownLeft = anchor.blendShapes[.browDownLeft]?.decimalValue ?? 0
        let browDownRight = anchor.blendShapes[.browDownRight]?.decimalValue ?? 0
        let lipsDrawnBackLeft = anchor.blendShapes[.mouthPressLeft]?.decimalValue ?? 0
        let lipsDrawnBackRight = anchor.blendShapes[.mouthPressRight]?.decimalValue ?? 0
        
        let browDown = max(browDownLeft, browDownRight)
        let eyesWide = max(eyeWideLeft, eyeWideRight)
        let eyeSquint = max(eyeSquintRight, eyeSquintLeft)
        let lipsDrawnBack = max(lipsDrawnBackLeft, lipsDrawnBackRight)
        
        let angerRate = (browDown + eyesWide + eyeSquint + lipsDrawnBack) / 4
        
        return angerRate
    }
    
    //Fear
    func checkFear(anchor: ARFaceAnchor) -> Decimal {
        let browInnerUp = anchor.blendShapes[.browInnerUp]?.decimalValue ?? 0
        let browUpLeft = anchor.blendShapes[.browOuterUpLeft]?.decimalValue ?? 0
        let browUpRight = anchor.blendShapes[.browOuterUpRight]?.decimalValue ?? 0
        let eyeWideLeft = anchor.blendShapes[.eyeWideLeft]?.decimalValue ?? 0
        let eyeWideRight = anchor.blendShapes[.eyeWideRight]?.decimalValue ?? 0
        let eyeSquintRight = anchor.blendShapes[.eyeSquintRight]?.decimalValue ?? 0
        let eyeSquintLeft = anchor.blendShapes[.eyeSquintLeft]?.decimalValue ?? 0
        let mouthStretchRight = anchor.blendShapes[.mouthStretchRight]?.decimalValue ?? 0
        let mouthStretchLeft = anchor.blendShapes[.mouthStretchLeft]?.decimalValue ?? 0
        let jawOpen = anchor.blendShapes[.jawOpen]?.decimalValue ?? 0
        
        let eyesWide = max(eyeWideLeft, eyeWideRight)
        let eyeSquint = max(eyeSquintRight, eyeSquintLeft)
        let mouthStretch = max(mouthStretchLeft, mouthStretchRight)
        let browsUp =  max(browUpLeft, browUpRight)
        
        let fearRate = (browInnerUp + browsUp + eyesWide + eyeSquint + mouthStretch + jawOpen) / 6
        
        return fearRate
    }
    
    //Disgust
    func checkDisgust(anchor: ARFaceAnchor) -> Decimal{
        let noseSneerRight = anchor.blendShapes[.noseSneerRight]?.decimalValue ?? 0
        let noseSneerLeft = anchor.blendShapes[.noseSneerLeft]?.decimalValue ?? 0
        let mouthDownRight = anchor.blendShapes[.mouthFrownRight]?.decimalValue ?? 0
        let mouthDownLeft = anchor.blendShapes[.mouthFrownLeft]?.decimalValue ?? 0
        let mouthLowerDownLeft = anchor.blendShapes[.mouthLowerDownLeft]?.decimalValue ?? 0
        let mouthLowerDownRight = anchor.blendShapes[.mouthLowerDownRight]?.decimalValue ?? 0
        
        let mouthDown = max(mouthDownRight, mouthDownLeft)
        let mouthLowerDown = max(mouthLowerDownLeft, mouthLowerDownRight)
        let noseSneer = max(noseSneerLeft, noseSneerRight)
        
        let disgustRate = (mouthDown + mouthLowerDown + noseSneer) / 3
        
        return disgustRate
    }
    
    //Contempt
    func checkContempt(anchor: ARFaceAnchor) -> Decimal{
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]?.decimalValue ?? 0
        let smileRight = anchor.blendShapes[.mouthSmileRight]?.decimalValue ?? 0
        let mouthDimpleRight = anchor.blendShapes[.mouthDimpleRight]?.decimalValue ?? 0
        let mouthDimpleLeft = anchor.blendShapes[.mouthDimpleLeft]?.decimalValue ?? 0
        
        let smile = max(smileLeft, smileRight)
        let mouthDimple = max(mouthDimpleLeft, mouthDimpleRight)
        
        let contemptrate = (smile + mouthDimple) / 2
        
        return contemptrate
    }
}

