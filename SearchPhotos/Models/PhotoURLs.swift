//
//  PhotoURLs.swift
//  SearchPhotos
//
//  Created by Jitesh Middha on 21/05/18.
//  Copyright © 2018 Jitesh Middha. All rights reserved.
//

import Foundation
struct PhotoURLs {
    
    private struct Keys {
        
        static let fullSize = "full"
        static let regular = "regular"
        static let thumbnail = "thumb"
    }
    
    var fullSize: String?
    var regular: String?
    var thumbnail: String?
    
    init?(dictionary: [String : Any]?) {
        
        guard let dictionary = dictionary else {return nil}
        
        if let fullSize = dictionary[Keys.fullSize] as? String {
            
            self.fullSize = fullSize
        }
        if let regular = dictionary[Keys.regular] as? String {
            
            self.regular = regular
        }
        if let thumbnail = dictionary[Keys.thumbnail] as? String {
            
            self.thumbnail = thumbnail
        }
        
        
    }
    
}
