//
//  Theme.swift
//  Pods
//
//  Created by Meniny on 4/24/16.
//
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    /// Typealias for UIColor
    public typealias HJSColor = UIColor
    /// Typealias for UIFont
    public typealias HJSFont = UIFont
#else
    import AppKit
    /// Typealias for NSColor
    public typealias HJSColor = NSColor
    /// Typealias for NSFont
    public typealias HJSFont = NSFont

#endif


public extension HighlightJS {
    
    /// Theme parser, can be used to configure the theme parameters.
    public class Theme {
        fileprivate typealias ThemDictionary = [String: [String: AnyObject]]
        fileprivate typealias ThemeStringDictionary = [String: [String: String]]
        
        internal let theme : String
        internal var lightTheme : String!
        
        /// Regular font to be used by this theme
        public var codeFont : HJSFont!
        /// Bold font to be used by this theme
        public var boldCodeFont : HJSFont!
        /// Italic font to be used by this theme
        public var italicCodeFont : HJSFont!
        
        fileprivate var themeDict : HighlightJS.Theme.ThemDictionary!
        fileprivate var strippedTheme : HighlightJS.Theme.ThemeStringDictionary!
        
        /// Default background color for the current theme.
        public var themeBackgroundColor : HJSColor!
        
        /**
         Initialize the theme with the given theme name.
         
         - parameter themeString: Theme to use.
         */
        init(themeString: String) {
            theme = themeString
            setCodeFont(HJSFont(name: "Courier", size: 14)!)
            strippedTheme = stripTheme(themeString)
            lightTheme = strippedThemeToString(strippedTheme)
            themeDict = strippedThemeToTheme(strippedTheme)
            var bkgColorHex = strippedTheme[".hljs"]?["background"]
            if(bkgColorHex == nil) {
                bkgColorHex = strippedTheme[".hljs"]?["background-color"]
            }
            if let bkgColorHex = bkgColorHex {
                if (bkgColorHex == "white") {
                    themeBackgroundColor = HJSColor(white: 1, alpha: 1)
                } else if(bkgColorHex == "black") {
                    themeBackgroundColor = HJSColor(white: 0, alpha: 1)
                } else {
                    let range = bkgColorHex.range(of: "#")
                    let str = bkgColorHex.substring(from: (range?.lowerBound)!)
                    themeBackgroundColor = colorWithHexString(str)
                }
            } else {
                themeBackgroundColor = HJSColor.white
            }
        }
        
