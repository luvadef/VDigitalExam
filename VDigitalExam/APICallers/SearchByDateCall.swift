//
//  SearchByDateCall.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import Alamofire
import Foundation
import Reachability

protocol SearchByDateCallDelegate: AnyObject {
    func getValidResponse(searchByDate: SearchByDate)
}

class SearchByDateCall {
    let retries = 3
    var attempt = 0
    var delegate: SearchByDateCallDelegate
    
    init(delegate: SearchByDateCallDelegate) {
        self.delegate = delegate
        callService(url: Constants.UrlSearchByDate.url)
    }
    
    private func callService(url: String) {
        let parameters = [Constants.UrlSearchByDate.queryKey: Constants.UrlSearchByDate.queryValue]
        
        if NetworkState.isConnected() {
            AF.request(
                url,
                method: .get,
                parameters: parameters,
                encoder: URLEncodedFormParameterEncoder.default
            ).responseJSON { response in
                print("Response: \(response)")
            }
        }
    }
}
