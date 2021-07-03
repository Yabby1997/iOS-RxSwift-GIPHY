//
//  SearchViewModel.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import RxRelay
import RxSwift
import FLAnimatedImage
import Nuke

class SearchViewModel {
    lazy var gifObservable = BehaviorRelay<[Gif]>(value: [])
    var recentKeyword: String?
    
    func searchGif(keyword: String) {
        print("??")
        self.recentKeyword = keyword
        ImageCache.shared.removeAll()
        _ = APIService.fetchGifRx(mode: .search, keyword: keyword)
            .map { data -> GifResponseArray in
                let object = try! JSONDecoder().decode(GifResponseArray.self, from: data)
                return object
            }
            .map { GifResponseArray -> [Gif] in
                var gifArray: [Gif] = []
                for each in GifResponseArray.gifs  {
                    gifArray.append(Gif(from: each))
                }
                return gifArray
            }
            .take(1)
            .subscribe(onNext: {
                self.gifObservable.accept($0)
            })
    }
    
    func refreshGif() {
        guard let keyword = recentKeyword else { return }
        self.searchGif(keyword: keyword)
    }
}
