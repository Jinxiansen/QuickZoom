//
//  PopoverController.swift
//  QuickZoom
//
//  Created by 晋先森 on 2021/4/10.
//

import Cocoa

class PopoverController: NSViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}


extension PopoverController {
    
    static func freshController() -> PopoverController {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PopoverController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverController else {
            fatalError("Something Wrong with Main.storyboard")
        }
        return viewcontroller
    }
}
