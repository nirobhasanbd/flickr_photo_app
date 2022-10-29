//
//  PhotoSearchViewModel.swift
//  FlickrPhotoApp
//
//  Created by mac 2019 on 10/26/22.
//

import Foundation

class PhotoSearchViewModel {
    var searchText: String = ""
    var photoModels: [PhotoModel] = []
    var page = 1
    var apiCalling = false
    
    func searchPhoto(onResult: @escaping (_ message: String?, _ error: String?) -> Void) {
        let params: [String: String] = ["method": APIConstants.method, "api_key": APIConstants.api_key, "format": APIConstants.format, "nojsoncallback": "1", "secrete": APIConstants.secrete, "media": APIConstants.media, "per_page": "30", "tags": searchText]
        
        NetworkServices.shared.getRequest(type: PhotoResponseModel.self, endPoint: APIConstants.photoSearchEndPoint, params: params) {[weak self] value, error in
            if value != nil { // success
                if value?.stat == ApiState.ok.rawValue {
                    let message = value?.message ?? "default message"
                    self?.photoModels = value?.photoListModel?.photos ?? []
                    self?.page = 2
                    print("message: \(message)")
                    onResult(message, nil)
                }
                else { // no data found
                    let errorMsg = value?.message ?? "default error"
                    print("errorMsg: \(errorMsg)")
                    onResult(nil, errorMsg)
                }
            }
            else { // error
                let errorMsg = error?.localizedDescription ?? "error"
                print("errorMsg: \(errorMsg)")
                onResult(nil, errorMsg)
            }
        }
    }
    
    func loadMorePhoto(onResult: @escaping (_ message: String?, _ error: String?) -> Void) {
        let params: [String: String] = ["method": APIConstants.method, "api_key": APIConstants.api_key, "format": APIConstants.format, "nojsoncallback": "1", "secrete": APIConstants.secrete, "media": APIConstants.media, "page": "\(page)", "per_page": "30", "tags": searchText]
        
        NetworkServices.shared.getRequest(type: PhotoResponseModel.self, endPoint: APIConstants.photoSearchEndPoint, params: params) {[weak self] value, error in
            if value != nil { // success
                if value?.stat == ApiState.ok.rawValue {
                    let message = value?.message ?? "default message"
                    self?.photoModels.append(contentsOf: value?.photoListModel?.photos ?? [])
                    self?.page = (self?.page ?? 1) + 1
                    print("message: \(message)")
                    onResult(message, nil)
                }
                else { // no data found
                    let errorMsg = value?.message ?? "default error"
                    print("message: \(errorMsg)")
                    onResult(nil, errorMsg)
                }
            }
            else { // error
                let errorMsg = error?.localizedDescription ?? "error"
                print("errorMsg: \(errorMsg)")
                onResult(nil, errorMsg)
            }
        }
    }
}
