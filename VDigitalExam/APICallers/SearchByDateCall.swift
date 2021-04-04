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
    weak var delegate: SearchByDateCallDelegate?

    init(delegate: SearchByDateCallDelegate) {
        self.delegate = delegate
        callService(url: Constants.UrlSearchByDate.url)
        print("SearchByDateCall")
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
                do {
                    let result = try JSONDecoder().decode(SearchByDate.self, from: response.data ?? Data())
                    if let delegate = self.delegate {
                        delegate.getValidResponse(searchByDate: result)
                    }
                } catch {
                    print("ERROR: \(error)")
                }
            }
        }
    }
}
