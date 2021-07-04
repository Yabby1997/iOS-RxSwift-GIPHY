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
    lazy var isNearToBottom = BehaviorRelay<Bool>(value: false)
    var recentKeyword: String?
    
    func searchGif(keyword: String) {
        self.recentKeyword = keyword
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
    
    func fetchMore() {
        _ = APIService.fetchGifRx(mode: .search, keyword: self.recentKeyword, offset: self.gifObservable.value.count)
            .map { data -> GifResponseArray in
                let object = try! JSONDecoder().decode(GifResponseArray.self, from: data)
                return object
            }
            .map { GifResponseArray -> [Gif] in
                var gifArray: [Gif] = self.gifObservable.value
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
