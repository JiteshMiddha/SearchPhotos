//
//  Photo.swift
//  SearchPhotos
//
//  Created by Jitesh Middha on 21/05/18.
//  Copyright © 2018 Jitesh Middha. All rights reserved.
//

import Foundation

struct Photo {
    
    private struct Keys {
        
        static let id = "id"
        static let urls = "urls"
    }
    
    var id: String?
    var urls: PhotoURLs?
    
    
    init?(dictionary: [String : Any]?) {
        
        guard let dictionary = dictionary else {return nil}
        
        if let id = dictionary[Keys.id] as? String {
           
            self.id = id
        }
        
        if let urls = dictionary[Keys.urls] as? [String: String] {
            
            self.urls = PhotoURLs.init(dictionary: urls)!
        }
        
    }
}

