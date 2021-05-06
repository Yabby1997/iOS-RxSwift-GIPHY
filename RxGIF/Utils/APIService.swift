//
//  APIService.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import RxSwift

let api = "https://api.giphy.com/v1/gifs/search?api_key=\(API_KEY)&q=cat&limit=25&offset=0&rating=g&lang=en"

class APIService {
    static func fetchGif(onComplete: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: api)!) { data, res, err in
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
    
    static func fetchGifRx() -> Observable<Data> {
        return Observable.create() { emitter in
            fetchGif { result in
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
