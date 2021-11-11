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
            question: .init(
                id: "12392",
                question: "RxSwift에서 Hot Observable의 특징이 아닌 것은 무엇일까요?"),
            chioces: [
                .init(id: "A", answers: "A", isCorrect: true),
                .init(id: "B", answers: "B", isCorrect: false),
                .init(id: "C", answers: "C", isCorrect: false),
                .init(id: "D", answers: "D", isCorrect: false),
                .init(id: "E", answers: "E", isCorrect: false),
                .init(id: "F", answers: "F", isCorrect: false),
                .init(id: "G", answers: "G", isCorrect: false),
                .init(id: "H", answers: "H", isCorrect: false),
                .init(id: "I", answers: "I", isCorrect: false),
                .init(id: "Z", answers: "Z", isCorrect: true),
            ],
            tags: [
                .init(id: "A", title: "RxSwift"),
                .init(id: "B", title: "Swift"),
            ]
        )
        return .just(res)
    }
}
