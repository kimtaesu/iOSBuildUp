//
//  FireStoreBuildUpService.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation
import RxSwift

final class FireStoreBuildUpService: BuildUpServiceType {
    func nextQuestion() -> Observable<QuestionDocument> {
        let res = QuestionDocument(
            question: .init(question: "RxSwift에서 Hot Observable의 특징이 아닌 것은 무엇일까요?"),
            chioces: [
                .init(answers: "A", isCorrect: true),
                .init(answers: "B", isCorrect: false)
        ])
        return .just(res)
    }
}