        /**
         Changes the theme font. This will try to automatically populate the codeFont, boldCodeFont and italicCodeFont properties based on the provided font.
         
         - parameter font: UIFont (iOS or tvOS) or NSFont (OSX)
         */
        public func setCodeFont(_ font: HJSFont) {
            codeFont = font
            
            #if os(iOS) || os(tvOS)
                let boldDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute:font.familyName,
                                                                       UIFontDescriptorFaceAttribute:"Bold"])
                let italicDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute:font.familyName,
                                                                         UIFontDescriptorFaceAttribute:"Italic"])
                let obliqueDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute:font.familyName,
                                                                          UIFontDescriptorFaceAttribute:"Oblique"])
            #else
                let boldDescriptor = NSFontDescriptor(fontAttributes: [NSFontFamilyAttribute:font.familyName!,
                                                                       NSFontFaceAttribute:"Bold"])
                let italicDescriptor = NSFontDescriptor(fontAttributes: [NSFontFamilyAttribute:font.familyName!,
                                                                         NSFontFaceAttribute:"Italic"])
                let obliqueDescriptor = NSFontDescriptor(fontAttributes: [NSFontFamilyAttribute:font.familyName!,
                                                                          NSFontFaceAttribute:"Oblique"])
            #endif
            
            boldCodeFont = HJSFont(descriptor: boldDescriptor, size: font.pointSize)
            italicCodeFont = HJSFont(descriptor: italicDescriptor, size: font.pointSize)
            
            if (italicCodeFont == nil || italicCodeFont.familyName != font.familyName) {
                italicCodeFont = HJSFont(descriptor: obliqueDescriptor, size: font.pointSize)
            } else if(italicCodeFont == nil ) {
                italicCodeFont = font
            }
            
            if (boldCodeFont == nil) {
                boldCodeFont = font
            }
            
            if (themeDict != nil) {
                themeDict = strippedThemeToTheme(strippedTheme)
            }
        }
        
        internal func applyStyleToString(_ string: String, styleList: [String]) -> NSAttributedString {
            let returnString : NSAttributedString
            
            if styleList.count > 0 {
                var attrs = [String:AnyObject]()
                attrs[NSFontAttributeName] = codeFont
                for style in styleList {
                    if let themeStyle = themeDict[style] {
                        for (attrName, attrValue) in themeStyle {
                            attrs.updateValue(attrValue, forKey: attrName)
                        }
                    }
                }
                
                returnString = NSAttributedString(string: string, attributes:attrs )
            } else {
                returnString = NSAttributedString(string: string, attributes:[NSFontAttributeName:codeFont] )
            }
            
            return returnString
        }
        
        fileprivate func stripTheme(_ themeString : String) -> [String:[String:String]] {
            let objcString = (themeString as NSString)
            let cssRegex = try! NSRegularExpression(pattern: "(?:(\\.[a-zA-Z0-9\\-_]*(?:[, ]\\.[a-zA-Z0-9\\-_]*)*)\\{([^\\}]*?)\\})", options:[.caseInsensitive])
            
            let results = cssRegex.matches(in: themeString,
                                           options: [.reportCompletion],
                                           range: NSMakeRange(0, objcString.length))
            
            var resultDict = [String:[String:String]]()
            
            for result in results {
                if(result.numberOfRanges == 3)
                {
                    var attributes = [String:String]()
                    let cssPairs = objcString.substring(with: result.rangeAt(2)).components(separatedBy: ";")
                    for pair in cssPairs {
                        let cssPropComp = pair.components(separatedBy: ":")
                        if(cssPropComp.count == 2)
                        {
                            attributes[cssPropComp[0]] = cssPropComp[1]
                        }
                        
                    }
                    if attributes.count > 0
                    {
                        resultDict[objcString.substring(with: result.rangeAt(1))] = attributes
                    }
                    
                }
                
            }
            
            var returnDict = [String:[String:String]]()
            
            for (keys,result) in resultDict {
                let keyArray = keys.replacingOccurrences(of: " ", with: ",").components(separatedBy: ",")
                for key in keyArray {
                    var props : [String:String]?
                    props = returnDict[key]
                    if props == nil {
                        props = [String:String]()
                    }
                    
                    for (pName, pValue) in result {
                        props!.updateValue(pValue, forKey: pName)
                    }
                    returnDict[key] = props!
                }
            }
            
            return returnDict
        }
        
        fileprivate func strippedThemeToString(_ theme: ThemeStringDictionary) -> String {
            var resultString = ""
            for (key, props) in theme {
                resultString += key+"{"
                for (cssProp, val) in props
                {
                    if(key != ".hljs" || (cssProp.lowercased() != "background-color" && cssProp.lowercased() != "background"))
                    {
                        resultString += "\(cssProp):\(val);"
                    }
                }
                resultString+="}"
            }
            return resultString
        }
        
        fileprivate func strippedThemeToTheme(_ theme: ThemeStringDictionary) -> ThemDictionary {
            var returnTheme = ThemDictionary()
            for (className, props) in theme {
                var keyProps = [String:AnyObject]()
                for (key, prop) in props {
                    switch key {
                    case "color":
                        keyProps[attributeForCSSKey(key)] = colorWithHexString(prop)
                        break
                    case "font-style":
                        keyProps[attributeForCSSKey(key)] = fontForCSSStyle(prop)
                        break
                    case "font-weight":
                        keyProps[attributeForCSSKey(key)] = fontForCSSStyle(prop)
                        break
                    case "background-color":
                        keyProps[attributeForCSSKey(key)] = colorWithHexString(prop)
                        break
                    default:
                        break
                    }
                }
                if !keyProps.isEmpty {
                    let key = className.replacingOccurrences(of: ".", with: "")
                    returnTheme[key] = keyProps
                }
            }
            return returnTheme
        }
        
        fileprivate func fontForCSSStyle(_ fontStyle:String) -> HJSFont {
            switch fontStyle {
            case "bold", "bolder", "600", "700", "800", "900":
                return boldCodeFont
            case "italic", "oblique":
                return italicCodeFont
            default:
                return codeFont
            }
        }
        
        fileprivate func attributeForCSSKey(_ key: String) -> String {
            switch key {
            case "color":
                return NSForegroundColorAttributeName
            case "font-weight":
                return NSFontAttributeName
            case "font-style":
                return NSFontAttributeName
            case "background-color":
                return NSBackgroundColorAttributeName
            default:
                return NSFontAttributeName
            }
        }
        
        fileprivate func colorWithHexString (_ hex:String) -> HJSColor {
            
            var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if (cString.hasPrefix("#")) {
                cString = (cString as NSString).substring(from: 1)
            } else {
                switch cString {
                case "white":
                    return HJSColor(white: 1, alpha: 1)
                case "black":
                    return HJSColor(white: 0, alpha: 1)
                case "red":
                    return HJSColor(red: 1, green: 0, blue: 0, alpha: 1)
                case "green":
                    return HJSColor(red: 0, green: 1, blue: 0, alpha: 1)
                case "blue":
                    return HJSColor(red: 0, green: 0, blue: 1, alpha: 1)
                default:
                    return HJSColor.gray
                }
            }
            
            if (cString.characters.count != 6 && cString.characters.count != 3 ) {
                return HJSColor.gray
            }
            
            
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
            var divisor : CGFloat
            
            if (cString.characters.count == 6 ) {
                
                let rString = (cString as NSString).substring(to: 2)
                let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
                let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
                
                Scanner(string: rString).scanHexInt32(&r)
                Scanner(string: gString).scanHexInt32(&g)
                Scanner(string: bString).scanHexInt32(&b)
                
                divisor = 255.0
                
            } else {
                let rString = (cString as NSString).substring(to: 1)
                let gString = ((cString as NSString).substring(from: 1) as NSString).substring(to: 1)
                let bString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 1)
                
                Scanner(string: rString).scanHexInt32(&r)
                Scanner(string: gString).scanHexInt32(&g)
                Scanner(string: bString).scanHexInt32(&b)
                
                divisor = 15.0
            }
            
            return HJSColor(red: CGFloat(r) / divisor, green: CGFloat(g) / divisor, blue: CGFloat(b) / divisor, alpha: CGFloat(1))
        }
    }
}

