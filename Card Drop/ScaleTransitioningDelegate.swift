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
        
        let transitionStateA = TransitionState.begin
        let transitionStateB = TransitionState.end
        
        prepareViews(for: transitionStateA, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        
        //make sure the proper autolayout occurs
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            //this will embiggen our imageViewSnapshot
            self.prepareViews(for: transitionStateB, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        }) { (_) in
            //clean up work after the animation is completed
            backgroundVC.view.transform = .identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            
            foregroundVC.view.backgroundColor = foregroundBGColor
            
            //tell the system our transition is complete - if the transition wasn't cancelled by the user or system, it was completed, hence the bang operator.
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func prepareViews(for state: TransitionState, containerView: UIView, backgroundVC: UIViewController, backgroundImageView: UIImageView, foregroundImageView: UIImageView, snapshotImageView: UIImageView) {
        
        //adjusting the animatable properties of our views
        switch state {
        case .begin:
            backgroundVC.view.transform = .identity
            backgroundVC.view.alpha = 1
            
            //position in relation to the actual superview of oru background image view - convert converts rect from one view to the coordinate system of another. and we want our image to begin with the same frame size as one of our cards
            snapshotImageView.frame = containerView.convert(backgroundImageView.frame, from: backgroundImageView.superview)
        case .end:
            backgroundVC.view.alpha = 0
            //snapshot should cover whole screen OR shrunk to size of collection view cell
            snapshotImageView.frame = containerView.convert(foregroundImageView.frame, from: foregroundImageView.superview)
        }
    }
    
    
}

extension ScaleTransitioningDelegate : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //operation is push (forward) or pop (go back to the previous) between VCs
        
        if fromVC is Scaling && toVC is Scaling {
            //if both conform to scaling, we can perform our transition. Return self.
            return self
        } else {
            return nil
        }
    }
    
}
