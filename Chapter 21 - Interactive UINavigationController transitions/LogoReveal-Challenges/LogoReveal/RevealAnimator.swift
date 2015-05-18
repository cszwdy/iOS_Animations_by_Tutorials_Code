//
//  RevealAnimator.swift
//  LogoReveal
//
//  Created by Marin Todorov on 1/15/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

  let animationDuration = 2.0
  var operation: UINavigationControllerOperation = .Push

  weak var storedContext: UIViewControllerContextTransitioning?
  
  var interactive = false
  
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
      
      let fadeIn = CABasicAnimation(keyPath: "opacity")
      fadeIn.fromValue = 0.0
      fadeIn.toValue = 1.0
      fadeIn.duration = animationDuration
      toVC.view.layer.addAnimation(fadeIn, forKey: nil)
    } else {
      
      let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
      let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
      
      transitionContext.containerView().insertSubview(toView, belowSubview: fromView)
      
      UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseIn, animations: {
        fromView.transform = CGAffineTransformMakeScale(0.01, 0.01)
        }, completion: {_ in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      })
      
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
 
  func handlePan(recognizer: UIPanGestureRecognizer) {

    let translation = recognizer.translationInView(recognizer.view!.superview!)
    var progress: CGFloat = abs(translation.x / 200.0)
    progress = min(max(progress, 0.01), 0.99)

    switch recognizer.state {
    case .Changed:
      updateInteractiveTransition(progress)

    case .Cancelled, .Ended:

      if operation == .Push {
        
        let transitionLayer = storedContext!.containerView().layer
        transitionLayer.beginTime = CACurrentMediaTime()
        if progress < 0.5 {
          completionSpeed = -1.0
          cancelInteractiveTransition()
        } else {
          completionSpeed = 1.0
          finishInteractiveTransition()
        }
      } else {
        
        if progress < 0.5 {
          cancelInteractiveTransition()
        } else {
          finishInteractiveTransition()
        }
      }
      
      interactive = false
    default:
      break
    }

  }

}
