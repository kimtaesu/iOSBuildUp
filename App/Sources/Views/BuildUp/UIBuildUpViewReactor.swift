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
        case signIn(AuthCredential)
        case tapNext
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDocument(QuestionDocument)
        case setAuthData(AuthDataResult)
        case setSignInError(Error)
    }
    
    struct State {
        var signInError: Error?
        var isLoading: Bool = false
        var document: QuestionDocument?
        var question: String?
        var choices: [CheckChoice]?
        
        var selectedAnswers: [CheckChoice] = []
        
        var authDataResult: AuthDataResult?
        var sections: [BuildUpSection] = []
        
        var userPhotoURL: URL? {
            logger.debug("user photo url: \(String(describing: self.authDataResult?.user.photoURL))")
            return self.authDataResult?.user.photoURL
        }
        var authProvider: AuthProvider? {
            return AuthProvider.create(provider: self.authDataResult?.credential?.provider)
        }
        
        var isLoggined: Bool {
            return self.authDataResult != nil && self.authDataResult?.user.isAnonymous == false
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
        case .signIn(let credential):
            return self.authService.signIn(credential)
                .map(Mutation.setAuthData)
                .catch { .just(.setSignInError($0))}
            
        case .tapNext:
            return .empty()
        case .refresh:
            guard !self.currentState.isLoading else { return .empty() }
            
            let startLoading: Observable<Mutation> = .just(.setLoading(true))
            let nextQuestion: Observable<Mutation> = self.buildUpService.nextQuestion()
                .map(Mutation.setDocument)
            let endLoading: Observable<Mutation> = .just(.setLoading(false))
            
            return Observable.concat(startLoading, nextQuestion, endLoading)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.signInError = nil
        
        switch mutation {
        case .setSignInError(let error):
            state.signInError = error
        case .setAuthData(let data):
            state.authDataResult = data
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
            .map(BuildUpChoiceCellReactor.init)
            .map(BuildUpSectionItem.checkChioce)
        
        
        return [
            .questions([.question(doc.question)]),
//            .like(.like(.init(doc.likes))),
            .tag(.tags(doc.tags)),
            .answers(choiceSectionItems)
        ]
    }
}
