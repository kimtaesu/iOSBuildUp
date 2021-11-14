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
        let data: MainCardModel
        let authService: AuthServiceType
        let firestoreRepository: FirestoreRepository
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
        case setQuestions([QuestionDocument])
        case setUser(User?)
        case setSignInError(Error)
        case setChoiceSelected(CheckChoice)
        case setNext(Bool)
    }
    
    struct State {
        var questions: [QuestionDocument] = []
        var document: QuestionDocument?
        var signInError: Error?
        var isLoading: Bool = false
        
        var selectedChoice: CheckChoice?
        
        var isNext: Bool = false
        var user: User?
        var sections: [BuildUpSection] = []
    }
    
    private let authService: AuthServiceType
    private let firestoreRepository: FirestoreRepository
    private let data: MainCardModel
    
    init(dependency: Dependency) {
        self.data = dependency.data
        self.firestoreRepository = dependency.firestoreRepository
        self.authService = dependency.authService
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromCheckCoiceEvent: Observable<Mutation> = CheckChoice.event
            .filter { [weak self] event in
                let currentDocId = self?.currentState.document?.docId
                switch event {
                case let .setChecked(docId, _):
                    return currentDocId == docId
                }
            }
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .setChecked(_, choice):
                    return .just(.setChoiceSelected(choice))
                }
        }
        return Observable.of(mutation, fromCheckCoiceEvent).merge()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isLoading else { return .empty() }
            
            let startLoading: Observable<Mutation> = .just(.setLoading(true))
            let nextQuestion: Observable<Mutation> = self.firestoreRepository.getQuestionsBySubject(subject: self.data.collectionId)
                .map(Mutation.setQuestions)
            let endLoading: Observable<Mutation> = .just(.setLoading(false))

            return Observable.concat(startLoading, nextQuestion, endLoading)
        case .viewWillAppear:
            return self.authService.stateDidChange()
                .map(Mutation.setUser)
        case .signOut:
            return self.authService.signOut()
                .map { Mutation.setUser(nil) }
                .catch { .just(.setSignInError($0))}
            
        case .signIn(let credential):
            return self.firestoreRepository.signIn(credential)
                .map(Mutation.setUser)
                .catch { .just(.setSignInError($0))}
            
        case .tapNext:
            guard let docId = self.currentState.document?.docId else { return .empty() }
            guard let selectedChoice = self.currentState.selectedChoice else { return .empty() }
            return self.firestoreRepository.answer(docId: docId, choice: selectedChoice)
                .map { _ in Mutation.setNext(true) }
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.signInError = nil
        state.isNext = false
        
        switch mutation {
        case .setChoiceSelected(let selected):
            state.selectedChoice = selected
        case .setSignInError(let error):
            state.signInError = error
        case .setUser(let user):
            state.user = user
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setQuestions(let questions):
            state.document = questions.first
            state.sections = self.makeSections(doc: questions.first!)
        case .setNext(let isNext):
            state.isNext = isNext
        }
        return state
    }
}

extension UIBuildUpViewReactor {
    func makeSections(doc: QuestionDocument) -> [BuildUpSection] {
        let choiceSectionItems = doc.choices
            .map { BuildUpChoiceCellReactor(docId: doc.docId, choice: $0) }
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
