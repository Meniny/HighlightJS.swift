//
//  Delegate.swift
//  Bookify
//
//  Created by Meniny on 2017-05-17.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import Foundation

/// Highlighting Delegate
@objc public protocol HighlightJSDelegate {
    /**
     If this method returns *false*, the highlighting process will be skipped for this range.
     
     - parameter range: NSRange
     
     - returns: Bool
     */
    @objc optional func shouldHighlight(_ range: NSRange) -> Bool
    
    /**
     Called after a range of the string was highlighted, if there was an error **success** will be *false*.
     
     - parameter range:   NSRange
     - parameter success: Bool
     */
    @objc optional func didHighlight(_ range: NSRange, success: Bool)
}
