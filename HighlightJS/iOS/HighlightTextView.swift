
import Foundation
import UIKit

open class HighlightView: UIView {
    
    open var textView: UITextView!
    
    open var highlighter : HighlightJS!
    open let textStorage = HighlightJSAttributedString()
    
    open let layoutManager = NSLayoutManager()
    open let textContainer = NSTextContainer(size: CGSize.zero)
    
    @IBInspectable open var text: String {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }
    
    open var font: UIFont? {
        get {
            return highlighter.theme.codeFont
        }
        set {
            if let f = newValue {
                highlighter.theme.setCodeFont(f)
            }
        }
    }
    
    open var language: HighlightJS.LanguageName = .markdown {
        didSet {
            textStorage.language = language.rawValue
        }
    }
    
    @IBInspectable var languageName: String {
        get {
            return language.rawValue
        }
        set {
            if let l = HighlightJS.LanguageName(rawValue: newValue.lowercased()) {
                language = l
            }
        }
    }
    
    //var themeName: String = "RailsCasts" {
    open var theme: HighlightJS.ThemeName = .solarizedLight {
        didSet {
            textStorage.highlightJS.setTheme(to: theme.rawValue)
            backgroundColor = highlighter.theme.themeBackgroundColor
        }
    }
    
    @IBInspectable var themeName: String {
        get {
            return theme.rawValue
        }
        set {
            if let t = HighlightJS.ThemeName(rawValue: newValue.lowercased()) {
                theme = t
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public func setup() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        highlighter = textStorage.highlightJS
        
        language = .markdown
        theme = .solarizedLight
        
        textView = UITextView(frame: frame, textContainer: textContainer)
        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.autocapitalizationType = UITextAutocapitalizationType.none
        textView.textColor = UIColor(white: 0.8, alpha: 1.0)
        addSubview(textView)
        
        addConstraint(NSLayoutConstraint(item: textView,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .top,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: textView,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .left,
                                         multiplier: 1,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: textView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: textView,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .right,
                                         multiplier: 1,
                                         constant: 0))
    }
}

public typealias HJSView = HighlightView
public typealias HJSTextView = HighlightView

