//
//  MainVC.swift
//  DecenternetProj
//
//  Created by alvin joseph valdez on 12/5/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import PKHUD

public final class MainVC: UIViewController {
    
    // MARK: - Delegate Properties
    public weak var delegate: MainVCDelegate?
    
    // MARK: - Initializer
    public init(photographs: [Photograph]) {
        self.photographs = photographs
        super.init(nibName: nil, bundle: nil)
        
        self.dataSource = MainDataSource(
            collectionView: self.rootView.collectionView,
            photographs: photographs
        )
        
        self.rootView.collectionView.delegate = self

    }
    
    public required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle Methods
    
    public override func loadView() {
        self.view = MainView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "FreeHero "

        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " Back",
            style: UIBarButtonItem.Style.plain,
            target: nil,
            action: nil
        )

    }
    
    // MARK: - Stored Properties
    private var dataSource: MainDataSource!
    public var photographs: [Photograph]
    private let loadingQueue = OperationQueue()
    private var loadingOperations: [IndexPath: DataLoadOperation] = [:]
    private var fetchMoreIsEnabled: Bool = false
    private let imageAPIService: ImageAPIService = ImageAPIService()
    private var page: Int = 1
}

// MARK: - Views
extension MainVC {
    
    unowned var rootView: MainView { return self.view as! MainView }

}

// MARK: - UICollectionViewDelegateFlowLayout Functions
extension MainVC: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(
            width: self.rootView.collectionView.frame.width - 30.0,
            height: (self.rootView.collectionView.frame.height - 30.0) / 4.0
        )
    }
}

// MARK: - ScrollViewDelegate Functions
extension MainVC {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.contentSize.height {
            if !self.fetchMoreIsEnabled {
                
                self.beginbatchFetch()
            }
        }
    }
    
    public func beginbatchFetch() {
        self.fetchMoreIsEnabled = true
        
        self.page += 1
        
        self.imageAPIService.getPhotograph(page: self.page) { [weak self] (photographs: [Photograph]) -> Void in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                self.photographs.append(contentsOf: photographs)
                self.dataSource.photographs.append(contentsOf: photographs)
                
                self.dataSource.collectionView.reloadData()
                self.fetchMoreIsEnabled = false
                
            }
        }
        
    }
}

// MARK: - UICollectionViewDelegate Functions
extension MainVC: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapped(with: self.photographs[indexPath.item])
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? MainCell else { return }
        
        let updateCellClosure: (Photograph?) -> Void = { [weak self] photograph in
            guard let self = self else { return }
            
            cell.configure(with: photograph!)
            
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        if let dataLoader = loadingOperations[indexPath] {
            if let photograph = dataLoader.photograph {
                cell.configure(with: photograph)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                dataLoader.loadingCompletionHandler = updateCellClosure
            }
        } else {
            if let dataLoader = self.loadPhotograph(at: indexPath.item) {
                dataLoader.loadingCompletionHandler = updateCellClosure
                
                loadingQueue.addOperation(dataLoader)
                
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func loadPhotograph(at index: Int) -> DataLoadOperation? {
        if (0..<self.photographs.count).contains(index) {
            return DataLoadOperation(self.photographs[index])
        }
        return .none
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching Functions
extension MainVC: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView,
                               prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let _ = loadingOperations[indexPath] {
                continue
            }
            
            if let dataLoader = self.loadPhotograph(at: indexPath.item) {
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
        
    }
}

// MARK: Helper Functions
extension MainVC {

    private func cellTapped(with photograph: Photograph) {
        HUD.show(.progress)
        self.delegate?.imageTapped(with: photograph) { [weak self](detail: Detail?) -> Void in

            guard let self = self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                if let detail = detail {
                    self.goToDetail(photograph: photograph, detail: detail)
                }
            }
        }
    }

    private func goToDetail(photograph: Photograph, detail: Detail) {
        self.delegate?.goToDetail(photograph: photograph, detail: detail)
    }

}
