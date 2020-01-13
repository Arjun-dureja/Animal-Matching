//
//  ViewController.swift
//  AnimalMatching
//
//  Created by Arjun Dureja on 2019-12-25.
//  Copyright © 2019 Arjun Dureja. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var matchedLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var shuffleBtn: UIButton!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstCardIndex:IndexPath?
    var firstCard:Card?
    
    var matched = 0
    var score = 0
    var gridSize = 10
    
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Set the gridsize of the cards depending on user input
        switch gridSize {
        case 15:
            layout.itemSize = CGSize(width: 55, height: 95)
        case 20:
            layout.itemSize = CGSize(width: 55, height: 70)
        default:
            layout.itemSize = CGSize(width: 75, height: 112.5)
        }
        cardArray = model.getCards(gridSize)
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        
        // Set collection view background color to clear
        self.cardCollectionView?.backgroundColor = UIColor.clear
        self.cardCollectionView?.backgroundView = UIView(frame: CGRect.zero)
        
        // Make all buttons rounded
        homeBtn.layer.cornerRadius = 10;
        homeBtn.clipsToBounds = true;
        shuffleBtn.layer.cornerRadius = 17;
        shuffleBtn.clipsToBounds = true;
        restartBtn.layer.cornerRadius = 15;
        restartBtn.clipsToBounds = true;
    }
    
    // Collection view protocol methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        let card = cardArray[indexPath.row]
        
        // Flip card if it isn't already flipped
        if card.isFlipped == false {
            soundManager.playSound(.flip)
            cell?.flip()
            card.isFlipped = true
            
            //Determine if the first or second card is selected
            if firstCardIndex == nil {
                firstCardIndex = indexPath
                firstCard = cardArray[firstCardIndex!.row]
            }
            else {
                checkMatch(indexPath)
            }
        }
    }
    
    // Check if both selected cards match
    func checkMatch(_ secondCardIndex:IndexPath) {
        let cardOneCell = cardCollectionView.cellForItem(at: firstCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = cardCollectionView.cellForItem(at: secondCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstCardIndex!.row]
        let cardTwo = cardArray[secondCardIndex.row]
        
        // Compare card images
        if cardOne.imageName == cardTwo.imageName {
            cardOne.isMatched = true
            cardTwo.isMatched = true
            soundManager.playSound(.matched)
            
            // Update score and matched counter
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.matched += 1
                self.matchedLabel.text = "Matched: \(self.matched)"
                
                self.score -= 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
            
            // Check if all cards are matched
            if(checkWin()) {
                // Win alert
                let alert = UIAlertController(title: "You Win!", message: "Score: \(score-1)", preferredStyle: .alert)
                
                let alertAction = UIAlertAction(title: "Home", style: .default, handler: {
                        (UIAlertAction) in
                        let vc = storyBoard.instantiateViewController(identifier: "home") as! HomeViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                })
                
                alert.addAction(alertAction)
            
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.present(alert, animated: true, completion: nil)
                    self.soundManager.playSound(.win)
                }

            }
            
        }
            
        // If cards do not match
        else {
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipBack(0.5)
            cardTwoCell?.flipBack(0.5)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.score += 1
                self.scoreLabel.text = "Score: \(self.score)"
            }
        }
        
        firstCardIndex = nil
        firstCard = nil
    }
    
    func checkWin() -> Bool {
        // Iterate through all cards to check if they are matched
        for card in cardArray {
            if card.isMatched == false{
                return false
            }
        }
        return true
    }

    // Method called when shuffle button is pressed
    @IBAction func shuffleButton(_ sender: UIButton) {
        soundManager.playSound(.shuffle)
        cardArray = model.shuffle(c: cardArray)
        
        // Update index of first card if it is selected before pressing the shuffle button
        if firstCard != nil {
            for index in cardCollectionView.indexPathsForVisibleItems {
                if cardArray[index.row] === firstCard {
                    firstCardIndex = index
                }
            }
        }
        cardCollectionView.reloadData()
    }
    
    // Method that restarts the game when button is pressed or user wins
    func restartGame() {
        matched = 0
        score = 0
        firstCard = nil
        firstCardIndex = nil
        self.scoreLabel.text = "Score: \(self.score)"
        self.matchedLabel.text = "Matched: \(self.score)"
        for cell in cardCollectionView.visibleCells {
            let cardCell = cell as? CardCollectionViewCell
            cardCell?.flipBack(0.001)
        }
        for card in cardArray {
            card.isFlipped = false
            card.isMatched = false
        }
    }

    @IBAction func restartButton(_ sender: UIButton) {
        restartGame()
    }
    
    // Method called when home button is pressed
    @IBAction func homeButton(_ sender: UIButton) {
        let vc = storyBoard.instantiateViewController(identifier: "home") as! HomeViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
}


