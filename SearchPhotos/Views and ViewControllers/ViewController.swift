//
//  ViewController.swift
//  SearchPhotos
//
//  Created by Jitesh Middha on 21/05/18.
//  Copyright © 2018 Jitesh Middha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var photos = [Photo]()
    var currentPage = 0
    var totalPages = 0
    let imageCache = NSCache<NSString, UIImage>()
    let operationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    // MARK:- IBActions
    @IBAction func didPressSearchButton(_ sender: UIButton) {
        
        self.fetchPhotos(pageNumber: 0, query: self.searchTextField.text!)
    }
    
    
    // fetch photos using FetchImageListOperation
    func fetchPhotos(pageNumber: Int, query: String) {
        self.activityIndicator.startAnimating()
        
        let fetchOperation = FetchImageListOperation(pageNumber: pageNumber, searchQuery: query) { (response, error) in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            if pageNumber > 0 {
                self.photos += (response?.results)!
            }
            else{
                self.photos = (response?.results)!
            }
            self.currentPage += 1
            self.totalPages = (response?.totalPages?.intValue)!
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        operationQueue.addOperation(fetchOperation)
    }

}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let photo = self.photos[indexPath.item]
        
        cell.photoImageView.image = UIImage()
        
        if let imageUrl = photo.urls?.thumbnail {
            
            if let cachedImage = self.imageCache.object(forKey: imageUrl as NSString) {
                // if cached image available
                cell.photoImageView.image = cachedImage
            }
            else {
            
                let fetchImageOperation = FetchImageOperation(imageURL: imageUrl) { (image) in
                    // downloading and caching image
                    if image != nil {
                        DispatchQueue.main.async {
                            self.imageCache.setObject(image!, forKey: imageUrl as NSString)
                            if cell.imageUrl == imageUrl {
                                
                                cell.photoImageView.image = image
                            }
                        }
                    }
                }
                
                self.operationQueue.addOperation(fetchImageOperation)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // fetching next page when 4th last image will be displayed
        if indexPath.item == photos.count - 4 && currentPage < totalPages {
            self.fetchPhotos(pageNumber: currentPage+1, query: self.searchTextField.text!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 20)/4 - 10
        // 20 = Left + right margins(10 each), 10 = horizontal spacing 
        return CGSize.init(width: size, height: size)
    }
}
