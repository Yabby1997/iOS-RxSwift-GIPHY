//
//  Constants.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import Nuke

let baseAPI = "https://api.giphy.com/v1/gifs/"
let searchAPI = "search?api_key="
let randomAPI = "random?api_key="
let trendingAPI = "trending?api_key="

let API_KEY = "7FckdoA95APjXjzIPCRm9he4wpaa6DFC"

let nukeOptions = ImageLoadingOptions(
    transition: .fadeIn(duration: 0.45)
)

let errorGifURL = "https://media2.giphy.com/media/TqiwHbFBaZ4ti/giphy.gif?cid=6e4ee9ccj5w9ce7akqfmiuvkyb6ffs4e8v7if83qdouo1dl8&rid=giphy.gif&ct=g"

let languages = ["en", "es", "pt", "id", "fr", "ar", "tr", "th", "vi", "de", "it", "ja", "zh-CN", "zh-TW", "ru", "ko", "pl", "nl", "ro", "hu", "sv", "cs", "hi", "bn", "da", "fa", "tl", "fi", "iw", "ms", "no", "uk"]
