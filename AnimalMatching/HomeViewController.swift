//
//  HomeViewController.swift
//  AnimalMatching
//
//  Created by Arjun Dureja on 2020-01-01.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit

let storyBoard = UIStoryboard(name: "Main", bundle: nil)
class HomeViewController: UIViewController {

    let vc = storyBoard.instantiateViewController(identifier: "game") as! ViewController
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var difficulty: UISegmentedControl!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bearImage: UIImageView!
    
    var soundManager = SoundManager()
    
    var tempVal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 92/255, green: 200/255, blue: 247/255, alpha: 1)
        
        // Style play button
        play.layer.cornerRadius = 17
        play.clipsToBounds = true
        
        // Style difficulty segmented control
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)]
        difficulty.setTitleTextAttributes(titleTextAttributes, for: .normal)
        
        // Animate title label in
        titleLabel.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        UIView.animate(withDuration: 1) {
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        // Animate bear
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animateBear), userInfo: nil, repeats: true)
    }
    
    @objc func animateBear() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bearImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.bearImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        })
    }
    
    //Method called when play button is pressed
    @IBAction func playButton(_ sender: UIButton) {
        soundManager.playSound(.shuffle)
        let sliderVal = Int(slider.value)
        
        //Update the grid size using the slider
        switch sliderVal {
        case 2:
            vc.gridSize = 15
        case 3:
            vc.gridSize = 20
        default:
            vc.gridSize = 10
        }
        vc.difficulty = difficulty.selectedSegmentIndex
        
        //Switch to game view controller
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func gridSlider(_ sender: UISlider) {
        slider.value = roundf(slider.value)
        hapticFeedback(slider.value)
    }
    
    func hapticFeedback(_ val: Float) {
        let valInt = Int(val)
        if tempVal != valInt {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
        tempVal = valInt
    }
}
