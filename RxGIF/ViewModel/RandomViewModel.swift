//
//  RandomViewModel.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/10.
//

import Foundation
import RxSwift

class RandomViewModel {
    lazy var gifObservable = PublishSubject<Gif>()
    
    func getRandomGif() {
        _ = APIService.fetchGifRx(keyword: nil)
            .map { data -> SingleGifResponse in
                let object = try! JSONDecoder().decode(SingleGifResponse.self, from: data)
                return object
            }
            .map { gifResponse -> Gif in
                return Gif(from: gifResponse.gif)
            }
            .take(1)
            .subscribe(onNext: {
                self.gifObservable.onNext($0)
            })
    }
}
