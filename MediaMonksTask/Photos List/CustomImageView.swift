//
//  CustomImageView.swift
//  MediaMonksTask
//
//  Created by Gopi K on 15/05/21.
//

import UIKit

class CustomImageView: UIImageView {
    
    private let imageCache = NSCache<NSURL, UIImage>()
    private var imageURL: URL?
    private lazy var apiManager: ApiManager = {
        let apiManager = ApiManager(delegate: self)
        return apiManager
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return activityIndicator
    }()
    private(set) var cacheImage: UIImage?
    
    private func getCacheImage() {
        if let urlValue = imageURL, let imageFromCache = imageCache.object(forKey: urlValue as NSURL) {
            self.cacheImage = imageFromCache
        }
    }
    
    func loadImageWithUrl(_ url: String) {
        // setup activityIndicator...
        imageURL = url.urlDescription
        image = nil
        activityIndicator.startAnimating()
        // retrieves image if already available in cache
        getCacheImage()
        if let cacheImage = self.cacheImage {
            self.image = cacheImage
            activityIndicator.stopAnimating()
            return
        }
        do {
            try apiManager.requestApi(for: url)
        } catch {
            activityIndicator.stopAnimating()
        }
    }
}

extension CustomImageView: ApiManagerDelegate {
    func apiResponseReceived(with result: Result<ResponseObject, ApiError>) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            do {
                let responseObject = try result.get()
                if let responseURL = responseObject.url, let imageToCache = UIImage(data: responseObject.data) {
                    if strongSelf.imageURL == responseURL {
                        strongSelf.image = imageToCache
                    }
                    strongSelf.imageCache.setObject(imageToCache, forKey: responseURL as NSURL)
                }
                strongSelf.activityIndicator.stopAnimating()
            } catch {
                strongSelf.activityIndicator.stopAnimating()
            }
        }
        
    }
}


