//
//  Constants.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation
import Nuke

let searchAPI = "https://api.giphy.com/v1/gifs/search?api_key="
let randomAPI = "https://api.giphy.com/v1/gifs/random?api_key="
let trendingAPI = "https://api.giphy.com/v1/gifs/trending?api_key="
let searchQuery = "&q="
let settings = "&limit=100&offset=0&rating=g&lang=en"

let API_KEY = "7FckdoA95APjXjzIPCRm9he4wpaa6DFC"

let nukeOptions = ImageLoadingOptions(
    transition: .fadeIn(duration: 0.45)
)
