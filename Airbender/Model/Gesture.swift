//
//  Gesture.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import Foundation
import UIKit

class Gesture {
    let id: Int
    let name: String
    let image: UIImage?
    let description: String
    
    init(id: Int, name: String, image: UIImage?, description: String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
    }
}
