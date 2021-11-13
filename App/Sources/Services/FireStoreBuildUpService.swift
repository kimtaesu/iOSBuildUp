//
//  FireStoreBuildUpService.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation
import RxSwift
import FirebaseFirestore

final class FireStoreBuildUpService: BuildUpServiceType {
    
    private let fireStore = Firestore.firestore()
    
    func answer() -> Observable<Void> {
        return Observable.empty()
    }
    
    func nextQuestion() -> Observable<QuestionDocument> {
        
            
        let res = QuestionDocument(
            docId: "dY1FXrLtzk97fCoYJCgG",
            question: .init(question: "RxSwift에서 Hot Observable의 특징이 아닌 것은 무엇일까요?"),
            chioces: [
                .init(answers: "A", isCorrect: true),
                .init(answers: "B", isCorrect: false),
                .init(answers: "C", isCorrect: false),
                .init(answers: "D", isCorrect: false),
                .init(answers: "E", isCorrect: false),
                .init(answers: "F", isCorrect: false),
                .init(answers: "G", isCorrect: false),
                .init(answers: "H", isCorrect: false),
                .init(answers: "I", isCorrect: false),
                .init(answers: "Z", isCorrect: true),
            ],
            tags: [
                .init(title: "RxSwift"),
                .init(title: "Swift"),
            ]
        )
        return .just(res)
    }
    
}
