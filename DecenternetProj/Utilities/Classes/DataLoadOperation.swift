//
//  DataLoadOperation.swift
//  DecenternetProj
//
//  Created by alvin joseph valdez on 12/5/19.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import Foundation

public class DataLoadOperation: Operation {
    
    public var photograph: Photograph?
    public var loadingCompletionHandler: ((Photograph) -> Void)?
    
    private let _photograph: Photograph
    
    init(_ photograph: Photograph) {
        _photograph = photograph
    }
    
    public override func main() {
        
        if isCancelled { return }
        
        let randomDelayTime = Int.random(in: 500..<2000)
        usleep(useconds_t(randomDelayTime * 1000))
        
        if isCancelled { return }
        
        self.photograph = self._photograph
        
        if let loadingCompleteHandler = self.loadingCompletionHandler {
            DispatchQueue.main.async {
                loadingCompleteHandler(self._photograph)
            }
        }
        
    }
    
}
