//
//  AnimalMatchingTests.swift
//  AnimalMatchingTests
//
//  Created by Arjun Dureja on 2020-01-12.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import XCTest

@testable import AnimalMatching

class AnimalMatchingTests: XCTestCase {
    var viewController: ViewController!
    
    // Viewcontroller setup
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ViewController = storyboard.instantiateViewController(withIdentifier: "game") as! ViewController
        viewController = vc
        _ = viewController.view // To call viewDidLoad
    }
    
    // Test the number of cards generated at the start of the game
    func testNumCards() {
        XCTAssertEqual(20, viewController.cardArray.count)
    }
    
    // Test if card is flipped when card cell is selected
    func testFlipCard() {
        let indexPath = IndexPath(row: 0, section: 0)

        viewController.cardCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
        viewController.collectionView(viewController.cardCollectionView, didSelectItemAt: indexPath)

        XCTAssertTrue(viewController.cardArray[indexPath.row].isFlipped)
    }
    
    // Test if card is matched
    func testCardMatch() {
        let firstIndex = IndexPath(row: 0, section: 0)
        let card = viewController.cardArray
        
        viewController.cardCollectionView.selectItem(at: firstIndex, animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
        viewController.collectionView(viewController.cardCollectionView, didSelectItemAt: firstIndex)
        
                
        for i in 1..<viewController.cardArray.count {
            if card[i].isFlipped == false && card[i].imageName == viewController.cardArray[firstIndex.row].imageName {
                viewController.cardCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
                viewController.collectionView(viewController.cardCollectionView, didSelectItemAt: IndexPath(row: i, section: 0))
            }
        }

        XCTAssertTrue(card[firstIndex.row].isMatched)
    }
    // Test if the shuffle method works
    func testCardShuffle() {
        let indexPath = IndexPath(row: 0, section: 0)
        let imgName = viewController.cardArray[indexPath.row].imageName
        
        viewController.cardArray.shuffle()
        XCTAssertNotEqual(imgName, viewController.cardArray[indexPath.row].imageName)
    }
    

}
