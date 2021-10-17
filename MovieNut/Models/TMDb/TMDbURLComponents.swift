import Foundation

class TMDbURLComponents {
    static let apikeySuffix = "?api_key="
    static let searchURL = "https://api.themoviedb.org/3/search/movie"
    static let configurationURL = "https://api.themoviedb.org/3/configuration"
    static let detailsURL = "https://api.themoviedb.org/3/movie/"
    static let creditsSuffix = "/credits"
    static let searchSuffix = "&query="
    static let searchFilterSuffix = "&include_adult=false"
    static let pageSuffix = "&page="
    static let yearSuffix = "&year="
    static var imageBaseURL = "https://image.tmdb.org/t/p/"
}
