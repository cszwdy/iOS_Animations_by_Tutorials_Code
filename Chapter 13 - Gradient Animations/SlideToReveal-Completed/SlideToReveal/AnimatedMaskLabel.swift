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
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {
  
  let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    
    // Configure the gradient here
    
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

    let colors = [
      UIColor.blackColor().CGColor,
      UIColor.whiteColor().CGColor,
      UIColor.blackColor().CGColor
    ]
    gradientLayer.colors = colors

    let locations = [
      0.25,
      0.5,
      0.75
    ]
    gradientLayer.locations = locations
    
    return gradientLayer
    }()
  
  let textAttributes : [NSObject: AnyObject] = {
    let style = NSMutableParagraphStyle()
    style.alignment = .Center
    
    return [
      NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: 28.0)!,
      NSParagraphStyleAttributeName:style
    ]
    }()

  @IBInspectable var text: String! {
    didSet {
      setNeedsDisplay()

      UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
      let context = UIGraphicsGetCurrentContext()
      text.drawInRect(bounds, withAttributes: textAttributes)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      let maskLayer = CALayer()
      maskLayer.backgroundColor = UIColor.clearColor().CGColor
      maskLayer.frame = CGRectOffset(bounds, bounds.size.width, 0)
      maskLayer.contents = image.CGImage
      
      gradientLayer.mask = maskLayer
    }
  }
  
  #if TARGET_INTERFACE_BUILDER
  override func drawRect(rect: CGRect) {
  layer.borderColor = UIColor.whiteColor().CGColor
  layer.borderWidth = 1.0
  layer.backgroundColor = UIColor(white: 1.0, alpha: 0.1).CGColor
  
  let style = NSMutableParagraphStyle()
  style.alignment = .Center
  
  let font = UIFont(name: "HelveticaNeue-Thin", size: bounds.size.height/2)
  
  let attrs = NSMutableDictionary()
  attrs[NSFontAttributeName] = font
  attrs[NSParagraphStyleAttributeName] = style
  attrs[NSForegroundColorAttributeName] = UIColor.whiteColor()
  
  NSString(string: text).drawInRect(bounds, withAttributes: attrs)
  }
  #endif
  
  override func layoutSubviews() {
    gradientLayer.frame = CGRect(
      x: -bounds.size.width,
      y: bounds.origin.y,
      width: 3 * bounds.size.width,
      height: bounds.size.height)
    
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    
    layer.addSublayer(gradientLayer)
    
    let gradientAnimation = CABasicAnimation(keyPath: "locations")
    gradientAnimation.fromValue = [0.0, 0.0, 0.25]
    gradientAnimation.toValue = [0.75, 1.0, 1.0]
    gradientAnimation.duration = 3.0
    gradientAnimation.repeatCount = Float.infinity

    gradientLayer.addAnimation(gradientAnimation, forKey: nil)
  }
  
}