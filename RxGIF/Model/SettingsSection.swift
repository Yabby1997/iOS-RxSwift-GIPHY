//
//  SettingsSection.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/17.
//

import Foundation

/// 검색관련
// limit                한번에 뽑아올 양
// rating               g, pg, pg-13, r

/// 이미지 관련
// contentmode          꽉채우기, 채우지않기
// 썸네일데이터절약옵션       덜선명한거

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Search
    case Image
    
    var description: String {
        switch self {
        case .Search : return "검색"
        case .Image : return "이미지"
        }
    }
}

enum SearchOptions: Int, CaseIterable, CustomStringConvertible {
    case FetchLimit
    case Ratings
    
    var description: String {
        switch self {
        case .FetchLimit : return "한번에 표시될 이미지 수" // slider
        case .Ratings : return "이미지 등급"             // segment
        }
    }
}

enum ImageOptions: Int, CaseIterable, CustomStringConvertible {
    case ContentMode
    case DataSave
    
    var description: String {
        switch self {
        case .ContentMode : return "이미지 모드"         // segment
        case .DataSave : return "데이터 절약"            // toggle
        }
    }
}
