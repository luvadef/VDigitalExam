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
    init() {
        input = Input()
        output = Output(principalItems: _principalItems.asDriver())
        principalItems = [.principalSection(title: "", items: [])]
        //showNewsList(hackerNewsList: self.hackerNewsList ?? [])
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

    func getNewsArray(searchByDate: SearchByDate) -> [HackerNew] {
        var hackerNews: [HackerNew] = []
        for hit in searchByDate.hits {
            let time = getHumanFromDate(changeUTCDateToHuman(hit.createdAt))
            let hackerNew = HackerNew(title: hit.storyTitle, source: hit.author, time: time)
            hackerNews.append(hackerNew)
        }
        return hackerNews
    }

    func changeUTCDateToHuman(_ stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: stringDate) ?? Date()
    }

    enum TimeCase {
        static let minute = 60
        static let hour = 3600
        static let twoHour = 7200
        static let day = 86400
        static let twoDays = 172800
    }

    func getHumanFromDate(_ date: Date) -> String {
        var result = -1
        var resultString = ""
        let now = NSDate().timeIntervalSince1970
        let before = date.timeIntervalSince1970
        let diference = Int(now - before)

        if diference > TimeCase.twoDays {
            result = Int(diference / TimeCase.day)
            resultString = "\(result) days ago"
        } else if diference > TimeCase.day {
            resultString = "1 day ago"
        } else if diference > TimeCase.twoHour {
            result = Int(diference / TimeCase.hour)
            resultString = "\(result) hours ago"
        } else if diference > TimeCase.hour {
            resultString = "1 hour ago"
        } else if diference > TimeCase.minute {
            result = Int(diference / TimeCase.minute)
            resultString = "\(result) minutes ago"
        } else {
            resultString = "few seconds ago"
        }
        return resultString
    }
}

// MARK: - SearchByDateCallDelegate
extension PrincipalViewModel: SearchByDateCallDelegate {
    func getValidResponse(searchByDate: SearchByDate) {
        //print("story_title: \(searchByDate.hits[0].storyTitle)")
        showNewsList(hackerNewsList: getNewsArray(searchByDate: searchByDate))
    }
}

struct HackerNew {
    var title: String
    var source: String
    var time: String
}
