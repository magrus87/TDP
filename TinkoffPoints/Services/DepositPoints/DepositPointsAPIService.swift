//
//  DepositPointsAPIService.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 15/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation

protocol DepositPointsAPIService {
    func fetchPoints(latitude: Double,
                     longitude: Double,
                     radius: Int,
                     partners: String?,
                     success: (([PointsResponseModel]?) -> Void)?,
                     failure: ((Error) -> Void)?)
    
    func fetchPartners(accountType: String,
                       success: (([PartnersResponseModel]?) -> Void)?,
                       failure: ((Error) -> Void)?)
}

final class DepositPointsAPIServiceImpl: DepositPointsAPIService {
    //private var requestFactory: DepositPointsRequestFactory
    
    private var network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    func fetchPoints(latitude: Double,
                     longitude: Double,
                     radius: Int,
                     partners: String?,
                     success: (([PointsResponseModel]?) -> Void)?,
                     failure: ((Error) -> Void)?) {
        let request = PointsRequest(latitude: latitude,
                                    longitude: longitude,
                                    radius: radius,
                                    partners: partners)
        send(request: request,
             success: success,
             failure: failure)
    }
    
    func fetchPartners(accountType: String,
                       success: (([PartnersResponseModel]?) -> Void)?,
                       failure: ((Error) -> Void)?) {
        let request = PartnersRequest(accountType: accountType)
        send(request: request,
             success: success,
             failure: failure)
    }

    // MARK: - private
    
    private func send<T: Decodable>(request: NetworkRequest,
                                    success: ((T?) -> Void)?,
                                    failure: ((Error) -> Void)?) {
        network.send(request: request) { (data, error) in
            if let error = error {
                failure?(error)
                return
            }
            
            guard let data = data else {
                failure?(NetworkError.emptyData)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(DepositResponse<T>.self, from: data)
                guard response.resultCode == "OK" else {
                    failure?(NetworkError.invalidData)
                    return
                }
                success?(response.payload)
            } catch {
                failure?(NetworkError.serializationError(description: error.localizedDescription))
            }
        }
    }
}
