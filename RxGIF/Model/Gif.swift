//
//  Gif.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import Foundation

struct Gif {
    let id: String
    let title: String
    let source: String
    let trendingDate: String
    let thumbnailURL: URL
    let smallThumbnailURL: URL
    let originalURL: URL
    
    init(from response: GifResponse) {
        self.id = response.id
        self.title = response.title
        self.source = response.source
        self.trendingDate = response.trendingDatetime
        self.thumbnailURL = URL(string: response.getThumbnailURL())!
        self.smallThumbnailURL = URL(string: response.getSmallThumbnailURL())!
        self.originalURL = URL(string: response.getOriginalURL())!
    }
}

struct GifResponseArray: Decodable {
    var gifs: [GifResponse]
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
}

struct SingleGifResponse: Decodable {
    var gif: GifResponse
    enum CodingKeys: String, CodingKey {
        case gif = "data"
    }
}

struct GifResponse: Decodable {
    var id: String
    var title: String
    var source: String
    var trendingDatetime: String
    var gifSources: GifURLs
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
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
    
    func getSmallThumbnailURL() -> String {
        return gifSources.smallThumbnail.url
    }
}

struct GifURLs: Decodable {
    var original: sourceURL
    var thumbnail: sourceURL
    var smallThumbnail: sourceURL
    enum CodingKeys: String, CodingKey {
        case original = "original"
        case thumbnail = "downsized_medium"
        case smallThumbnail = "preview_gif"
    }
}

struct sourceURL: Decodable {
    var url: String
}
