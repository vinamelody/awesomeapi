import Vapor
import Fluent

struct TalksController: RouteCollection {
    func boot(router: Router) throws {
        let route = router.grouped("api", "talks")
        route.get(use: getAllHandler)
        route.get(Talk.parameter, use: getHandler)
        route.post(Talk.parameter, use: createHandler)
        route.post(Talk.parameter, use: updateHandler)
        route.delete(Talk.parameter, use: deleteHandler)
        route.get("luke", use: getLuke)
    }
    
    func getLuke(_ req: Request) throws -> Future<String> {
        let hostname = "swapi.co"
//        let url = URL(string: "https://" + hostname + "/api/people/1")!
        let url = URL(string: "/api/people/1")!
        let ppl: Future<String> = HTTPClient.connect(hostname: hostname, on: req).flatMap(to: String.self) { (client) in
            var header = HTTPHeaders()
            header.add(name: HTTPHeaderName.contentType, value: "application/json")
            header.add(name: HTTPHeaderName.acceptEncoding, value: "gzip, deflate")
            let httpReq = HTTPRequest(method: .GET, url: url, headers: header)
            return client.send(httpReq).map { res in
                return res.description
            }
        }
        return ppl
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Talk]> {
        return Talk.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Talk> {
        return try req.parameters.next(Talk.self)
    }
    
    func createHandler(_ req: Request) throws -> Future<Talk> {
        return try req.content.decode(TalkCreateData.self).flatMap(to: Talk.self, { (talkData) in
            let talk = Talk(title: talkData.title, type: talkData.type, sequence: talkData.sequence, startTime: talkData.startTime, endTime: talkData.endTime)
            return talk.save(on: req)
        })
    }
    
    func updateHandler(_ req: Request) throws -> Future<Talk> {
        return try flatMap(to: Talk.self, req.parameters.next(Talk.self), req.content.decode(TalkCreateData.self), { (talk, newTalk) in
            talk.type = newTalk.type
            talk.title = newTalk.title
            talk.sequence = newTalk.sequence
            talk.startTime = newTalk.startTime
            talk.endTime = newTalk.endTime
            return talk.save(on: req)
        })
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Talk.self).flatMap(to: HTTPStatus.self, { (talk) in
            return talk.delete(on: req).transform(to: HTTPStatus.ok)
        })
    }
    
    
    
    
}

struct TalkCreateData: Content {
    let title: String
    let type: String
    let sequence: Int
    let startTime: String
    let endTime: String
}

