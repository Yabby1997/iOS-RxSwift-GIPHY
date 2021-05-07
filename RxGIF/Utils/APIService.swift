//
//  APIService.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import RxSwift

class APIService {
    static func fetchGif(keyword: String, onComplete: @escaping (Result<Data, Error>) -> Void) {
        let apiURL = api + API_KEY + query + keyword + settings
        URLSession.shared.dataTask(with: URL(string: apiURL)!) { data, res, err in
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
