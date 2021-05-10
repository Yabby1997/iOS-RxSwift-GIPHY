//
//  APIService.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import RxSwift

class APIService {
    static func fetchGif(keyword: String?, onComplete: @escaping (Result<Data, Error>) -> Void) {
        var apiURL: URL?
        if keyword != nil {
            guard let keyword = keyword else { return }
            apiURL = URL(string: searchAPI + API_KEY + searchQuery + keyword + settings)
        } else {
            apiURL = URL(string: randomAPI + API_KEY + settings)
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
    
    static func fetchGifRx(keyword: String) -> Observable<Data> {
        return Observable.create() { emitter in
            fetchGif(keyword: keyword) { result in
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
