//
//  CardModel.swift
//  AnimalMatching
//
//  Created by Arjun Dureja on 2019-12-25.
//  Copyright © 2019 Arjun Dureja. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards(_ size:Int) -> [Card] {
        
        var cards = [Card]()
        var nums = [Int]()
        var randNum = 0
        
        // Generate x number of card pairs randomly
        while nums.count < size {
            repeat {
                randNum = Int.random(in: 1...50)
            } while(nums.contains(randNum))
            
            nums.append(randNum)
            print("Random number: \(randNum)")
            
            let cardOne = Card()
            cardOne.imageName = "card\(randNum)"
            
            cards.append(cardOne)
            
            let cardTwo = Card()
            cardTwo.imageName = "card\(randNum)"
            
            cards.append(cardTwo)
        }
        
        cards = shuffle(c: cards)
        
        print("Number of cards: \(cards.count)")
        return cards
    }
    
    // Method to shuffle the cards when game starts or when user presses shuffle button
    func shuffle(c: [Card]) -> [Card] {
        // Shuffle cards using Knuth shuffle algorithm
        var cards = c

        for i in 0...cards.count-1 {
            cards.swapAt(i, Int(arc4random_uniform(UInt32(i+1))))
        }
        return cards
    }
    
}
