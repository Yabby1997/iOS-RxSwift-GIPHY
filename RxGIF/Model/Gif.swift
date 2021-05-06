//
//  Gif.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation

struct Gif {
    let title: String           // title
    let source: String          // source_tld
    let trendingDate: String    // trending_datetime
    let thumbnailURL: URL    // images/downsized_small
    let originalURL: URL     // images/original
    
    init(from response: GifResponse) {
        self.title = response.title
        self.source = response.source
        self.trendingDate = response.trendingDatetime
        self.thumbnailURL = URL(string: response.getThumbnailURL())!
        self.originalURL = URL(string: response.getOriginalURL())!
    }
}

struct GifResponseArray: Decodable {
    var gifs: [GifResponse]
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
}

struct GifResponse: Decodable {
    var title: String
    var source: String
    var trendingDatetime: String
    var gifSources: GifURLs
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case source = "source_tld"
        case trendingDatetime = "trending_datetime"
        case gifSources = "images"
    }
    
    func getOriginalURL() -> String{
        return gifSources.original.url
    }
    
    func getThumbnailURL() -> String{
        return gifSources.thumbnail.url
    }
}

struct GifURLs: Decodable {
    var original: OriginalURL
    var thumbnail: ThumbnailURL
    enum CodingKeys: String, CodingKey {
        case original = "original"
        case thumbnail = "downsized_medium"
    }
}

struct OriginalURL: Decodable {
    var url: String
}

struct ThumbnailURL: Decodable {
    var url: String
}
