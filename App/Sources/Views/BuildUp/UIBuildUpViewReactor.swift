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
        case viewWillAppear
        
        case signOut
        case tapNext
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDocument(QuestionDocument)
        case setUser(User?)
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
        case .viewWillAppear:
            return self.authService.stateDidChange()
                .map(Mutation.setUser)
        case .signOut:
            return self.authService.signOut()
                .map { Mutation.setUser(nil) }
                .catch { .just(.setSignInError($0))}
            
        case .signIn(let credential):
            return self.authService.signIn(credential)
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
            
            let serUser: Observable<Mutation> = self.authService.getUser()
                .map(Mutation.setUser)
            return Observable.concat(startLoading, serUser, nextQuestion, endLoading)
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
            .map(BuildUpChoiceCellReactor.init)
            .map(BuildUpSectionItem.checkChioce)
        
        
        return [
            .questions([.question(doc.question)]),
            .tag(.tags(doc.tags)),
            .answers(choiceSectionItems)
        ]
    }
}

extension UIBuildUpViewReactor.State {
    var userPhotoURL: URL? {
        return self.user?.photoURL
    }
    var authProvider: AuthProvider? {
        
        let providerID = self.user?.providerData.first?.providerID
        return AuthProvider.create(provider: providerID)
    }
    
    var isLoggined: Bool {
        return self.user != nil && self.user?.isAnonymous == false
    }
    
    var authDropDownItems: [AuthDropDownItem] {
        return self.isLoggined ? [.logout] : AuthDropDownItem.signInItems
    }
}
