import SwiftUI

final class PnutViewModel: NSObject, ObservableObject {
    
    private let network = PnutNetworkManager()
    private let prefs = UserDefaults.standard
    private var token: String?
    private var userToken: PnutToken?
    @Published var showAlert = false
    @Published var errorMessage = "Error"
    @Published var showLoginFromMain = false
    @Published var showLoginFromClub = false
    @Published var showLoginFromSettings = false
    @Published var messages: [PnutMessage] = []
    @Published var thread: [PnutMessage] = []
    @Published var writePostText = ""
    @Published var writeReplyText = ""
    @Published var threadId: String?
    @Published var showThread = false {
        didSet {
            if showThread, let t = threadId {
                loadThread(threadId: t, sinceId: nil, beforeId: nil)
            } else {
                threadId = nil
                thread = []
            }
        }
    }
    var selectedReplyTarget: SelectedReplyTarget? {
        didSet {
            if selectedReplyTarget == nil {
                startMainTimer()
            } else {
                stopMainTimer()
            }
        }
    }
    private var firstNetworkCall = true
    private var minId: String?
    private var maxId: String?
    private var threadMinId: String?
    private var threadMaxId: String?
    private var canLoadMore = true
    private var threadCanLoadMore = true
    private var isLoading = false
    private var deletedIds: [String] = []
    private var mainTimer: Timer?
    
    override init() {
        super.init()
        loadTokens()
        if isLoggedIn {
            loadMessages(sinceId: nil, beforeId: nil)
            startMainTimer()
        }
        
        // This is sent from the login web view once the user has logged in
        NotificationCenter.default.addObserver(self, selector: #selector(gotTokenNotification(_:)), name: NSNotification.GotToken, object: nil)
    }
    
    @objc func gotTokenNotification(_ notification: Notification) {
        if let res = notification.object as? TokenResponse {
            gotAuthToken(token: res.token, origin: res.origin)
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid login response"
                self.showAlert.toggle()
            }
        }
    }
    
