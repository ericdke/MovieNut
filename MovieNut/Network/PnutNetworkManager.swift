import Foundation

final class PnutNetworkManager {
    
    private let authorization = "Authorization"
    private let contentType = "Content-Type"
    private let applicationJson = "application/json"
    private let bearer = "Bearer"
    
    typealias MNPostedResult = Result<PnutPostedMessageResult, MNError>
    typealias MNTokenResult = Result<PnutTokenResult, MNError>
    typealias MNChannelResult = Result<PnutChannelResultQueued, MNError>
    
    private func makeUserTokenObjectRequest(token: String) -> URLRequest {
        let url = URL(string: PnutURLComponents.userTokenObject)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(applicationJson, forHTTPHeaderField: contentType)
        request.addValue("\(bearer) \(token)", forHTTPHeaderField: authorization)
        return request
    }
    
    private func makeGetRequestForPnut(token: String, component: String?, sinceId: String?, beforeId: String?, count: Int) -> URLRequest {
        var u: String
        if let c = component {
            u = "\(PnutURLComponents.movieClubChannel)\(c.addingURLComponent(component: PnutURLComponents.includeAll, first: true))"
        } else {
            u = PnutURLComponents.movieClubChannel.addingURLComponent(component: PnutURLComponents.includeAll, first: true)
        }
        u = u.addingURLComponent(component: "\(PnutURLComponents.countComponent)\(count)")
        if let s = sinceId {
            u = u.addingURLComponent(component: "\(PnutURLComponents.sinceIdComponent)\(s)")
        }
        if let b = beforeId {
            u = u.addingURLComponent(component: "\(PnutURLComponents.beforeIdComponent)\(b)")
        }
        let url = URL(string: u)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(applicationJson, forHTTPHeaderField: contentType)
        request.addValue("\(bearer) \(token)", forHTTPHeaderField: authorization)
        return request
    }
    
    private func makeMessagesRequest(token: String, sinceId: String?, beforeId: String?, count: Int) -> URLRequest {
        return makeGetRequestForPnut(token: token, component: nil, sinceId: sinceId, beforeId: beforeId, count: count)
    }
    
    private func makePostMessageRequest(token: String, content: String) -> URLRequest {
        let url = URL(string: PnutURLComponents.movieClubChannel)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(applicationJson, forHTTPHeaderField: contentType)
        request.addValue("\(bearer) \(token)", forHTTPHeaderField: authorization)
        request.httpBody = content.jsonDataForMessage()
        return request
    }
    
    private func makePostReplyRequest(token: String, content: String, replyToId: String) -> URLRequest {
        let url = URL(string: PnutURLComponents.movieClubChannel)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(applicationJson, forHTTPHeaderField: contentType)
        request.addValue("\(bearer) \(token)", forHTTPHeaderField: authorization)
        request.httpBody = content.jsonDataForReply(replyToId: replyToId)
        return request
    }
    
    private func makePostReviewRequest(token: String, movie: Movie) -> URLRequest {
        let url = URL(string: PnutURLComponents.movieClubChannel.addingURLComponent(component: PnutURLComponents.includeMessageRaw, first: true))!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(applicationJson, forHTTPHeaderField: contentType)
        request.addValue("\(bearer) \(token)", forHTTPHeaderField: authorization)
        request.httpBody = movie.jsonDataForReview()
        return request
    }
    
