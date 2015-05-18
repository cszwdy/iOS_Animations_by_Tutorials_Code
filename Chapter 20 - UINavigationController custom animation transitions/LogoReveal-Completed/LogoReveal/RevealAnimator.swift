//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Marin Todorov on 1/15/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning {

  let animationDuration = 2.0
  var operation: UINavigationControllerOperation = .Push

  weak var storedContext: UIViewControllerContextTransitioning?
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return animationDuration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    storedContext = transitionContext
    
    if operation == .Push {
      
      let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
      let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
      
      transitionContext.containerView().addSubview(toVC.view)

      let animation = CABasicAnimation(keyPath: "transform")
      
      animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
      animation.toValue = NSValue(CATransform3D:
        CATransform3DConcat(
          CATransform3DMakeTranslation(0.0, -10.0, 0.0),
          CATransform3DMakeScale(150.0, 150.0, 1.0)
        )
      )

      animation.duration = animationDuration
      animation.delegate = self
      animation.fillMode = kCAFillModeForwards
      animation.removedOnCompletion = false
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

      toVC.maskLayer.addAnimation(animation, forKey: nil)
      fromVC.logo.addAnimation(animation, forKey: nil)
    }
  }

  override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
      
      if let context = storedContext {
        context.completeTransition(!context.transitionWasCancelled())
        
        //reset logo
        let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
        fromVC.logo.removeAllAnimations()
      }
      
      storedContext = nil
  }
  
}
