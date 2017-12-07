//
//  AudioFile.swift
//  Yogi Practice
//
//  Created by margot on 2017-12-03.
//  Copyright © 2017 foxberryfields. All rights reserved.
//

import UIKit

class AudioFile {
    
    var name: String
    var description: String
    var URL: URL?
    
    init(name: String, description: String, URL: URL?) {
        
        // Initialize stored properties.
        self.name = name
        self.description = description
        self.URL = URL
    }

}
