//
//  UISolvingViewController.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import UIKit
import ReusableKit
import RxDataSources
import DropDown
import TagListView
import M13Checkbox

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
            self.collectionView.reloadData()
        }
    }
    
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
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let submitButton: UIRoundedShadowButton = {
        let button = UIRoundedShadowButton()
        button.setTitle("제출", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontFamily.NotoSansCJKKR.medium.font(size: 20)
        return button
    }()
    
    let dropDown = DropDown()
    private let accentColor: UIColor
    private var animationView: UIAnswerAnimationView?
    
    init(
        reactor: Reactor
    ) {
        defer { self.reactor = reactor }
        self.accentColor = UIColor(hex: reactor.currentState.subject.color)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setColorAppreance()
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.submitButton)
        self.view.backgroundColor = .white
        self.submitButton.layer.shadowOffset = .init(width: 0, height: 1)
        self.submitButton.layer.shadowColor = UIColor.black.cgColor
        self.collectionView.delegate = self
     }

    private func setColorAppreance() {
        self.submitButton.fillColor = self.accentColor
        TagListView.appearance().tagBackgroundColor = self.accentColor
        M13Checkbox.appearance().tintColor = self.accentColor
        UIDocumentAnswerCell.borderColor = self.accentColor
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

// MARK: DropDown Menu Actions
@objc extension UIDocumentViewController {
    @objc func more() {
        self.showDropDownMenu()
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showDropDownMenu() {
        let dataSources: [String] = DocumentMoreDropDownMenu.allCases.map { $0.title }
        self.showDropDown(
            dataSources: dataSources,
            anchorView: self.rightMenuBarButton.plainView,
            configIcon: { DocumentMoreDropDownMenu.firstItem(title: $0)?.icon },
            didSelected: { [weak self] selected in
                guard let self = self else { return }
                guard let found = DocumentMoreDropDownMenu.firstItem(title: selected) else { return }
                switch found {
                case .allQuestions:
                    guard let docListReactor = self.reactor?.createDocumentListReactor() else { return }
                    let docListViewController = UIQuestionListViewController(reactor: docListReactor, didSelectedAt: { docId in
                        self.reactor?.action.onNext(.setCurrentDocId(docId))
                    })
                    let presentViewController = UINavigationController(rootViewController: docListViewController)
                    presentViewController.modalPresentationStyle = .custom
                    self.present(presentViewController, animated: true)
                case .contact:
                    guard let document = self.reactor?.currentState.currentDocument else { return }
                    self.contactDocument(RemoteConfigStore.shared.contactEmail, document: document)
                }
            }
        )
    }
}

extension UIDocumentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        let sectionHeight = collectionView.sectionHeight(at: indexPath.section)
        return .init(width: sectionWidth, height: sectionHeight)
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
import Toaster

extension UIDocumentViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIDocumentViewReactor
    
    func bind(reactor: Reactor) {
        
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.listenQuestions }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // TODO: haptic feedback
        self.submitButton.rx.tap
            .map { _ in Reactor.Action.tapSubmit }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag) 
        
        reactor.state.map { $0.navigationTitle }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.centerTitle = title
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .filterEmpty()
            .subscribe(onNext: { [weak self] sections in
                guard let self = self else { return }
                self.sections = sections
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.currentPage }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] page in
                guard let self = self else { return }
//                self.collectionView.scrollToItem(at: .init(item: page, section: 0), at: .top, animated: false)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.toast }
            .filterNil()
            .subscribe(onNext: { toast in
                Toast.init(text: toast).show()
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isCorrect }
            .filterNil()
            .subscribe(onNext: { [weak self] isCorrect in
                guard let self = self else { return }
                self.animationView?.removeFromSuperview()
                
                let type = AnswerAnimationType(isCorrect: isCorrect)
                self.animationView = UIAnswerAnimationView(type: type)
                self.animationView?.show(superView: self.view)
            })
            .disposed(by: self.disposeBag)
    }
}

