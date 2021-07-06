//
//  RecognitionTest.swift
//  MimicTracker
//
// This is the first test to  check the functionality of the emotion recognition
//
//  Created by Marcel Knupfer on 30.04.21.
//

import Foundation

class Exercise3 {
    var age: Int
    var emotionList: Array<Emotion> = [Emotion]()
    var currentEmotion = 0
    
    init(age: Int){
        //emotionList = emotions
        self.age = age
        initializeEmotions()
    }
    
    //Initialize emotions for test 1
    func initializeEmotions(){
        let happy = Emotion(name: "Freude", id: Emotion.happyID )
        let sad = Emotion(name: "Traurigkeit", id: Emotion.sadID)
        let angry = Emotion(name: "Wut", id: Emotion.angryID)
        let surprised = Emotion(name: "Überraschung", id: Emotion.surpriseID)
        let neutral = Emotion(name: "neutral", id: Emotion.neutralID)
        let fear = Emotion(name:"Angst", id: Emotion.fearID)
        let disgust = Emotion(name: "Ekel", id: Emotion.disgustID)
        let contempt = Emotion(name: "Verachtung", id: Emotion.contemptID)
        
        emotionList.append(neutral)
        emotionList.append(happy)
        emotionList.append(sad)
        emotionList.append(angry)
        emotionList.append(surprised)
        emotionList.append(fear)
        emotionList.append(disgust)
        emotionList.append(contempt)
        
    }
    
    /**
     Calls next test and saves if emotion was recognized
     */
    func nextTest(currentMimicID: Int) -> Bool{
        
        //The wanted emotion is the same as the one recognized
        if(currentMimicID == currentEmotion){
            if let index = emotionList.index(where: {$0.id == currentEmotion}){
                emotionList[index].recognized = true
                emotionList[index].recognizedEmotion = emotionList[currentMimicID].name
            }
            if(currentEmotion < emotionList.count - 1){
                currentEmotion+=1
                return false
            }
            return true
        }
        
        //The wanted emotion is NOT the same as the one recognized
        if let index = emotionList.index(where: {$0.id == currentEmotion}){
            emotionList[index].recognizedEmotion = emotionList[currentMimicID].name
        }
        
        if(currentEmotion < emotionList.count - 1){
            
            currentEmotion+=1
            return false
        }
        return true
    }
    
    func getCurrentEmotionName() -> String {
        if let index = emotionList.index(where: {$0.id == currentEmotion}){
            return emotionList[index].name
        }
        return "unknown"
    }
    
    
}
