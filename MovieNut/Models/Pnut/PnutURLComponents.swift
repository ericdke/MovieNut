import Foundation

class PnutURLComponents {
    static let movieClubChannel = "https://api.pnut.io/v0/channels/591/messages"
    static let movieClubChannelSearch = "https://api.pnut.io/v0/channels/messages/search?channel_ids=591"
    static let userTokenObject = "https://api.pnut.io/v0/token"
    static let includeMessageRaw = "include_message_raw=1"
    static let includeAll = "include_message_raw=1&include_deleted=0&include_html=0"
    static let reviewSearchType = "raw_types=io.aya.movie.review"
    static let userSearchComponent = "creator_id="
    static let sinceIdComponent = "since_id="
    static let beforeIdComponent = "before_id="
    static let countComponent = "count="
}
