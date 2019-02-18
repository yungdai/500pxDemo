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
    
    var photosDetailsManager: PhotoDetailsManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        photosDetailsManager = PhotoDetailsManager(showcaseContainer: showcaseContainer)
        resetAnimations()
    }
    
    var effectsCompletionValue: CGFloat = 0
    
    // MARK: Animation Methods
    
    /// Used to handle the resetting of the views and animations
    private func resetAnimations() {

        blurView.effect = nil
        view.sendSubviewToBack(blurView)
        
        // if the animators are active we'll rewind the animations
        
        guard let blurAnimator = blurAnimator else { return }
        guard let cornerAnimator = cornerAnimator else { return }

        blurAnimator.finishAnimation(at: .start)
        cornerAnimator.finishAnimation(at: .start)
    }
    
    // reverse the blur and reset the animation
    private func reverseBlurToClear() {
        
        if blurAnimator != nil {
            animateBlurFor(fraction: 0) {
                self.resetAnimations()
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
    }

    private func animateBlur() {

        // Bring the blurView to the front first
        view.bringSubviewToFront(blurView)
        
        // animate the blur
        blurAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
            
            self.blurView.effect = UIBlurEffect.init(style: .light)
        })
        
        // animate the corners
        cornerAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
            
            self.showcaseContainer.layer.cornerRadius = 40
        })
        
        blurAnimator.pausesOnCompletion = true
        cornerAnimator.pausesOnCompletion = true
    }
    
    func showPhotoDetailsVC(photo: Photo) {

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
                photosDetailsManager?.setPhotoDetailsVC(photoDetailsVC: photoDetailsVC)
            }
        }
    }
}
