//
//  VDigitalExamBundle.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import Foundation

/// Esta clase es para cargar los Assets de la aplicaciòn, como por ejemplo los archivos xibs
class VDigitalExamBundle {}

enum VDigitalExamBundleHelper {
    static let frameworkBundle: Bundle? = {
        let frameworkBundle = Bundle(for: VDigitalExamBundle.self)
        let bundleURL = frameworkBundle.resourceURL
        let resourceBundle = Bundle(url: bundleURL!)
        return resourceBundle
    }()
}
