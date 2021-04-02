//
//  PrincipalViewModel.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

// swiftlint:disable identifier_name
public class PrincipalViewModel {
    enum StorageTypes {
        static let principalSection = 0
    }

    // MARK: - I/O
    struct Input {}

    struct Output {
        let principalItems: Driver<[PrincipalSectionModel]>
    }

    let input: Input
    let output: Output

    // MARK: - Subjects
    let _principalItems = BehaviorRelay<[PrincipalSectionModel]>(value: [])

    // MARK: - Properties
    var principalItems: [PrincipalSectionModel] {
        get {
            _principalItems.value
        }
        set {
            _principalItems.accept(newValue)
        }
    }

    let disposeBag = DisposeBag()
    var hackerNewsList: [HackerNew]?

    // MARK: - Constructor
    init(hackerNewsList: [HackerNew]) {
        self.hackerNewsList = hackerNewsList
        input = Input()
        output = Output(principalItems: _principalItems.asDriver())
        principalItems = [.principalSection(title: "", items: [])]
        showNewsList(hackerNewsList: self.hackerNewsList ?? [])
        
        var _ = SearchByDateCall(delegate: self)
    }

    func showNewsList(hackerNewsList: [HackerNew]) {
        let hackerNewsItems: [PrincipalCollectionItem] = hackerNewsList.map {
            let hackerNew = PrincipalCollectionViewCellModel(
                title: $0.title,
                sourceTime: "\($0.source) - \($0.time)"
            )
            return .principal(model: hackerNew)
        }

        let section: PrincipalSectionModel = .principalSection(
            title: "",
            items: hackerNewsItems
        )

        principalItems[0] = section
    }
    
    static func getMockData() -> [HackerNew] {
        var newsList: [HackerNew] = []
        newsList.append(HackerNew(title: "Noticia 1", source: "La Cuarta", time: "hace 5min"))
        newsList.append(HackerNew(title: "Noticia 2", source: "La Tercera", time: "hace 10min"))
        newsList.append(HackerNew(title: "Noticia 3", source: "La Segunda", time: "hace 20min"))
        return newsList
    }
}

extension PrincipalViewModel: SearchByDateCallDelegate {
    func getValidResponse(searchByDate: SearchByDate) {
        print("getValidResponse")
    }
}

struct HackerNew {
    var title: String
    var source: String
    var time: String
}
