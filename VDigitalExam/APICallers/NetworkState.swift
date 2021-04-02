//
//  NetworkState.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import Foundation
import Reachability
import Alamofire

/// Utility to detect network status
class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