    private func makeDeleteMessageRequest(token: String, messageId: String) -> URLRequest {
        let url = URL(string: "\(PnutURLComponents.movieClubChannel)/\(messageId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("\(bearer) \(token)", forHTTPHeaderField: authorization)
        return request
    }
    
    func makeGetThreadRequest(token: String, messageId: String, sinceId: String? = nil, beforeId: String? = nil) -> URLRequest {
        return makeGetRequestForPnut(token: token, component: "/\(messageId)/thread", sinceId: sinceId, beforeId: beforeId, count: 50)
    }
    
    private func parseMessages(data: Data, d: [[String: Any]]) throws -> PnutChannelResult {
        let decoder = JSONDecoder()
        var result = try decoder.decode(PnutChannelResult.self, from: data)
        for (index, js) in d.enumerated() {
            if let raw = js["raw"] as? [[String: Any]] {
                var ph: [PnutRawOembedPhoto] = []
                var rv: [PnutRawOembedReview] = []
                for r in raw {
                    if let type = r["type"] as? String {
                        if type == "io.pnut.core.oembed", let value = r["value"] as? [String: Any] {
                            let e = try JSONSerialization.data(withJSONObject: value, options: [])
                            let p = try decoder.decode(PnutRawOembedPhoto.self, from: e)
                            ph.append(p)
                        } else if type == "io.aya.movie.review", let value = r["value"] as? [String: Any] {
                            let e = try JSONSerialization.data(withJSONObject: value, options: [])
                            let rev = try decoder.decode(PnutRawOembedReview.self, from: e)
                            rv.append(rev)
                        }
                    }
                }
                result.data?[index].photos = ph
                result.data?[index].reviews = rv
            }
        }
        return result
    }
    
    func getUserTokenObject(token: String, completion: @escaping (MNTokenResult)->()) {
        let task = URLSession.shared.dataTask(with: makeUserTokenObjectRequest(token: token)) { data, response, error in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(PnutTokenResult.self, from: data)
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
    
    func getMessages(token: String, sinceId: String? = nil, beforeId: String? = nil, count: Int = 20, completion: @escaping (MNChannelResult)->()) {
        let task = URLSession.shared.dataTask(with: makeMessagesRequest(token: token, sinceId: sinceId, beforeId: beforeId, count: count)) { data, response, error in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let obj = json as? [String: Any], let d = obj["data"] as? [[String: Any]] else {
                        completion(.failure(.json(message: "invalid format")))
                        return
                    }
                    let result = try self.parseMessages(data: data, d: d)
                    if let _ = sinceId {
                        completion(.success(PnutChannelResultQueued(result: result, order: .since)))
                    } else if let _ = beforeId {
                        completion(.success(PnutChannelResultQueued(result: result, order: .before)))
                    } else {
                        completion(.success(PnutChannelResultQueued(result: result, order: .replace)))
                    }
                } catch let error {
                    completion(.failure(.network(message: error.localizedDescription)))
                }
            } else {
                completion(.failure(.data(message: "no data")))
            }
        }
        task.resume()
    }
    
    func postMessage(token: String, content: String, completion: @escaping (MNPostedResult)->()) {
        let task = URLSession.shared.dataTask(with: makePostMessageRequest(token: token, content: content)) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let r = try JSONDecoder().decode(PnutPostedMessageResult.self, from: data)
                    completion(.success(r))
                } catch let error {
                    completion(.failure(.network(message: error.localizedDescription)))
                }
            } else {
                completion(.failure(.data(message: "no data")))
            }
        }
        task.resume()
    }
    
    func postReply(token: String, content: String, replyToId: String, completion: @escaping (MNPostedResult)->()) {
        let task = URLSession.shared.dataTask(with: makePostReplyRequest(token: token, content: content, replyToId: replyToId)) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let r = try JSONDecoder().decode(PnutPostedMessageResult.self, from: data)
                    completion(.success(r))
                } catch let error {
                    completion(.failure(.network(message: error.localizedDescription)))
                }
            } else {
                completion(.failure(.data(message: "no data")))
            }
        }
        task.resume()
    }
    
    func postReview(token: String, movie: Movie, completion: @escaping (MNPostedResult)->()) {
        let task = URLSession.shared.dataTask(with: makePostReviewRequest(token: token, movie: movie)) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let r = try JSONDecoder().decode(PnutPostedMessageResult.self, from: data)
                    completion(.success(r))
                } catch let error {
                    completion(.failure(.network(message: error.localizedDescription)))
                }
            } else {
                completion(.failure(.data(message: "no data")))
            }
        }
        task.resume()
    }
    
    func deleteMessage(token: String, messageId: String, completion: @escaping (MNPostedResult)->()) {
        let task = URLSession.shared.dataTask(with: makeDeleteMessageRequest(token: token, messageId: messageId)) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let r = try JSONDecoder().decode(PnutPostedMessageResult.self, from: data)
                    completion(.success(r))
                } catch let error {
                    completion(.failure(.network(message: error.localizedDescription)))
                }
            } else {
                completion(.failure(.data(message: "no data")))
            }
        }
        task.resume()
    }
    
    func getThreadMessages(token: String, threadId: String, sinceId: String? = nil, beforeId: String? = nil, completion: @escaping (MNChannelResult)->()) {
        let task = URLSession.shared.dataTask(with: makeGetThreadRequest(token: token, messageId: threadId, sinceId: sinceId, beforeId: beforeId)) { data, response, error in
            if let error = error {
                completion(.failure(.network(message: error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let obj = json as? [String: Any], let d = obj["data"] as? [[String: Any]] else {
                        completion(.failure(.json(message: "invalid format")))
                        return
                    }
                    let result = try self.parseMessages(data: data, d: d)
                    if let _ = sinceId {
                        completion(.success(PnutChannelResultQueued(result: result, order: .since)))
                    } else if let _ = beforeId {
                        completion(.success(PnutChannelResultQueued(result: result, order: .before)))
                    } else {
                        completion(.success(PnutChannelResultQueued(result: result, order: .replace)))
                    }
                } catch let error {
                    completion(.failure(.network(message: error.localizedDescription)))
                }
            } else {
                completion(.failure(.data(message: "no data")))
            }
        }
        task.resume()
    }
}
