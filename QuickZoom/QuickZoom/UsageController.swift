//
//  UsageController.swift
//  QuickZoom
//
//  Created by 晋先森 on 4/17/21.
//

import Cocoa

class LinkTextField: NSTextField {
    override func mouseDown(with event: NSEvent) {
        self.sendAction(self.action, to: self.target)
    }
}

class UsageController: NSViewController {

    @IBOutlet weak var descriptionTextField: LinkTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextField.action = #selector(openLink)
        descriptionTextField.attributedStringValue = attributeString
    }
    
    var attributeString: NSAttributedString {
        let text = "\(Const.appName) can help you quickly join the Zoom meeting, reducing the tedious copy and paste, and the probability of errors when copying.\n\nWhen you copy the Zoom link, you automatically join the meeting.\nPlease refer to the image below to learn how to use it:\n"
        let attribute = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : NSColor.labelColor])
        attribute.addAttribute(.link, value: Const.github, range: (text as NSString).range(of: Const.appName))
        return attribute
    }
    
    @objc func openLink() {
        if let url = URL(string: Const.github) {
            NSWorkspace.shared.open(url)
        }
    }
    
}
