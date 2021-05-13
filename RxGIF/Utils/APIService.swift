//
//  APIService.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import RxSwift

class APIService {
    enum fetchMode {
        case search
        case random
        case trending
    }
    
    static func fetchGif(mode: fetchMode, keyword: String? = nil, onComplete: @escaping (Result<Data, Error>) -> Void) {
        var apiURL: URL?
        
        switch(mode) {
        case .search:
            guard let keyword = keyword else { return }
            apiURL = URL(string: searchAPI + API_KEY + searchQuery + keyword + settings)
        case .random:
            apiURL = URL(string: randomAPI + API_KEY + settings)
        case .trending:
            apiURL = URL(string: trendingAPI + API_KEY + settings)
        }
        
        guard let apiURL = apiURL else { return }
        
        URLSession.shared.dataTask(with: apiURL) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode,
                                            userInfo: nil)))
                return
            }
            onComplete(.success(data))
        }.resume()
    }
    
    static func fetchGifRx(mode: fetchMode, keyword: String? = nil) -> Observable<Data> {
        return Observable.create() { emitter in
            fetchGif(mode: mode, keyword: keyword) { result in
                switch result {
                case .success(let data) :
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let err) :
                    emitter.onError(err)
                }
            }
            return Disposables.create()
        }
    }
}
