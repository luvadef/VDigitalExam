//
//  PrincipalViewController.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// swiftlint:disable force_cast
// swiftlint:disable unused_capture_list
class PrincipalViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var principalCollectionView: UICollectionView!

    // MARK: - Class Variables
    let disposeBag = DisposeBag()
    var viewModel: PrincipalViewModel
    var callingService: Bool = false

    // MARK: - Constructors
    init() {
        viewModel = PrincipalViewModel()
        super.init(
            nibName: "PrincipalViewController",
            bundle: VDigitalExamBundleHelper.frameworkBundle
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hacker News"
        setupCollectionView()
        setupBindings()
    }

    func setupCollectionView() {
        principalCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        principalCollectionView.register(
            UINib(
                nibName: "PrincipalCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "PrincipalCollectionViewCell"
        )
    }

    func setupBindings() {
        viewModel.output.principalItems
            .drive(principalCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        principalCollectionView.rx.modelSelected(PrincipalCollectionItem.self)
            .subscribe(onNext: { [weak self] model in
                    switch model {
                    case .principal(model: let model):
                        print("Cell Tapped \(model)")
                        if let self = self {
                            self.showDetail(urlString: model.urlString)
                        }
                    }
                }
            ).disposed(by: disposeBag)
    }

    func dataSource() -> RxCollectionViewSectionedReloadDataSource<PrincipalSectionModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<PrincipalSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, _ -> UICollectionViewCell in
                switch dataSource[indexPath] {
                case .principal(model: let model):
                    let cell: PrincipalCollectionViewCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "PrincipalCollectionViewCell",
                        for: indexPath
                    ) as! PrincipalCollectionViewCell
                    cell.setup(
                        model: PrincipalCollectionViewCellModel(
                            title: model.title,
                            sourceTime: model.sourceTime,
                            urlString: model.urlString
                        )
                    )
                    return cell
                }
            }
        )
        return dataSource
    }

    func pullToRefresh() {
        print("pull to refresh")
        callingService = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("Service Called")
            self.callingService = false
        }
    }

    func showDetail(urlString: String) {
        let detailViewController = DetailViewController(urlString: urlString)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension PrincipalViewController: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 && !callingService {
            pullToRefresh()
        } else {
            print("already calling service")
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 80)
    }
}

// MARK: - CustomFlowLayout
open class PrincipalCustomFlowLayout: UICollectionViewFlowLayout {
    override public init() {
        super.init()
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() { }
}

// MARK: - Rx Section Models
enum PrincipalSectionModel {
    case principalSection(title: String, items: [PrincipalCollectionItem])
}

enum PrincipalCollectionItem {
    case principal(model: PrincipalCollectionViewCellModel)
}

extension PrincipalSectionModel: SectionModelType {
    typealias Item = PrincipalCollectionItem

    var items: [Item] {
        switch self {
        case .principalSection(title: _, items: let items):
            return items
        }
    }

    init(original: PrincipalSectionModel, items: [Item]) {
        switch original {
        case let .principalSection(title: title, items: _):
            self = .principalSection(title: title, items: items)
        }
    }
}
