//
//  AppRouter.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import Foundation
import UIKit

protocol MainRouter {
    func showDepositPointsScreen()
}

final class AppRouter: MainRouter {
    
    private weak var window: UIWindow?
    
    init(mainWindow: UIWindow?) {
        self.window = mainWindow
    }
    
    // MARK: - MainRouter
    
    func showDepositPointsScreen() {
        let network = NetworkUtility()
        let cache = CacheUtility()
        let persistent = PersistentWorkerImpl()
        
        let pointsService = DepositPointsAPIServiceImpl(network: network)
        let imageService = ImageServiceImpl(network: network, cache: cache)
        
        let worker = PointsWorkerImpl(pointsService: pointsService,
                                      persistent: persistent)
        
        let viewModel = DepositPointsViewModelImpl(worker: worker,
                                                   imageService: imageService)
        let viewController = DepositPointsViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        window?.rootViewController = viewController
    }
}
