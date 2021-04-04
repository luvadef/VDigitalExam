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
    func getPersistenceResponse(searchByDate: SearchByDate)
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
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.method = .get
        urlRequest.timeoutInterval = 3

        if NetworkState.isConnected() {
            AF.request(
                urlRequest
            ).responseJSON { response in
//                let responseString = String(data: response.data ?? Data(), encoding: .utf8)
//                print("callService-responseString: \(responseString)")
//                LocalStorage.addLastResponse(value: responseString ?? "")
                do {
                    let result = try JSONDecoder().decode(SearchByDate.self, from: response.data ?? Data())
                    LocalStorage.addLastResponse(searchByDate: result)
                    if let delegate = self.delegate {
                        delegate.getValidResponse(searchByDate: result)
                    }
                } catch {
                    print("ERROR: \(error)")
                    self.returnPersistedData()
                }
            }
        } else {
            print("Network not connected.")
            self.returnPersistedData()
        }
    }

    func returnPersistedData() {
        let searchByDate = LocalStorage.getLastResponse()

        if let delegate = self.delegate {
            delegate.getPersistenceResponse(searchByDate: searchByDate)
        }
        print("returnPersistedData-responseString: \(searchByDate)")
    }
}
