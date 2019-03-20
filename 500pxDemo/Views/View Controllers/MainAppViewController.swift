//
//  MainAppViewController.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-14.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

typealias Handler = () -> Void

final class MainAppViewController: UIViewController {
    
    // MARK: Properties
    private var showcaseNavVC: UINavigationController?
    private var blurAnimator: UIViewPropertyAnimator!
    private var cornerAnimator: UIViewPropertyAnimator!
    
    let showcaseVC = "showcaseVCSegue"
    let showPhotoDetailsVC = "showPhotoDetailsVCSegue"
    
    @IBOutlet var showcaseContainer: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    let photosDetailsManager = PhotoDetailsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosDetailsManager.setShowCaseContainer(view: showcaseContainer)
        photosDetailsManager.setMainAppVC(mainAppVC: self)
        self.view.sendSubviewToBack(blurView)
        animateBlur()
        resetAnimations()
    }
    
    var effectsCompletionValue: CGFloat = 0
    
    // MARK: Animation Methods
    
    /// Used to handle the resetting of the views and animations
    private func resetAnimations() {
        
        blurView.effect = nil
        
        // if the animators are active we'll rewind the animations
        
        guard let blurAnimator = blurAnimator else { return }
        guard let cornerAnimator = cornerAnimator else { return }
        
        
        blurAnimator.stopAnimation(true)
        cornerAnimator.stopAnimation(true)
        
        UIView.animate(withDuration: 0.75) {
            self.showcaseContainer.layer.transform = CATransform3DIdentity
        }
        
    }
    
    // reverse the blur and reset the animation
    func reverseBlurToClear() {
        
        if blurAnimator != nil {
            
            UIView.animate(withDuration: 0.75) {
                
                
                self.animateBlurFor(fraction: 0) {
                    
                    
                    
                    self.resetAnimations()
                }
            }

        }
    }
    
    private func blurMainAppContainer() {
        
        if blurAnimator == nil {
            animateBlur()
        }
        
        animateBlurFor(fraction: 1, completion: nil)
    }
    
    private func animateBlurFor(fraction: CGFloat, completion: Handler?) {
        
        guard let blurAnimator = blurAnimator else { return }
        guard let cornerAnimator = cornerAnimator else { return }
        
        // We only want a 10% full blur
        blurAnimator.fractionComplete = fraction * 0.1
        
        // the corner should be animated as such
        cornerAnimator.fractionComplete = fraction
        
        effectsCompletionValue = cornerAnimator.fractionComplete
        
        if let completion = completion {
            completion()
        }
    }
    
    func animateBlur() {
 
        
        if blurAnimator == nil {
            // animate the blur
            blurAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
                
                self.blurView.effect = UIBlurEffect.init(style: .prominent)
            })
            
            // animate the corners
            cornerAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
                
                self.showcaseContainer.layer.cornerRadius = 40  
            })
        }
       
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            let scale = CATransform3DMakeScale(0.85, 0.85, 0.85)
            let translation = CATransform3DMakeTranslation(0, -30, -30)
            self.showcaseContainer.layer.transform = CATransform3DConcat(scale, translation)
        }, completion: nil)

        self.animateBlurFor(fraction: 0.5, completion: nil)

    
    }
    
    func showPhotoDetailsVC(with photo: Photo) {
        
        // need to activate the way it shrinks the container contents
        performSegue(withIdentifier: showPhotoDetailsVC, sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // init the showcaseNavVC Container
        if segue.identifier == showcaseVC {
            
            if let showcaseNavVC = segue.destination as? UINavigationController {
                self.showcaseNavVC = showcaseNavVC
            }

        }
        
        if segue.identifier == showPhotoDetailsVC {
            
            if let photoDetailsVC = segue.destination as? PhotoDetailsViewController {
                photosDetailsManager.setPhotoDetailsVC(photoDetailsVC: photoDetailsVC)
            }
        }
    }
}
