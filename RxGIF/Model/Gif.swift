//
//  Gif.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation

//struct Gif {
//    let id: String              // id
//    let title: String           // title
//    let source: String          // source_tld
//    let trendingDate: String    // trending_datetime
//    let thumbnailURL: String    // images/downsized_small
//    let originalURL: String     // images/original
//}

/// Array of Gif objects.
struct GifArray: Decodable {
    var gifs: [Gif]
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
}

/// Contains giph properties
struct Gif: Decodable {
    var title: String
    var source: String
    var trendingDatetime: String
    var gifSources: GifImages
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case source = "source_tld"
        case trendingDatetime = "trending_datetime"
        case gifSources = "images"
    }
    
    /// Returns download url of the originial gif
    func getOriginalURL() -> String{
        return gifSources.original.url
    }
    
    func getThumbnailURL() -> String{
        return gifSources.thumbnail.url
    }
}

/// Stores the original Gif
struct GifImages: Decodable {
    var original: Original
    var thumbnail: Thumbnail
    enum CodingKeys: String, CodingKey {
        case original = "original"
        case thumbnail = "downsized_medium"
    }
}
/// URL to data of Gif
struct Original: Decodable {
    var url: String
}

/// URL to data of Gif
struct Thumbnail: Decodable {
    var url: String
}

