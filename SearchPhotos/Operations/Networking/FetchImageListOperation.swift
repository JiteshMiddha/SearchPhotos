//
//  FetchImageListOperation.swift
//  SearchPhotos
//
//  Created by Jitesh Middha on 21/05/18.
//  Copyright © 2018 Jitesh Middha. All rights reserved.
//

import Foundation


final class FetchImageListOperation: Operation {
    
    // MARK: Private
    
    private let completion: (FetchPhotosResponse?, Error?) -> Void
    private let urlPath : URL
    
    // MARK: Initialization
    
    init(pageNumber: Int = 0, searchQuery: String, completion: @escaping (FetchPhotosResponse?, Error?) -> Void) {
        
        self.completion = completion
        
        var urlComponents = URLComponents(string: "https://api.unsplash.com/search/photos")
        var queryItems = [URLQueryItem]()
        
        let clientId = URLQueryItem(name: "client_id", value: "96a68e64ef3fd4a88d2632586eaf404b0e93ff42065aec72f88716a5484067b9") // cliend id for the api
        queryItems.append(clientId)
        
        let pageNumber = URLQueryItem(name: "page", value: pageNumber.description)
        queryItems.append(pageNumber)
        
        let photosPerPage = URLQueryItem(name: "per_page", value: "30")
        queryItems.append(photosPerPage)
        
        
        let query = URLQueryItem(name: "query", value: searchQuery)
        queryItems.append(query)
        
        urlComponents?.queryItems = queryItems
        self.urlPath = (urlComponents?.url)!
        
        super.init()
        self.name = "FetchImageListOperation"
    }
    
    
    // MARK: Override
    
    override func main() {
        
        // Network call
        var request = URLRequest(url: urlPath)
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            guard error == nil else {
                print("error while calling the service : \(String(describing: error))")
                self.completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                self.completion(nil, error)
                return
            }
            
            do {
                if let parsedJson = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] {
                    print("Service Response : " + (parsedJson.description))
                    
                    let modelObject = FetchPhotosResponse.init(dictionary: parsedJson)
                    self.completion(modelObject!, error)
                }
                
            } catch {
                print("error trying to convert data to JSON: "+error.localizedDescription)
                self.completion(nil, error)
            }
        }
        task.resume()
            
    }
    
}
