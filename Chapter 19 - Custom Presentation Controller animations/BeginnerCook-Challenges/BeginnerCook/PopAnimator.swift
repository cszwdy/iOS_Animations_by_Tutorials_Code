//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Marin Todorov on 1/15/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration    = 1.0
  var presenting  = true
  var originFrame = CGRect.zeroRect

  var dismissCompletion: (()->())?
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return duration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView()
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
    
    let herbView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
    
    let initialFrame = presenting ? originFrame : herbView.frame
    let finalFrame = presenting ? herbView.frame : originFrame
    
    let xScaleFactor = presenting ?
      initialFrame.width / finalFrame.width :
      finalFrame.width / initialFrame.width
    
    let yScaleFactor = presenting ?
      initialFrame.height / finalFrame.height :
      finalFrame.height / initialFrame.height
    
    let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
    
    if presenting {
      herbView.transform = scaleTransform
      herbView.center = CGPoint(
        x: CGRectGetMidX(initialFrame),
        y: CGRectGetMidY(initialFrame))
      herbView.clipsToBounds = true
    }

    containerView.addSubview(toView)
    containerView.bringSubviewToFront(herbView)
    
    let herbController = transitionContext.viewControllerForKey(
      presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey
      ) as! HerbDetailsViewController
    
    if presenting {
      herbController.containerView.alpha = 0.0
    }
    
    UIView.animateWithDuration(duration, delay:0.0,
      usingSpringWithDamping: 0.4,
      initialSpringVelocity: 0.0,
      options: nil,
      animations: {
        
        herbView.transform = self.presenting ? CGAffineTransformIdentity : scaleTransform
        herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
        herbController.containerView.alpha = self.presenting ? 1.0 : 0.0
        
      }, completion:{_ in
        
        if !self.presenting {
          self.dismissCompletion?()
        }
        transitionContext.completeTransition(true)
    })
   
    let round = CABasicAnimation(keyPath: "cornerRadius")
    round.fromValue = !presenting ? 0.0 : 20.0/xScaleFactor
    round.toValue = presenting ? 0.0 : 20.0/xScaleFactor
    round.duration = duration / 2
    herbView.layer.addAnimation(round, forKey: nil)
    herbView.layer.cornerRadius = presenting ? 0.0 : 20.0/xScaleFactor
  }
  
}
