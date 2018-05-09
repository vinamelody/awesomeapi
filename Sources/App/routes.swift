import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        
//        let hostname = "swapi.co/api/people/1/"
//        let client = try HTTPClient.connect(hostname: hostname, on: req)
        
        return "Hello, world!"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let param = try req.parameters.next(String.self)
        return "Hello, \(param.capitalized)!"
    }
    
    router.get("hello", String.parameter, Int.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        let random = try req.parameters.next(Int.self)
        return "Hello, \(name.capitalized), how about \(random)!"
    }
    
    router.get("hello", String.parameter, Int.parameter, String.parameter) { req -> String in
        let first = try req.parameters.next(String.self)
        let second = try req.parameters.next(Int.self)
        let third = try req.parameters.next(String.self)
        return "Hello, \(first), \(second), \(third)!"
    }
    
    router.get("talks") { req -> TalkContentData in
        let talk = TalkContentData(title: "Codeable in Swift 4",
                                   type: "talk",
                                   sequence: 5,
                                   startTime: "3:00",
                                   endTime: "3:30")
        return talk
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    let talksController = TalksController()
    try router.register(collection: talksController)
}

struct TalkContentData: Content {
    let title: String
    let type: String
    let sequence: Int
    let startTime: String
    let endTime: String
}
