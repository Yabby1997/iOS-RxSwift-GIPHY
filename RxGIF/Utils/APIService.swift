//
//  APIService.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import RxSwift

func getQuery(keyword: String?) -> String{
    guard let keyword = keyword else { return "&q=cat" }
    return "&q=\(keyword)"
}

func getSettings(offset: Int) -> String {
    let userDefaults = UserDefaults.standard
    let limit = userDefaults.integer(forKey: "Limit")
    let rating = userDefaults.string(forKey: "Rating") ?? "g"
    let language = userDefaults.string(forKey: "Language") ?? "en"
    let settings = "&limit=\(limit)&offset=\(offset)&rating=\(rating)&lang=\(language)"
    
    return settings
}

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
            apiURL = URL(string: baseAPI + searchAPI + API_KEY + getQuery(keyword: keyword) + getSettings(offset: 0))
        case .random:
            apiURL = URL(string: baseAPI + randomAPI + API_KEY + getSettings(offset: 0))
        case .trending:
            apiURL = URL(string: baseAPI + trendingAPI + API_KEY + getSettings(offset: 0))
        }
        
        guard let apiURL = apiURL else { return }
        
        print(apiURL)
        
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
