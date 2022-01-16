import Foundation

final class TMDbNetworkManager {
    
    init() {
        Task {
            await getTmdbConfiguration()
        }
    }
    
    private var imageBaseUrl: String? = nil

    private func makeMovieSearchURL(title: String, page: Int, year: String? = nil) -> URL {
        let query = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if page == 1 {
            if let year = year {
                return URL(string: "\(TMDbURLComponents.searchURL)\(TMDbURLComponents.apikeySuffix)\(Credentials.tmdbAPIKey)\(TMDbURLComponents.searchSuffix)\(query)\(TMDbURLComponents.searchFilterSuffix)\(TMDbURLComponents.yearSuffix)\(year)")!
            } else {
                return URL(string: "\(TMDbURLComponents.searchURL)\(TMDbURLComponents.apikeySuffix)\(Credentials.tmdbAPIKey)\(TMDbURLComponents.searchSuffix)\(query)\(TMDbURLComponents.searchFilterSuffix)")!
            }
        } else {
            if let year = year {
                return URL(string: "\(TMDbURLComponents.searchURL)\(TMDbURLComponents.apikeySuffix)\(Credentials.tmdbAPIKey)\(TMDbURLComponents.searchSuffix)\(query)\(TMDbURLComponents.searchFilterSuffix)\(TMDbURLComponents.pageSuffix)\(page)\(TMDbURLComponents.yearSuffix)\(year)")!
            } else {
                return URL(string: "\(TMDbURLComponents.searchURL)\(TMDbURLComponents.apikeySuffix)\(Credentials.tmdbAPIKey)\(TMDbURLComponents.searchSuffix)\(query)\(TMDbURLComponents.searchFilterSuffix)\(TMDbURLComponents.pageSuffix)\(page)")!
            }
        }
    }
    
    private var tmdbConfig: URL {
        URL(string: TMDbURLComponents.configurationURL + TMDbURLComponents.apikeySuffix + Credentials.tmdbAPIKey)!
    }
    
    private func movieDetails(id: Int) -> URL {
        URL(string: "\(TMDbURLComponents.detailsURL)\(id)\(TMDbURLComponents.apikeySuffix)\(Credentials.tmdbAPIKey)")!
    }
    
    private func movieCredits(id: Int) -> URL {
        URL(string: "\(TMDbURLComponents.detailsURL)\(id)\(TMDbURLComponents.creditsSuffix)\(TMDbURLComponents.apikeySuffix)\(Credentials.tmdbAPIKey)")!
    }

    private func getTmdbConfiguration() async {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: tmdbConfig))
            let config = try JSONDecoder().decode(TMDbConfiguration.self, from: data)
            imageBaseUrl = config.images?.secure_base_url ?? TMDbURLComponents.imageBaseURL
        } catch {
            print(error)
        }
    }
    
    func searchMovies(title: String, page: Int, year: String? = nil) async -> Result<MovieSearchResult, MNError> {
        let title = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let year = year?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        do {
            let request = URLRequest(url: makeMovieSearchURL(title: title, page: page, year: year))
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(MovieSearchResult.self, from: data)
            return .success(result)
        } catch {
            return .failure(.data(message: error.localizedDescription))
        }
    }
    
    func getMovieCredits(id: Int, completion: @escaping (Result<MovieCreditsResult, MNError>)->()) {
        let task = URLSession.shared.dataTask(with: movieCredits(id: id)) { data, response, error in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(MovieCreditsResult.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.json(message: "invalid format")))
                }
            } else {
                completion(.failure(.data(message: "no data")))
            }
        }
        task.resume()
    }
    
    func getImdbID(id: Int) async -> String? {
        do {
            let request = URLRequest(url: movieDetails(id: id))
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let obj = json as? [String: Any] else { return nil }
            return obj["imdb_id"] as? String
        } catch {
            print(error)
            return nil
        }
    }
    
}
