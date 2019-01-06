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

class ScaleTransitioningDelegate: NSObject {
    
    //MARK:- Animation properties
    let animationDuration = 0.5
}

extension ScaleTransitioningDelegate : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
    }
    
    
}
