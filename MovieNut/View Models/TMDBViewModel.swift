import Foundation

final class TMDBViewModel: ObservableObject {
    
    private let network = TMDbNetworkManager()
    
    @Published var searchTitle: String = ""
    @Published var searchYear: String = ""
    @Published var candidates: [Movie] = []
    @Published var reviewText: String = ""
    @Published var rating = 2.5
    @Published var showAlert = false
    @Published var errorMessage = "Error"
    @Published var showReviewView = false
    
    // The TMDb API does not return the IMDb id on the search endpoint
    // We have to fetch it once we have selected a movie
    @Published var selectedCandidate: SelectedCandidate? {
        didSet {
            if let sel = selectedCandidate, sel.candidate.imdbID == nil {
                Task {
                    let imdb = await getIMDbID(id: sel.candidate.id)
                    DispatchQueue.main.async {
                        self.selectedCandidate!.candidate.imdbID = imdb
                    }
                }
            }
        }
    }
    
    var currentPage = 1
    var totalPages = 1
    var isLoading = false
    var canLoadMore = false
    
    var searchNavigationTitle: String {
        if searchYear.isBlank == false {
            return "\(searchTitle) [\(searchYear)]"
        }
        return searchTitle
    }
    
    func searchCandidates(page: Int = 1) {
        isLoading = true
        if page == 1 {
            canLoadMore = false
            candidates = []
        }
        if let _ = Int(searchYear) {
            Task {
                let result = await network.searchMovies(title: searchTitle, page: page, year: searchYear)
                getCandidates(from: result)
            }
        } else {
            Task {
                let result = await network.searchMovies(title: searchTitle, page: page)
                getCandidates(from: result)
            }
        }
    }
    
    private func getCandidates(from result: Result<MovieSearchResult, MNError>) {
        switch result {
        case .success(let content):
            gotMovieSearchResult(content)
        case .failure(let error):
            DispatchQueue.main.async {
                self.errorMessage = error.description
                self.showAlert.toggle()
            }
        }
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    func getNextCandidatesPageIfNeeded(index: Int) {
        guard index == candidates.count - 1 else { return }
        guard isLoading == false && canLoadMore else { return }
        if currentPage < totalPages {
            currentPage += 1
            searchCandidates(page: currentPage)
        } else {
            canLoadMore = false
        }
    }
    
    func getIMDbID(id: Int) async -> String? {
        return await network.getImdbID(id: id)
    }
    
    private func gotMovieSearchResult(_ result: MovieSearchResult) {
        let res = result.results ?? []
        totalPages = result.total_pages
        if currentPage < totalPages {
            canLoadMore = true
        } else {
            canLoadMore = false
        }
        // The TMDb API returns incomplete credits from the search endpoint
        // We have to make an additional API call for each movie in order to get the full credits
        for var candidate in res {
            if candidate.directorArray.isEmpty || candidate.castArray.isEmpty {
                self.network.getMovieCredits(id: candidate.id) { creds in
                    switch creds {
                    case .success(let credits):
                        if let crew = credits.crew, crew.isEmpty == false {
                            let dirs = crew.filter { $0.job == "Director" }.compactMap { $0.name }
                            candidate.directorArray = dirs
                            if !dirs.isEmpty {
                                let t = "Director"
                                if dirs.count > 1 {
                                    let n = dirs.joined(separator: ", ")
                                    candidate.director = "\(t)s: \(n)"
                                } else {
                                    candidate.director = "\(t): \(dirs[0])"
                                }
                            }
                        }
                        if let c = credits.cast, !c.isEmpty {
                            let cast = c.compactMap { $0.name }
                            if !cast.isEmpty {
                                if cast.count > 5 {
                                    let cc = Array(cast[0...4])
                                    candidate.castArray = cc
                                    candidate.cast = "Cast: \(cc.joined(separator: ", "))"
                                } else {
                                    candidate.castArray = cast
                                    candidate.cast = "Cast: \(cast.joined(separator: ", "))"
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.candidates.append(candidate)
                        }
                    case .failure(let error):
                        self.errorMessage = error.description
                    }
                }
            }
        }
    }
    
}
