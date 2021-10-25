import UIKit

enum VehiclesAllowed: String {
    case car
    case motocycles
    case minibus
    case bus
}

enum Rates: Int {
    case car = 20
    case motocycles = 15
    case minibus = 25
    case bus = 30
}

protocol Parkable {
    var plate: String { get }
}

struct Parking {
    // There cannot be 2 equal cars because the sets do not accept repeated values
    var vehicles: Set<Vehicle> = []
    
    func getPrice(vehicleType: VehiclesAllowed) -> Int {
        var price: Int = 0
        switch vehicleType {
        case .car:
            price = Rates.car.rawValue
        case .motocycles:
            price = Rates.motocycles.rawValue
        case  .minibus:
            price = Rates.minibus.rawValue
        case .bus:
            price = Rates.bus.rawValue
        }
        return price
    }
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

var parking = Parking()
parking.getPrice(vehicleType: .car)