    func startMainTimer() {
        stopMainTimer()
        mainTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { t in
            self.loadMessages(sinceId: self.maxId)
        })
    }
    
    func stopMainTimer() {
        mainTimer?.invalidate()
        mainTimer = nil
    }
    
    var isLoggedIn: Bool {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return true
        }
        #endif
        if let _ = token {
            return true
        } else if let t = prefs.string(forKey: Keys.savedToken) {
            token = t
            return true
        }
        return false
    }
    
    func logout() {
        stopMainTimer()
        token = nil
        userToken = nil
        messages = []
        thread = []
        threadId = nil
        prefs.removeObject(forKey: Keys.savedToken)
        prefs.removeObject(forKey: Keys.savedUserToken)
    }
    
    func setToken(_ token: String) {
        self.token = token
        prefs.set(token, forKey: Keys.savedToken)
    }
    
    func setUserToken(_ object: PnutToken) {
        userToken = object
        if let enc = try? JSONEncoder().encode(object) {
            prefs.set(enc, forKey: Keys.savedUserToken)
        }
    }
    
    func getUserToken() -> PnutToken? {
        if let t = userToken {
            return t
        } else if let dat = prefs.object(forKey: Keys.savedUserToken) as? Data,
            let t = try? JSONDecoder().decode(PnutToken.self, from: dat)
        {
            userToken = t
            return t
        }
        return nil
    }
    
    func loadTokens() {
        if let t = prefs.string(forKey: Keys.savedToken) {
            token = t
        }
        if let dat = prefs.object(forKey: Keys.savedUserToken) as? Data,
            let t = try? JSONDecoder().decode(PnutToken.self, from: dat)
        {
            userToken = t
        }
    }

    func postMessage() {
        guard let token = token else {
            DispatchQueue.main.async {
                self.errorMessage = "No user token"
                self.showAlert.toggle()
            }
            return
        }
        network.postMessage(token: token, content: writePostText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.errorMessage = error.description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func postReply() {
        guard let token = token else {
            DispatchQueue.main.async {
                self.errorMessage = "No user token"
                self.showAlert.toggle()
            }
            return
        }
        guard let original = selectedReplyTarget else {
            DispatchQueue.main.async {
                self.errorMessage = "No message"
                self.showAlert.toggle()
            }
            return
        }
        network.postReply(token: token, content: writeReplyText, replyToId: original.target.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.errorMessage = error.description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func postReview(movie: Movie) {
        guard let token = token else {
            DispatchQueue.main.async {
                self.errorMessage = "No user token"
                self.showAlert.toggle()
            }
            return
        }
        network.postReview(token: token, movie: movie) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.errorMessage = error.description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func deleteMessage(id: String) {
        guard let token = token else {
            DispatchQueue.main.async {
                self.errorMessage = "No user token"
                self.showAlert.toggle()
            }
            return
        }
        network.deleteMessage(token: token, messageId: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.errorMessage = error.description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func loadThread(threadId: String, sinceId: String? = nil, beforeId: String? = nil) {
        guard let token = token else {
            DispatchQueue.main.async {
                self.errorMessage = "No user token"
                self.showAlert.toggle()
            }
            return
        }
        network.getThreadMessages(token: token, threadId: threadId, sinceId: sinceId, beforeId: beforeId) { queuedResult in
            DispatchQueue.main.async {
                switch queuedResult {
                case .success(let content):
                    switch content.order {
                    case .replace:
                        if let max = content.result.meta?.max_id {
                            self.threadMaxId = max
                        }
                        self.thread = content.result.data ?? []
                    case .before:
                        if let min = content.result.meta?.min_id {
                            self.threadMinId = min
                        }
                        if let meta = content.result.meta, meta.more == false {
                            self.threadCanLoadMore = false
                        }
                        if let data = content.result.data {
                            self.thread.append(contentsOf: data)
                        }
                    case .since:
                        if let max = content.result.meta?.max_id {
                            self.threadMaxId = max
                        }
                        if let data = content.result.data {
                            self.thread.insert(contentsOf: data, at: 0)
                        }
                    }
                    if let del = content.result.meta?.deleted_ids, del.isEmpty == false {
                        if del != self.deletedIds {
                            self.deletedIds = del
                            outer: for deleted in del {
                                for (idx, msg) in self.thread.enumerated() {
                                    if msg.id == deleted {
                                        self.thread.remove(at: idx)
                                        continue outer
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self.errorMessage = error.description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func loadMessages(sinceId: String? = nil, beforeId: String? = nil) {
        guard let token = token else {
            DispatchQueue.main.async {
                self.errorMessage = "No user token"
                self.showAlert.toggle()
            }
            return
        }
        network.getMessages(token: token, sinceId: sinceId, beforeId: beforeId) { queuedResult in
            DispatchQueue.main.async {
                switch queuedResult {
                case .success(let content):
                    if self.firstNetworkCall {
                        self.firstNetworkCall = false
                        if let min = content.result.meta?.min_id {
                            self.minId = min
                        }
                    }
                    switch content.order {
                    case .replace:
                        if let max = content.result.meta?.max_id {
                            self.maxId = max
                        }
                        self.messages = content.result.data ?? []
                    case .before:
                        if let min = content.result.meta?.min_id {
                            self.minId = min
                        }
                        if let meta = content.result.meta, meta.more == false {
                            self.canLoadMore = false
                        }
                        if let data = content.result.data {
                            self.messages.append(contentsOf: data)
                        }
                    case .since:
                        if let max = content.result.meta?.max_id {
                            self.maxId = max
                        }
                        if let data = content.result.data {
                            self.messages.insert(contentsOf: data, at: 0)
                        }
                    }
                    if let del = content.result.meta?.deleted_ids, del.isEmpty == false {
                        if del != self.deletedIds {
                            self.deletedIds = del
                            outer: for deleted in del {
                                for (idx, msg) in self.messages.enumerated() {
                                    if msg.id == deleted {
                                        self.messages.remove(at: idx)
                                        continue outer
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self.errorMessage = error.description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func loadMoreMain(after index: Int) {
        guard isLoggedIn else {
            errorMessage = "Not logged in"
            showAlert.toggle()
            return
        }
        guard index == messages.count - 1 else { return }
        guard isLoading == false && canLoadMore else { return }
        network.getMessages(token: token!, beforeId: minId) { queuedResult in
            DispatchQueue.main.async {
                switch queuedResult {
                case .success(let content):
                    switch content.order {
                    case .before:
                        if let min = content.result.meta?.min_id {
                            self.minId = min
                        }
                        if let meta = content.result.meta, meta.more == false {
                            self.canLoadMore = false
                        }
                        if let data = content.result.data {
                            self.messages.append(contentsOf: data)
                        }
                    default:
                        break
                    }
                case .failure(let error):
                    self.errorMessage = error.description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    func loadMoreThread(after index: Int) {
        // TODO: not implemented
//        fatalError()
    }
    
    func gotAuthToken(token: String, origin: LoginOrigin) {
        DispatchQueue.main.async {
            self.setToken(token)
            if self.userToken == nil {
                self.network.getUserTokenObject(token: token) { result in
                    switch result {
                    case .success(let content):
                        if let t = content.data {
                            self.setUserToken(t)
                        } else {
                            self.errorMessage = content.meta.error_message ?? "No user token"
                            self.showAlert.toggle()
                        }
                    case .failure(let error):
                        self.errorMessage = error.description
                        self.showAlert.toggle()
                    }
                }
            }
            switch origin {
            case .main:
                self.showLoginFromMain = false
            case .club:
                self.showLoginFromClub = false
            case .settings:
                self.showLoginFromSettings = false
            }
            self.loadMessages(sinceId: nil, beforeId: nil)
            self.startMainTimer()
        }
    }
}
