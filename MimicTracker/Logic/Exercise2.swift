//
//  Test4.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 14.06.21.
//

//
//  Test4.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 30.05.21.
//

import Foundation

class Exercise2 {
    var emotionList: Array<Emotion> = [Emotion]()
    var imageList: Array<String> = [String]()
    var measuredReactions: Array<Int> = [Int]()
    var correctReaction: Array<Bool> = [Bool]()
    var userReactions: Array<Int> = [Int]()
    var currentEmotion = 0
    private var neutralTime = 0
    private var happyTime = 0
    private var sadTime = 0
    private var angryTime = 0
    private var surpriseTime = 0
    private var fearTime = 0
    private var disgustTime = 0
    private var contemptTime = 0
    private var timerPoseID: Int = 0
    
    private var timer: Timer?
    private var ms = 0
    
    init() {
        imageList.append("Door")
        imageList.append("Energy")
        imageList.append("Kyongi")
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
    
    func measureTime (facePoseID: Int){
        if(self.timer != nil){
            switch timerPoseID {
            case 0:
                timer?.invalidate()
                neutralTime += ms
            case 1:
                timer?.invalidate()
                happyTime += ms
            case 2:
                timer?.invalidate()
                sadTime += ms
            case 3:
                timer?.invalidate()
                angryTime += ms
            case 4:
                timer?.invalidate()
                surpriseTime += ms
            case 5:
                timer?.invalidate()
                fearTime += ms
            case 6:
                timer?.invalidate()
                disgustTime += ms
            case 7:
                timer?.invalidate()
                contemptTime += ms
            default:
                print("timerPoseID out of bounds")
            }
            timerPoseID = facePoseID
            self.ms = 0
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }else{
            self.ms = 0
            timerPoseID = facePoseID
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    
    public func calcUserFeedbackFromMimic() ->Int {
        
        let negativeTime = sadTime + angryTime + fearTime + disgustTime + contemptTime
        let neutralTime = surpriseTime
        let positiveTime = happyTime
        if(positiveTime > 0 || negativeTime > 0 || neutralTime > 0){
            var emotionMap = [String : Int]()
            emotionMap["positive"] = positiveTime
            emotionMap["negative"] = negativeTime
            emotionMap["neutral"] = neutralTime
            let longest = emotionMap.max{a, b in a.value < b.value}
            var reaction = longest?.key
            switch reaction {
            case "positive":
                return 1
            case "negative":
                return -1
            case "neutral":
                return 0
            default:
                return 0
            }
        }else{
            return 0
        }
    }
    
    func resetTimers(){
        
        neutralTime = 0
        happyTime = 0
        sadTime = 0
        angryTime = 0
        surpriseTime = 0
        fearTime = 0
        disgustTime = 0
        contemptTime = 0
        
    }
    
    /**
     Calls next image and saves emotion that was recognized and neutral emotion as user reaction
     */
    func nextButtonClick(feedBack: Int){
        measuredReactions.append(feedBack)
        //correctReaction.append(correct)
        resetTimers()
        
    }
    
    /**
     Calls next image and saves emotion that was recognized and neutral emotion as user reaction
     */
    func positiveUserReaction(){
        
        measuredReactions.append(calcUserFeedbackFromMimic())
        userReactions.append(1)
        resetTimers()
    }
    
    /**
     Calls next image and saves emotion that was recognized and neutral emotion as user reaction
     */
    func negativeUserReaction(){
        
        measuredReactions.append(calcUserFeedbackFromMimic())
        userReactions.append(-1)
        resetTimers()
    }
    
    func getCurrentEmotionName() -> String {
        if let index = emotionList.index(where: {$0.id == currentEmotion}){
            return emotionList[index].name
        }
        return "unknown"
    }
    
    @objc func update(){
        self.ms += 1
    }
    
    func gotUserCorrectionRight(){
        correctReaction.append(true)
    }
    
    func gotUserReactionWrong(){
        correctReaction.append(false)
    }
}
