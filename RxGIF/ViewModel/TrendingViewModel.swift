//
//  TrendingViewModel.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/13.
//

import Foundation
import RxRelay
import RxSwift
import FLAnimatedImage
import Nuke

class TrendingViewModel {
    lazy var gifObservable = BehaviorRelay<[Gif]>(value: [])
    
    func fetchTrendingGif() {
        _ = APIService.fetchGifRx(mode: .trending)
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
        _ = APIService.fetchGifRx(mode: .trending, offset: self.gifObservable.value.count)
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
}
