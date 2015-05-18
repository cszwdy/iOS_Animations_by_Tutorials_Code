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
  
  override func viewDidLoad() {
    super.viewDidLoad()

    ball.addObserver(self, forKeyPath: "alpha", options: .New, context: nil)
    
    //setup ball interaction
    ball.userInteractionEnabled = true
    ball.addGestureRecognizer(
      UIPanGestureRecognizer(target: self, action: Selector("didPan:"))
    )
    
    resetBall()
    
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    ball.alpha = 0.0
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    fadeInView(ball)
  }
  
  func didPan(pan: UIPanGestureRecognizer) {
    println("Panning...")
    
  }
  
  func resetBall() {
    //set ball at random position on the field
    let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    ball.center = CGPoint(x: randomX * view.frame.size.width, y: view.frame.size.height * 0.7)
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

}

