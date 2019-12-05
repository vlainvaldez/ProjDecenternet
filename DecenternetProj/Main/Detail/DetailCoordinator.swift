//
//  DetailCoordinator.swift
//  DecenternetProj
//
//  Created by alvin joseph valdez on 12/5/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class DetailCoordinator: AbstractCoordinator {
    
    // MARK: - Initializer
    public init(navigationController: UINavigationController, photograph: Photograph, details: Detail) {
        self.navigationController = navigationController
        self.photograph = photograph
        self.details = details
        super.init()
        
    }
    
    // MARK: - Stored Properties
    private unowned let navigationController: UINavigationController
    private unowned let photograph: Photograph
    private let details: Detail
    
    
    // MARK: - Instance Methods
    public override func start() {
        super.start()
        let vc: DetailVC = DetailVC(photograph: self.photograph, details: self.details)

        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
