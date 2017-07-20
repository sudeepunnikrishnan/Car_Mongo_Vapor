import Vapor

extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }
        
        post("car") { req in
            guard let updatedTitle = req.data["name"]?.string,
                let miles = req.data["miles_driven"]?.int,
                let updatedDesc = req.data["color"]?.string else {
                    throw Abort.badRequest
            }
            let car = Car(name: updatedTitle,color: updatedDesc,milesDriven: miles)
            try car.save()
            return try JSON(node: ["Success": "Car Added"])
        }
        
        get("carDetails", String.parameter) { req in
            let carId = try req.parameters.next(String.self)
            guard let car = try Car.find(carId) else {
                throw Abort.notFound
            }
            return try car.makeJSON()
        }
      
        get("fullcarList") { req in
            let cars = try Car.all()
            let nodeDictionary = ["cars": cars]
            return try JSON(node: nodeDictionary)
        }
        
        post("delete", String.parameter) { req in
            
            let carId = try req.parameters.next(String.self)
            guard let car = try Car.find(carId) else {
                throw Abort.notFound
            }
            
            try car.delete()
            return try JSON(node: ["Success": "Car Entry deleted"])
            
        }
        
        post("carUpdate", String.parameter) { req in
            let carId = try req.parameters.next(String.self)
            guard let car = try Car.find(carId),
                let updatedTitle = req.data["name"]?.string,
                let miles = req.data["milesDriven"]?.int,
                let updatedDesc = req.data["color"]?.string else {
                    throw Abort.badRequest
            }
            
            car.name = updatedTitle
            car.color = updatedDesc
            car.milesDriven = miles
            
            try car.save()
            return try car.makeJSON()
        }

        
        try resource("posts", PostController.self)
    }
}
