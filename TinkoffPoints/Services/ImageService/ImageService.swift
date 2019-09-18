//
//  ImageService.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import UIKit

protocol ImageService {
    func image(by url: String, complete: ((UIImage?) -> Void)?)
}

final class ImageServiceImpl: ImageService {
    private var network: Network
    private var cache: Cache
    
    init(network: Network, cache: Cache) {
        self.network = network
        self.cache = cache
    }
    
    func image(by url: String, complete: ((UIImage?) -> Void)?) {
        
//        if cache.isExistData(by: url) {
//            imageFromCache(by: url, complete: complete)
//            return
//        }
        
        let date = self.cache.modificationDate(by: url)
        
        fetchImage(by: url, modificationDate: date) { [weak self] (image) in
            
            guard let image = image else {
                complete?(self?.imageFromCache(by: url))
                return
            }
            
            self?.cache.save(by: url, data: image.pngData())
            complete?(image)
        }
    }
    
    private func imageFromCache(by url: String) -> UIImage? {
        guard let data = cache.fileData(by: url) else {
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    private func fetchImage(by url: String,
                            modificationDate: Date?,
                            complete: ((UIImage?) -> Void)?) {
        let request = NetworkRequestDefault(url: url, method: .get, headers: nil, parameters: nil)
        network.send(request: request) { (data, error) in
            if error != nil {
                complete?(nil)
                return
            }
            
            guard let data = data else {
                complete?(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                complete?(nil)
                return
            }
            complete?(image)
        }
    }
}
