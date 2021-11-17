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
import MSPeekCollectionViewDelegateImplementation

class UIDocumentViewController: BaseViewController, HasDropDownMenu {
    
    private struct Reusable {
        static let document = ReusableCell<UIDocumentCell>()
    }

    private struct Metrics {
        static let margin: CGFloat = 16
        static let floatingHeight: CGFloat = 56
    }
    private var sections: [DocumentPaginationSection] = [] {
        didSet {
            self.collectionView.dataSource = self
            self.collectionView.configureForPeekingBehavior(behavior: self.behavior)
            self.collectionView.reloadData()
        }
    }
    
    private let behavior: MSCollectionViewPeekingBehavior = {
        let behavior = MSCollectionViewPeekingBehavior()
        behavior.cellPeekWidth = 0
        behavior.scrollDirection = .horizontal
        behavior.cellSpacing = 0
        return behavior
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.document)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    private let submitButton: UIRoundedShadowButton = {
        let button = UIRoundedShadowButton()
        button.setTitle("제출", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontFamily.NotoSansCJKKR.medium.font(size: 20)
        button.fillColor = ColorName.primary.color
        return button
    }()
    
    let dropDown = DropDown()

    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.submitButton)
        
        self.submitButton.layer.shadowOffset = .init(width: 0, height: 1)
        self.submitButton.layer.shadowColor = UIColor.black.cgColor
        self.collectionView.delegate = self
     }
    
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.submitButton.snp.top).offset(-16)
        }

        self.submitButton.snp.makeConstraints {
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
    }
}

@objc extension UIDocumentViewController {
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
//                    let presentViewController = UINavigationController(rootViewController: self.questionListViewScreen(subject))
//                    presentViewController.modalPresentationStyle = .custom
//                    self.present(presentViewController, animated: true)
                    break
                case .contact:
//                    guard let question = self.reactor?.currentState.question else { return }
//                    self.contactDocument(RemoteConfigStore.shared.contactEmail, doc: question.question)
                    break
                }
            }
        )
    }
}

extension UIDocumentViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

extension UIDocumentViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.sections[indexPath.section].items[indexPath.item] {
        case .document(let reactor):
            let cell = collectionView.dequeue(Reusable.document, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    }
}

import ReactorKit

extension UIDocumentViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIDocumentViewReactor
    
    func bind(reactor: Reactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.listenQuestions }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.submitButton.rx.tap
            .map { _ in Reactor.Action.tapSubmit }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag) 
        
        reactor.state.map { $0.sections }
            .filterEmpty()
            .subscribe(onNext: { [weak self] sections in
                guard let self = self else { return }
                self.sections = sections
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isCorrect }
            .distinctUntilChanged()
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}

