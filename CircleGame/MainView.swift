//
//  MainView.swift
//  CircleGame
//
//  Created by Esten Hurtle on 4/5/17.
//  Copyright © 2017 Esten Hurtle. All rights reserved.
//

import Foundation
import UIKit

class MainView: UIView {
    var delegate:MainViewTouchDelegate? = nil
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onTouch()
    }
    
}

protocol MainViewTouchDelegate {
    func onTouch()
}
