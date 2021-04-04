//
//  LocalStorage.swift
//  VDigitalExam
//
//  Created by Cristian on 04-04-21.
//

import Foundation

class LocalStorage {
    static func addDeletedNew(value: String) {
        var allValues = getDeletedNews()
        allValues.append(value)
        UserDefaults.standard.set(allValues, forKey: StorageKeys.allValues)
    }

    static func getDeletedNews() -> [String] {
        return UserDefaults.standard.stringArray(forKey: StorageKeys.allValues) ?? []
    }

    static func addLastResponse(searchByDate: SearchByDate) {
        print("addLastResponse-searchByDate: \(searchByDate)")
        let preference = UserDefaults.standard
        if let encodedSearchByDate = try? JSONEncoder().encode(searchByDate) {
            preference.set(encodedSearchByDate, forKey: StorageKeys.allValues)
        }
    }

    static func getLastResponse() -> SearchByDate {
        let preference = UserDefaults.standard
        if let decodedData = preference.object(
            forKey: StorageKeys.allValues) as? Data {
                if let searchByDate = try? JSONDecoder().decode(SearchByDate.self, from: decodedData) {
                    return searchByDate
                }
            }
        return SearchByDate(hits: [], nbHits: -1, page: -1, nbPages: -1, hitsPerPage: -1, exhaustiveNbHits: false, query: "", params: "", processingTimeMS: -1)
    }
}

enum StorageKeys {
    static let allValues = "allValues"
    static let lastResponse = "lastResponse"
}
