//
//  BuildUpServiceType.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import Foundation
import RxSwift


protocol BuildUpServiceType: AnyObject {
    func nextQuestion() -> Observable<QuestionDocument>
}


