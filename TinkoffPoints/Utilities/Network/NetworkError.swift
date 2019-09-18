//
//  NetworkError.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 ru.magrus87. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case undefined(description: String)
    case emptyResponse
    case emptyData
    case badRequest
    case invalidData
    case serializationError(description: String)
}
