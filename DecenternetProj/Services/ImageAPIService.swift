//
//  ImageAPIService.swift
//  DecenternetProj
//
//  Created by alvin joseph valdez on 12/5/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation
import Moya

public struct ImageAPIService {
    
    // MARK: - Store Properties
    private let photographProvider: MoyaProvider = MoyaProvider<PhotographRequest>()

    private let detailProvider: MoyaProvider = MoyaProvider<DetailRequest>()
    
    public func getPhotograph(page: Int = 1, completion: @escaping ([Photograph]) -> Void ) {
        
        self.photographProvider.request(PhotographRequest.getImages(page: page)) { (result) in
            switch result {
            case .success(let response):
                
                guard
                    let photographs: [Photograph] = try? JSONDecoder().decode(
                        [Photograph].self,
                        from: response.data
                    )
                    
                else { return }
                
                completion(photographs)
                
            case .failure(let error):
                print(error)
            }
        }
    }

    public func getPhotoDetail(id: String, completion: @escaping (Detail?) -> Void ) {
        self.detailProvider.request(DetailRequest.getDetail(id: id) ) { (result) in

            switch result {
            case .success(let response):

                guard
                    let details: Detail = try? JSONDecoder().decode(
                        Detail.self,
                        from: response.data
                    )

                    else { return }

                completion(details)

            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
}
