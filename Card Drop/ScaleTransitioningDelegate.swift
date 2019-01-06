//
//  ScaleTransitioningDelegate.swift
//  Card Drop
//
//  Created by Charles Martin Reed on 1/5/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

/*how our custom transition animation breaks down
 Container View to provide the context for our custom code -> backgroundVC.view and foregroundVC.view to coordinate sizes, positions, etc. held within Container View <- imageView presented by the Container View at the end of the animation
 */

import UIKit

//our overiew and image selection controllers will adopt this protocol to get the imageView
protocol Scaling {
    func scaling(transition: ScaleTransitioningDelegate) -> UIImageView?
}

enum TransitionState {
    case begin
    case end
}

class ScaleTransitioningDelegate: NSObject {
    
    //MARK:- Animation properties
    let animationDuration = 0.5
}

//MARK:- UIViewControllerAnimatedTransitioning delegate methods
extension ScaleTransitioningDelegate : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //grab the container view
        let containerView = transitionContext.containerView
        
        //grabe overview VC and image selection view controllers
        guard let backgroundVC = transitionContext.viewController(forKey: .from) else { return }
        guard let foregroundVC = transitionContext.viewController(forKey: .to) else { return }
        
        //this works because anything that adopts the Scaling protocol must utilize this function, which in turn optionally returns an imageView. We'll use that image at the start and end of animation.
        guard let backgroundImageView = (backgroundVC as? Scaling)?.scaling(transition: self) else { return }
        guard let foregroundImageView = (backgroundVC as? Scaling)?.scaling(transition: self) else { return }
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        imageViewSnapshot.contentMode = .scaleAspectFill
        imageViewSnapshot.layer.masksToBounds = true
        
        //at the outset of the animation, we'll need to hide both of these
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foregroundBGColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        
        //populating our containerView, from bottom to top
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapshot)
        
    }
    
    
}
