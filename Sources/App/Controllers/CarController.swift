import Vapor
import JSON
import HTTP
final class CarController: ResourceRepresentable {
    
    //Adding our session container object
    var cars: [Car] = []
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        //Update method to return the container object instead of the static object
        return try JSON(node: cars)
    }
    //This is where the 'post' request gets redirected to
    func create(request: Request) throws -> ResponseRepresentable {
        
        //Guard statement to make sure we are validating the data correct (we of course should also later guard for the color etc)
        guard let name = request.data["name"]?.string else {
            //Throw a Abort response, I like using the custom status to make sure the frontends have the correct message and response code
            throw Abort.init(Status.preconditionFailed)
        }
        
        //Create a car
        let car = Car(name: name, color: "Red", milesDriven: 0)
        //Add it to our container object
        cars.append(car)
        //Return the newly created car
        return try car//.converted(to: JSON.self)
    }
    
    //Add the store: create to tell Vapor that if a 'post' http requst comes in to redirect it there.
    func makeResource() -> Resource<Car> {
        return Resource(
            index: index,
            store: create
        )
    }
}
