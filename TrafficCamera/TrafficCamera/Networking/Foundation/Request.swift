
import Foundation

protocol URLRequestConvertible {
    func expressAsURLRequest() throws -> URLRequest
}

protocol Request: URLRequestConvertible {
    var url: URL { get }
    
    var endPoint: String { get }
}

///Just informing that request will be parameterized
protocol ParameteredRequest: Request {
    func parameter() -> [String: String]
    func build(usingBuilder builder: RequestBuilder) throws -> URLRequest
}

extension ParameteredRequest {
    func build(usingBuilder builder: RequestBuilder = NetworkRequestBuilder()) throws -> URLRequest {
        return try builder.buildURLRequest(withURL: self.url, andParameters: self.parameter())
    }
    
    func expressAsURLRequest() throws -> URLRequest {
        return try self.build()
    }

    func parameter() -> [String : String] {
        return [:]
    }
    
}

protocol DataRequest: Request {
    associatedtype Response: Decodable
    func execute(onNetwork network: NetworkSession, then completion: @escaping ((Result<Response, Error>) -> Void))
    
}

extension DataRequest {
    func execute(onNetwork network: NetworkSession, then completion: @escaping ((Result<Response, Error>) -> Void)) {
        
        network.call(self) { result in
            
            switch result {
            case .success( let data):
                do {
                    let result = try parse(toType: Response.self, data: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(NetworkErrors.ParsingError.unableToParse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
