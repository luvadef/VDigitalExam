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
}

enum StorageKeys {
    static let allValues = "allValues"
}
