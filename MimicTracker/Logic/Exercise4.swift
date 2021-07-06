//
//  Test3.swift
//  MimicTracker
//
//  Created by Marcel Knupfer on 30.05.21.
//

import Foundation

class Exercise4 {

    var imageList: Array<String> = [String]()
    var measuredReactions: Array<Int> = [Int]()
    var correctReaction: Array<Bool> = [Bool]()
    var currentEmotion = 0
    
    init() {
        imageList.append("inhalt1")
        imageList.append("inhalt3")
        imageList.append("inhalt5")
        imageList.append("inhalt7")
        imageList.append("inhalt9")
        imageList.append("inhalt11")
        imageList.append("inhalt13")
        imageList.append("inhalt15")
        imageList.append("inhalt17")
        imageList.append("inhalt2")
        imageList.append("inhalt4")
        imageList.append("inhalt6")
        imageList.append("inhalt8")
        imageList.append("inhalt10")
        imageList.append("inhalt12")
        imageList.append("inhalt14")
        imageList.append("inhalt16")
        imageList.append("inhalt18")
        imageList.append("inhalt20")
        imageList.append("inhalt22")
        imageList.append("inhalt24")
        imageList.append("inhalt26")
        imageList.append("inhalt28")
        imageList.append("inhalt30")
        imageList.append("inhalt31")
        imageList.append("inhalt19")
        imageList.append("inhalt21")
        imageList.append("inhalt23")
        imageList.append("inhalt25")
        imageList.append("inhalt27")
        imageList.append("inhalt29")
    }
    
    func measureReaction (facePoseID: Int)->Int{
        switch facePoseID {
        case 1:
            return 1
        case 3:
            return -1
        default:
            return 0
        }
    }
    
    
    /**
     Calls next image and saves emotion that was recognized and neutral emotion as user reaction
     */
    func positiveUserReaction(){
        measuredReactions.append(1)
        //userReactions.append(1)
    }
    
    /**
     Calls next image and saves emotion that was recognized and neutral emotion as user reaction
     */
    func negativeUserReaction(){
        measuredReactions.append(-1)
        //userReactions.append(-1)
    }
    
    /**
     Saves a correctly measured user reaction
     */
    func gotUserCorrectionRight(){
        correctReaction.append(true)
    }
    
    /**
     Saves a wrong measured user reaction
     */
    func gotUserReactionWrong(){
        correctReaction.append(false)
    }
}
