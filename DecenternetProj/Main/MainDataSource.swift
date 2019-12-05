//
//  MainDataSource.swift
//  DecenternetProj
//
//  Created by alvin joseph valdez on 12/5/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class MainDataSource: NSObject {
    
    // MARK: - Initializer
    public init(collectionView: UICollectionView, photographs: [Photograph]) {
        self.collectionView = collectionView
        self.photographs = photographs
        self.numberOfCells = photographs.count
        super.init()
        
        self.collectionView.register(
            MainCell.self,
            forCellWithReuseIdentifier: MainCell.identifier
        )
        
        self.collectionView.dataSource = self
    }
    
    // MARK: - Stored Properties
    public unowned let collectionView: UICollectionView
    public var photographs: [Photograph]
    private var numberOfCells: Int
    private var page: Int = 1
    
}

extension MainDataSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photographs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier, for: indexPath) as! MainCell
        
        cell.configure(with: self.photographs[indexPath.row])
        
        return cell
    }
    
}
