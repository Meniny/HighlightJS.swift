//
//  ViewController.swift
//  Sample
//
//  Created by Meniny on 2017-07-21.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import HighlightJS

class ViewController: UIViewController {

    var source: CodeSource = .HTML
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let h = HighlightView(frame: view.bounds)
        h.frame.origin.y = 64
        h.frame.size.height = 64
        view.addSubview(h)
        h.language = .swift
        h.theme = .arduinoLight
        h.text = "func test() {}"
    }
    
    @IBOutlet weak var button: UIButton!

    @IBAction func showEditor(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "Pick a File",
                                     rows: CodeSource.allRawValues,
                                     initialSelection: 0,
                                     doneBlock: { (picker, index, value) in
                                        if let s = CodeSource(rawValue: value as! String) {
                                            self.source = s
                                        }
                                        DispatchQueue.main.async {
                                            let editor = EditorViewController(source: self.source)
                                            let navigation = UINavigationController(rootViewController: editor)
                                            self.present(navigation, animated: true, completion: nil)
                                        }
        }, cancel: nil, origin: self.button)
    }
    
}

