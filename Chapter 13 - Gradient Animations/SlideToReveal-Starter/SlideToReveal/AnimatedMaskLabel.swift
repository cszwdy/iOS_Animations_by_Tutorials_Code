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
    
    return gradientLayer
    }()
  
  @IBInspectable var text: String! {
    didSet {
      setNeedsDisplay()
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
    
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    
  }
  
}