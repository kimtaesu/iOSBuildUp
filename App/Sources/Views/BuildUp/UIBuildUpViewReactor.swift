//
//  UIBuildUpViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import ReactorKit
import FirebaseAuth

final class UIBuildUpViewReactor: Reactor {
    
    struct Dependency {
        let authService: AuthServiceType
        let buildUpService: BuildUpServiceType
    }
    
    let initialState: State
    
    enum Action {
        case refresh
        case linkAccount(AuthCredential)
        case tapNext
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDocument(QuestionDocument)
        case setUser(User)
        case setSignInError(Error)
    }
    
    struct State {
        var signInError: Error?
        var isLoading: Bool = false
        var document: QuestionDocument?
        var question: String?
        var choices: [CheckChoice]?
        
        var selectedAnswers: [CheckChoice] = []
        
        var user: User?
        var sections: [BuildUpSection] = []
        
        var isLoggined: Bool {
            return self.user != nil && self.user?.isAnonymous == false
        }
    }
    
    private let authService: AuthServiceType
    private let buildUpService: BuildUpServiceType
    
    init(dependency: Dependency) {
        self.authService = dependency.authService
        self.buildUpService = dependency.buildUpService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .linkAccount(let credential):
            return self.authService.linkAccount(credential)
                .map(Mutation.setUser)
                .catch { .just(.setSignInError($0))}
            
        case .tapNext:
            return .empty()
        case .refresh:
            guard !self.currentState.isLoading else { return .empty() }
            
            let startLoading: Observable<Mutation> = .just(.setLoading(true))
            let nextQuestion: Observable<Mutation> = self.buildUpService.nextQuestion()
                .map(Mutation.setDocument)
            let endLoading: Observable<Mutation> = .just(.setLoading(false))
            
            let getUser: Observable<Mutation> = self.authService.getUserIfNeedAnonymous()
                .map(Mutation.setUser)
            
            return Observable.concat(startLoading, getUser, nextQuestion, endLoading)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.signInError = nil
        
        switch mutation {
        case .setSignInError(let error):
            state.signInError = error
        case .setUser(let user):
            state.user = user
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setDocument(let document):
            state.document = document
            state.sections = self.makeSections(doc: document)
        }
        return state
    }
}

extension UIBuildUpViewReactor {
    func makeSections(doc: QuestionDocument) -> [BuildUpSection] {
        
        let choiceSectionItems = doc.chioces
            .map(CheckChoiceCellReactor.init)
            .map(BuildUpSectionItem.checkChioce)
        
        return [
            .questions([.question(doc.question)]),
            .tag(.tags(doc.tags)),
            .answers(choiceSectionItems),
        ]
    }
}
