//
//  SearchViewModel.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import RxRelay
import RxSwift

class SearchViewModel {
    lazy var gifObservable = BehaviorRelay<[Gif]>(value: [])
    
    init() {
        print("init")
        _ = APIService.fetchGifRx()
            .map { data -> GifResponseArray in
                let object = try! JSONDecoder().decode(GifResponseArray.self, from: data)
                return object
            }
            .map { GifResponseArray -> [Gif] in
                var gifArray: [Gif] = []
                for eachGif in GifResponseArray.gifs  {
                    gifArray.append(Gif(title: eachGif.title, source: eachGif.source, trendingDate: eachGif.trendingDatetime, thumbnailURL: eachGif.getThumbnailURL(), originalURL: eachGif.getOriginalURL()))
                }
                return gifArray
            }
            .take(1)
            .subscribe(onNext: {
                self.gifObservable.accept($0)
            })
    }
}
