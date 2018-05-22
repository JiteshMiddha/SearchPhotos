//
//  FetchImageOperation.swift
//  SearchPhotos
//
//  Created by Jitesh Middha on 21/05/18.
//  Copyright © 2018 Jitesh Middha. All rights reserved.
//

import UIKit
final class FetchImageOperation: Operation {
    
    private let completion: (UIImage?) -> ()
    private let imageURL: URL
    
    init(imageURL: String, size: CGSize = CGSize.zero, completion: @escaping (UIImage?) -> Void) {
        
        self.completion = completion
        self.imageURL = URL(string: imageURL)!
        
        super.init()
        self.name = "Image Operation"
    }
    
    
    override func main() {
        
        let task = URLSession(configuration: .default).dataTask(with: imageURL) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            guard response != nil else {
                print("no response")
                return
            }
            guard data != nil else {
                print("no data")
                return
            }
            DispatchQueue.main.async {
                
                self.completion(UIImage(data: data!))
            }
        }
        task.resume()
        
    }
}
