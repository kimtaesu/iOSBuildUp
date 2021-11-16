//
//  UISolvingViewController.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import ReusableKit
import RxDataSources
import DropDown

class UIBuildUpViewController: BaseViewController, HasDropDownMenu {
    
    private struct Reusable {
        static let question = ReusableCell<BuildUpQuestionCell>()
        static let checkChioce = ReusableCell<BuildUpChoiceCell>()
        static let like = ReusableCell<BuildUpLikeCell>()
        static let tag = ReusableCell<BuildUpTagCell>()
    }

    private struct Metrics {
        static let margin: CGFloat = 16
        static let floatingHeight: CGFloat = 56
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<BuildUpSection> = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .question(let q):
            let cell = collectionView.dequeue(Reusable.question, for: indexPath)
            cell.configCell(q)
            return cell
        case .checkChioce(let reactor):
            let cell = collectionView.dequeue(Reusable.checkChioce, for: indexPath)
            cell.reactor = reactor
            return cell
        case .like(let reactor):
            let cell = collectionView.dequeue(Reusable.like, for: indexPath)
            cell.reactor = reactor
            return cell
        case .tags(let tags):
            let cell = collectionView.dequeue(Reusable.tag, for: indexPath)
            cell.configCell(tags: tags)
            return cell
        }
    })
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.checkChioce)
        collectionView.register(Reusable.question)
        collectionView.register(Reusable.tag)
        collectionView.register(Reusable.like)
        return collectionView
    }()
    
    private let nextButton: UIRoundedShadowButton = {
        let button = UIRoundedShadowButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontFamily.NotoSansCJKKR.medium.font(size: 20)
        button.fillColor = ColorName.primary.color

        return button
    }()
    
    let dropDown = DropDown()

    private let questionListViewScreen: (_ subject: String) -> UIQuestionListViewController
    
    init(reactor: Reactor, questionListViewScreen: @escaping (_ subject: String) -> UIQuestionListViewController) {
        defer { self.reactor = reactor }
        self.questionListViewScreen = questionListViewScreen
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.nextButton)
        
        self.nextButton.layer.shadowOffset = .init(width: 0, height: 1)
        self.nextButton.layer.shadowColor = UIColor.black.cgColor
        
        self.collectionView.contentInset.bottom = Metrics.floatingHeight + self.view.safeAreaInsets.bottom + 16
        self.collectionView.contentInset.left = Metrics.margin
        self.collectionView.contentInset.right = Metrics.margin
        self.collectionView.contentInset.top = Metrics.margin
     }
    
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-Metrics.margin)
            $0.height.equalTo(Metrics.floatingHeight)
            $0.trailing.equalToSuperview().inset(Metrics.margin)
            $0.leading.equalToSuperview().inset(Metrics.margin)
        }
    }
    
    private lazy var rightMenuBarButton: UIBarButtonItem = {
        UIBarButtonItem(image: Asset.moreVert.image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.more))
    }()
    
    override func setupNavigationBarItems() {
        let backButton = UIBarButtonItem(image: self.backImage, style: .plain, target: self, action: #selector(self.back))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.rightBarButtonItem = self.rightMenuBarButton
        
        self.centerTitle = self.reactor?.subject
    }
}

@objc extension UIBuildUpViewController {
    @objc func more() {
        self.showDropDownMenu()
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showDropDownMenu() {
        let dataSources: [String] = BuilUpMoreDropDownMenu.allCases.map { $0.title }
        self.showDropDown(
            dataSources: dataSources,
            anchorView: self.rightMenuBarButton.plainView,
            configIcon: { BuilUpMoreDropDownMenu.firstItem(title: $0)?.icon },
            didSelected: { [weak self] selected in
                guard let self = self else { return }
                guard let found = BuilUpMoreDropDownMenu.firstItem(title: selected) else { return }
                switch found {
                case .allQuestions:
                    guard let subject = self.reactor?.subject else { return }
                    let presentViewController = UINavigationController(rootViewController: self.questionListViewScreen(subject))
                    presentViewController.modalPresentationStyle = .custom
                    self.present(presentViewController, animated: true)
                    break
                case .contact:
                    guard let question = self.reactor?.currentState.question else { return }
                    self.contactDocument(RemoteConfigStore.shared.contactEmail, doc: question)
                }
            }
        )
    }
}

extension UIBuildUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        let sectionHeight = collectionView.sectionHeight(at: indexPath.section)
        
        switch self.dataSource[indexPath] {
        case .like:
            return Reusable.like.class.size(sectionWidth)
        case .question(let q):
            return Reusable.question.class.size(sectionWidth, sectionHeight, question: q)
        case .checkChioce(let reactor):
            return Reusable.checkChioce.class.size(sectionWidth, reactor)
        case .tags(let tags):
            return Reusable.tag.class.size(sectionWidth, tags: tags)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.dataSource[section] {
        case .answers:
            return 8
        case .questions, .tag, .like:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var inset: UIEdgeInsets = .zero
        
        switch self.dataSource[section] {
        case .questions:
            inset.bottom = Metrics.margin * 2
            return inset
        case .answers, .tag:
            inset.bottom = Metrics.margin
            return inset
        case .like:
            return inset
        }
    }
}

import ReactorKit

extension UIBuildUpViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIBuildUpViewReactor
    
    func bind(reactor: Reactor) {
        // MARK: Life Cycle
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.listenQuestion }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.tap
            .map { _ in Reactor.Action.tapNext }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag) 
        
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isNext }
            .distinctUntilChanged()
            .subscribe()
            .disposed(by: self.disposeBag)
        
    }
}

