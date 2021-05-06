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
    lazy var gifObservable = BehaviorRelay<GifArray>(value: GifArray(gifs: []))
    
    init() {
        print("init")
        _ = APIService.fetchGifRx()
            .map { data -> GifArray in
                let object = try! JSONDecoder().decode(GifArray.self, from: data)
                return object
            }
            .take(1)
            .subscribe(onNext: {
                self.gifObservable.accept($0)
            })
    }
}
