/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class ViewController: UIViewController {

  @IBOutlet var goal: UIImageView!
  @IBOutlet var ball: UIImageView!
  
  var playingRect: CGRect!
  var observeBounds = true
  
  weak var currentMessage: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    ball.addObserver(self, forKeyPath: "alpha", options: .New, context: nil)
    
    //setup ball interaction
    ball.userInteractionEnabled = true
    ball.addGestureRecognizer(
      UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
    )
    
    resetBall()
    
    let tap = UITapGestureRecognizer(target: self, action: Selector("didTap:"))
    view.addGestureRecognizer(tap)
    
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    ball.alpha = 0.0
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    fadeInView(ball)
    animateMessage("Game on!")
  }
  
  func didPan(pan: UIPanGestureRecognizer) {
    println("Panning...")
    
    switch pan.state {
    case .Began:
      ball.pop_removeAllAnimations()

    case .Changed:
      ball.center = pan.locationInView(view)

    case .Ended:
      let velocity = pan.velocityInView(view)
      
      let animation = POPDecayAnimation(propertyNamed: kPOPViewCenter)
      animation.fromValue = NSValue(CGPoint: ball.center)
      animation.velocity = NSValue(CGPoint: velocity)
      animation.delegate = self
      ball.pop_addAnimation(animation, forKey: nil)

    default: break
    }

    println(pan.velocityInView(view))
  }
  
  func resetBall() {
    //set ball at random position on the field
    let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    ball.center = CGPoint(x: randomX * view.frame.size.width, y: view.frame.size.height * 0.7)
    fadeInView(ball)
  }

  func fadeInView(view: UIView) {
    let fade = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
    fade.fromValue = 0.0
    fade.toValue = 1.0
    fade.duration = 1.0
    view.pop_addAnimation(fade, forKey: nil)
  }

  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
      if object === ball && keyPath == "alpha" {
        println(ball.alpha)
      } else {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
      }
  }

  func animateMessage(text: String) {
    let offScreenFrame = CGRect(x: -view.frame.size.width, y: 200.0, width: view.frame.size.width, height: 50.0)
    let label = UILabel(frame: offScreenFrame)
    
    label.font = UIFont(name: "ArialRoundedMTBold", size: 52.0)
    label.textAlignment = .Center
    label.textColor = UIColor.yellowColor()
    label.text = text
    label.shadowColor = UIColor.darkGrayColor()
    label.shadowOffset = CGSize(width: 2.0, height: 2.0)
    
    currentMessage = label
    view.addSubview(label)
    
    let bounce = POPSpringAnimation(propertyNamed: kPOPViewCenter)
    bounce.fromValue = NSValue(CGPoint: label.center)
    bounce.toValue = NSValue(CGPoint: view.center)

    bounce.springSpeed = 15.0
    bounce.springBounciness = 20.0
    
    bounce.completionBlock = { animation, finished in
      
      let fadeOut = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
      fadeOut.toValue = 0.25
      fadeOut.duration = 0.5
      fadeOut.completionBlock = {_, _ in
        label.removeFromSuperview()
      }
      label.pop_addAnimation(fadeOut, forKey: nil)
    }

    label.pop_addAnimation(bounce, forKey: "bounce")
  }
  
  func didTap(tap: UITapGestureRecognizer) {
    if let label = currentMessage {
      if let bounce = label.pop_animationForKey("bounce") as? POPSpringAnimation {
        bounce.toValue = NSValue(CGPoint: tap.locationInView(view))
      }
    }
  }
  
}

extension ViewController: POPAnimationDelegate {
  
  func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
    println("animation did stop")
    if finished {
      resetBall()
    }
  }
  
  func pop_animationDidApply(anim: POPAnimation!) {
    if goal.frame.contains(ball.center) {
      ball.pop_removeAllAnimations()
      println("GOAL")
      resetBall()
      return
    }
  }

}
