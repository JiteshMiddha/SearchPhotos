//
//  FetchPhotosResponse.swift
//  SearchPhotos
//
//  Created by Jitesh Middha on 21/05/18.
//  Copyright © 2018 Jitesh Middha. All rights reserved.
//

import Foundation

struct FetchPhotosResponse {
    
    private struct Keys {
        
        static let total = "total"
        static let totalPages = "total_pages"
        static let results = "results"
    }
    
    var total: NSNumber?
    var totalPages: NSNumber?
    var results: [Photo]?
    
    init?(dictionary: [String : Any]?) {
        
        guard let dictionary = dictionary else {return nil}
        
        if let total = dictionary[Keys.total] as? NSNumber {
            
            self.total = total
        }
        if let totalPages = dictionary[Keys.totalPages] as? NSNumber {
            
            self.totalPages = totalPages
        }
        
        if let results = dictionary[Keys.results] as? [Any] {
            
            var itemsArray = [Photo]()
            for items in results {
                let photo = Photo.init(dictionary: items as? [String : Any])!
                itemsArray.append(photo)
            }
            self.results = itemsArray
        }
        
    }
    
}
