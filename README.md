# HighlightJS.swift

## What's this?

`HighlightJS.swift` is a code syntax highlight library using [Highlight.js](https://highlightjs.org).

Supports 169 languages and 80 themes.

![preview](https://i.loli.net/2017/07/21/5971dd1e177bd.jpg)

![preview](https://i.loli.net/2017/07/21/5971dd3cda847.jpg)

## Requirements

* iOS 8.0+
* macOS 10.11+
* tvOS 9.0+
* Xcode 8 with Swift 3

## Installation

#### CocoaPods

```ruby
pod 'HighlightJS'
```

## Contribution

You are welcome to fork and submit pull requests.

## License

`HighlightJS.swift` is open-sourced software, licensed under the `MIT` license.

## Usage

#### HighlightJS

```swift
let textStorage = HighlightJSAttributedString()

let layoutManager = NSLayoutManager()
textStorage.addLayoutManager(layoutManager)

let textContainer = NSTextContainer(size: CGSize.zero)
layoutManager.addTextContainer(textContainer)

let textView = UITextView(frame: rect, textContainer: textContainer)
view.addSubview(textView)

var highlighter = textStorage.highlightJS

textStorage.language = HighlightJS.LanguageName.rawValue // "swift"
textStorage.highlightJS.setTheme(to: HighlightJS.ThemeName.rawValue) // "solarized-light"

textView.text = "func test() {}"
```

#### HighlightView (1.1.0+, iOS only)

```swift
let h = HighlightView(frame: rect)
view.addSubview(h)
h.language = .swift
h.theme = .solarizedLight
h.text = "func test() {}"
```

***

> Checkout the sample project for more detail.
