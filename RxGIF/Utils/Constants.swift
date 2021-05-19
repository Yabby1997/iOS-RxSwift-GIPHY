//
//  Constants.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import Nuke

enum Rating: Int, CustomStringConvertible {
    case g = 0, pg, pg13, r
    
    var description: String {
        switch(self) {
        case .g:
            return "g"
        case .pg:
            return "pg"
        case .pg13:
            return "pg-13"
        case .r:
            return "r"
        }
    }
}

let searchAPI = "https://api.giphy.com/v1/gifs/search?api_key="
let randomAPI = "https://api.giphy.com/v1/gifs/random?api_key="
let trendingAPI = "https://api.giphy.com/v1/gifs/trending?api_key="
let searchQuery = "&q="

func getSettings(offset: Int) -> String {
    let userDefaults = UserDefaults.standard
    let limit = userDefaults.integer(forKey: "DisplayImageCount")
    let rating = (Rating(rawValue: userDefaults.integer(forKey: "ImageRatingIndex"))?.description)!
    let language = "en"
    return "&limit=\(limit)&offset=\(offset)&rating=\(rating)&lang=\(language)"
}

let errorGifURL = "https://media2.giphy.com/media/TqiwHbFBaZ4ti/giphy.gif?cid=6e4ee9ccj5w9ce7akqfmiuvkyb6ffs4e8v7if83qdouo1dl8&rid=giphy.gif&ct=g"

let API_KEY = "7FckdoA95APjXjzIPCRm9he4wpaa6DFC"

let nukeOptions = ImageLoadingOptions(
    transition: .fadeIn(duration: 0.45)
)
