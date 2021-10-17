import SwiftUI

struct SearchFormGroup: View {
    
    @EnvironmentObject var tmdbViewModel: TMDBViewModel
    
    var body: some View {
        Group {
            SearchForm(formTitle: "Title",
                       formPlaceholder: "Enter (part of) the title",
                       formTarget: $tmdbViewModel.searchTitle,
                       style: .primary)
                
                .padding(.vertical)
            
            SearchForm(formTitle: "Year (optional)",
                       formPlaceholder: "Enter the release year",
                       formTarget: $tmdbViewModel.searchYear,
                       style: .secondary)

                .padding(.vertical)
        }
    }
}
