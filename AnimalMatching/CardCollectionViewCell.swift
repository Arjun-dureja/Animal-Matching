//
//  CardCollectionViewCell.swift
//  AnimalMatching
//
//  Created by Arjun Dureja on 2019-12-26.
//  Copyright © 2019 Arjun Dureja. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
        frontImageView.frame.size.height = 500

        if card.isFlipped == true {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromRight], completion: nil)
        }

    }
    
    // Method to flip card from back to front
    func flip() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    
    }
    
    // Method to flip card from front to back
    func flipBack(_ s:Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + s) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
}
