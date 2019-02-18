//
//  PhotoDetailManager.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-16.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

final class PhotoDetailsManager: NSObject {
    
    private var touchYPosition: CGFloat = 0
    private var photoDetailsHeight: CGFloat?
    
    private weak var photoDetailsVC: UIViewController?
    private weak var showcaseContainer: UIView?
    
    init(showcaseContainer: UIView?) {
        self.showcaseContainer = showcaseContainer
    }
    
    func setPhotoDetailsVC(photoDetailsVC: PhotoDetailsViewController) {
        self.photoDetailsVC = photoDetailsVC
    }
    
    private func getFractionForPosition(position: CGFloat, forHeight height: CGFloat) -> CGFloat {
        return (1.0 / height) * position
    }
    
    /// Use to interactivly transform the managing VC when the photo details appears
    private func transformShowcaseContainer(byFraction fraction: CGFloat) {
        
        guard let showcaseContainer = showcaseContainer else { return }
        
        let scaleFraction = (1 - (fraction * 0.15))
        let translationFraction = -(fraction * 30)
        
        let scale = CATransform3DMakeScale(scaleFraction, scaleFraction, scaleFraction)
        let translation = CATransform3DMakeTranslation(0, translationFraction, translationFraction)
        
        showcaseContainer.layer.transform = CATransform3DConcat(scale, translation)
    }
    
    
    /// Use this to translate the PanGesture for the PhotoDetails
    func translatePhotoDetailsWithPanGesture(sender: UIPanGestureRecognizer) {
        
        // find out how much the panGesture is translationg from it's starting point
        
        let translation = sender.translation(in: photoDetailsVC?.view)
        
        var position = touchYPosition + translation.y
        
        if touchYPosition + translation.y < 0 {
            touchYPosition = 0
            position = 0
        }
        
        switch sender.state {
            
        case .changed:
            
            guard let photoDetailsVC = photoDetailsVC,
            let photoDetailsHeight = photoDetailsHeight else { return }

            
            // need to guarentee touchYPosition is < 0
            
            if touchYPosition + translation.y < 0 {
                touchYPosition = 0
                position = 0
            }
            
            // calculate how much further back the menu can go
            let origin = max(0, min(photoDetailsHeight, position))
            let fraction = 1 - (position / photoDetailsHeight)
            
            transformShowcaseContainer(byFraction: fraction)
            photoDetailsVC.view.frame.origin.y = origin
            
        case .ended:
            
            guard let photoDetailsVC = photoDetailsVC,
            let photoDetailsHeight = photoDetailsHeight else { return }
            
            // always keep track of the touchYPosition
            touchYPosition = photoDetailsVC.view.frame.origin.y
            
            // if we're passed 25% of the width of the menu from the top then we close it
            (touchYPosition > (photoDetailsHeight * 0.25)) ? dismissPhotoDetailsVC() : resetPhotoDetailsVC()

        default:
            break
        }
        
    }
    
    private func dismissPhotoDetailsVC() {
        guard let photoDetailsVC = photoDetailsVC else { return }
        photoDetailsVC.dismiss(animated: true)
    }
    
    private func resetPhotoDetailsVC() {
        
        UIView.animate(withDuration: 0.3) {
            
            guard let photoDetailsVC = self.photoDetailsVC else { return }
            photoDetailsVC.view.frame.origin.y = 0
        }
    }
}
