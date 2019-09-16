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
        let viewModel = DepositPointsViewModelImpl()
        let viewController = DepositPointsViewController(viewModel: viewModel)
        window?.rootViewController = viewController
    }
}
