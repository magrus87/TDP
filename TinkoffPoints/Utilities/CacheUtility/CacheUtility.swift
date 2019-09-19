//
//  CacheUtility.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 17/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

protocol Cache {
    func fileData(by path: String) -> Data?
    
    func save(by path: String, data: Data?)
    
    func remove(by path: String)
}

final class CacheUtility: Cache {
    
    func isExistData(by path: String) -> Bool {
        guard let url = url(with: path) else {
            return false
        }
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    func fileData(by path: String) -> Data? {
        guard let url = url(with: path) else {
            return nil
        }
        
        do {
            let data = try Data.init(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
    
    func save(by path: String, data: Data?) {
        guard let url = url(with: path) else {
            return
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            return
        }
        
        FileManager.default.createFile(atPath: url.path,
                                       contents: data,
                                       attributes: [.modificationDate : NSDate()])
    }
    
    func remove(by path: String) {
        guard let url = url(with: path) else {
            return
        }
        try? FileManager.default.removeItem(at: url)
    }
    
    private func url(with path: String, extenstion: String? = nil) -> URL? {
        var result = URL(fileURLWithPath: NSTemporaryDirectory())
        result.appendPathComponent(path)
        if let ext = extenstion {
            return result.appendingPathExtension(ext)
        }
        return result
    }
}
