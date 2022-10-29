//
//  PhotoListModel.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/27/22.
//

import Foundation

struct PhotoResponseModel: Decodable {
    let stat: String?
    let code: Int?
    let message: String?
    let photoListModel: PhotoListModel?
    
    enum CodingKeys: String, CodingKey {
        case stat
        case code
        case message
        case photoListModel = "photos"
    }
}

struct PhotoListModel: Decodable {
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let photos: [PhotoModel]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photos = "photo"
    }
}

struct PhotoModel: Decodable, Hashable {
    let uuid = UUID()
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String?
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    var url: URL? {
        let urlStr = APIConstants.imageBaseUrl + self.server + "/" + self.id + "_" + self.secret + ".jpg"
        return URL(string: urlStr)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case ispublic
        case isfriend
        case isfamily
    }
}
