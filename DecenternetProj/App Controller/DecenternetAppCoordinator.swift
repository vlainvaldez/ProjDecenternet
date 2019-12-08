//
//  DecenternetAppCoordinator.swift
//  DecenternetProj
//
//  Created by alvin joseph valdez on 12/5/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

open class DecenternetAppCoordinator: AbstractCoordinator {
    
    // MARK: Initializer
    public init(window: UIWindow, rootViewController: UINavigationController) {
        self.window = window
        self.rootViewController = rootViewController
        super.init()
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = AppUI.Color.sky
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
        
    }
    
    // MARK: Stored Properties
    private let imageAPIService: ImageAPIService = ImageAPIService()
    private unowned let window: UIWindow
    private unowned let rootViewController: UINavigationController
    
    // MARK: Instance Methods
    public override func start() {
        super.start()
        self.imageAPIService.getPhotograph { (photographs: [Photograph]) -> Void in
            
            print("photographs counc \(photographs.count)")
            
            let coordinator: MainCoordinator = MainCoordinator(
                navigationController: self.rootViewController,
                photographs: photographs
            )
            coordinator.start()
            self.add(childCoordinator: self)
        }
    }
    
    
}

