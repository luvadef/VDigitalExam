//
//  DetailViewController.swift
//  VDigitalExam
//
//  Created by Cristian on 03-04-21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    // MARK: - Oulets
    @IBOutlet weak var newsWebView: WKWebView!

    // MARK: - Variables
    var urlString: String

    // MARK: - Constructors
    init(urlString: String) {
        self.urlString = urlString
        super.init(
            nibName: "DetailViewController",
            bundle: VDigitalExamBundleHelper.frameworkBundle
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPage(urlString: urlString)
    }

    /// Loads the URL into the webView and shows the page
    func loadPage(urlString: String) {
        if let url = URL(string: urlString) {
            newsWebView.load(URLRequest(url: url))
            newsWebView.allowsBackForwardNavigationGestures = true
        }
    }
}
