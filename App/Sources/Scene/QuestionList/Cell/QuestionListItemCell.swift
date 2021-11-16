//
//  QuestionListItemCell.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation
import UIKit

class QuestionListItemCell: UICollectionViewCell {
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let submitContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let resultImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let submitDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [self.resultImageView, self.submitDateLabel].forEach {
            self.submitContentView.addSubview($0)
        }
        [self.questionLabel, self.submitContentView].forEach {
            self.contentView.addSubview($0)
        }
        
        self.questionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.submitContentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            
            self.resultImageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.size.equalTo(24)
            }
            
            self.submitDateLabel.snp.makeConstraints {
                $0.top.equalTo(self.resultImageView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data: QuestionAnswer?
    
    func configCell(_ data: QuestionAnswer) {
        self.data = data
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}

import ReactorKit

extension QuestionListItemCell: ReactorKit.View, HasDisposeBag {
    typealias Reactor = QuestionListItemCellReactor
    
    func bind(reactor: Reactor) {
        Observable.just(true)
            .map { _ in Reactor.Action.observeAnswer }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        reactor.state.map { $0.doc }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] doc in
                guard let self = self else { return }
                self.configCell(question: doc)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.answer }
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] answer in
                guard let self = self else { return }
                self.configCell(answer: answer)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configCell(question: QuestionDocument) {
        self.questionLabel.text = question.question.text
    }
    
    private func configCell(answer: QuestionAnswer) {
        self.submitDateLabel.text = answer.isCorrect ? "정답" : "오답"
    }
}

extension QuestionListItemCell {
    class func size(_ width: CGFloat, reactor: Reactor) -> CGSize {
        return .init(width: width, height: 80)
    }
}

