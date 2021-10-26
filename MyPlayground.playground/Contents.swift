import UIKit

enum VehicleType: String {
    case car, moto, minibus, bus
}

enum Rates: Int {
    case car = 20
    case motocycles = 15
    case minibus = 25
    case bus = 30
}

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get }
    var parkedTime: Int { get }
}

struct Parking {
    // There cannot be 2 equal cars because the sets do not accept repeated values
    var vehicles: Set<Vehicle> = []
    let maxVehicles = 20
    var currentVehicle: VehicleType?
    var price: Int {
        get {
            var price: Int = 0
            switch currentVehicle {
            case .car:
                price = Rates.car.rawValue
            case .moto:
                price = Rates.motocycles.rawValue
            case  .minibus:
                price = Rates.minibus.rawValue
            case .bus:
                price = Rates.bus.rawValue
            default:
                price = 0
            }
            return price
        }
    }
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish:
    (Bool) -> Void) {
        if vehicles.count < maxVehicles {
            vehicles.insert(vehicle).inserted ? onFinish(true) : onFinish(false)
        } else {
            onFinish(false)
        }
    }
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    let discountCard: String?
    var parkedTime: Int {
        get {
            return Calendar.current.dateComponents([.minute], from:
                                                                    checkInTime, to: Date()).minute ?? 0
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

var alkeParking = Parking()
var registerVehicles: [Vehicle] = [
    Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard:
    "DISCOUNT_CARD_001"),
    Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333CC", type: VehicleType.minibus, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "DD444DD", type:VehicleType.bus, checkInTime: Date(), discountCard:
    "DISCOUNT_CARD_002"),
    Vehicle(plate: "AA111BB", type:
    VehicleType.car, checkInTime: Date(), discountCard:
    "DISCOUNT_CARD_003"),
    Vehicle(plate: "B222CCC", type:
    VehicleType.moto, checkInTime: Date(), discountCard:
      "DISCOUNT_CARD_004"),
    Vehicle(plate: "CC333DD", type:
    VehicleType.minibus, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "DD444EE", type:
    VehicleType.bus, checkInTime: Date(), discountCard:
    "DISCOUNT_CARD_005"),
    Vehicle(plate: "AA111CC", type:
    VehicleType.car, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "B222DDD", type:
    VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333EE", type:
    VehicleType.minibus, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "DD444GG", type:
    VehicleType.bus, checkInTime: Date(), discountCard:
    "DISCOUNT_CARD_006"),
    Vehicle(plate: "AA111DD", type:
    VehicleType.car, checkInTime: Date(), discountCard:
    "DISCOUNT_CARD_007"),
    Vehicle(plate: "AA111DD", type:
    VehicleType.moto, checkInTime: Date(), discountCard: nil),
    Vehicle(plate: "CC333FF", type:
    VehicleType.minibus, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "TT332FG", type:
    VehicleType.car, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "AC123PP", type:
    VehicleType.moto, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "UY999PB", type:
    VehicleType.bus, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "AG432PP", type:
    VehicleType.car, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "AC949PO", type:
    VehicleType.minibus, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "CC987TT", type:
    VehicleType.car, checkInTime: Date(), discountCard:
    nil),
    Vehicle(plate: "PP090CC", type:
    VehicleType.moto, checkInTime: Date(), discountCard:
    nil)
]


for vehicle in registerVehicles {
    alkeParking.checkInVehicle(vehicle, onFinish: {
        insertVehicle in
        if insertVehicle {
            print("Welcome to AlkeParking!")
        } else {
            print("Sorry, the check-in failed")
        }
    })
}




