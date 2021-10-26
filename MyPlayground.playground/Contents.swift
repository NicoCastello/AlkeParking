import UIKit
import Foundation

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
    let fractionOfMinutes = 15
    let fractionValue = 5
    let discount = 15
    var accumulated: (vehicles: Int,profits: Int) = (0,0)
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
    
    func getProfits() {
        let profitMenssage = "\(accumulated.vehicles) vehicles have checked out and have earnings of $\(accumulated.profits)"
        print(profitMenssage)
    }
    
    func listPlate() {
        for vehicle in vehicles {
            print("plate: \(vehicle.plate)")
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
    
    mutating func checkOutVehicle(plate: String, onSuccess: (Int) -> Void, onError: ()-> Void) {
        var bill: Int = 0
        let foundVehicle = vehicles.filter {$0.plate == plate}
        guard let foundVehicle = foundVehicle.first else {
            onError()
            return
        }
        bill = calculateBill(parkedTime: foundVehicle.parkedTime, vehicleType: foundVehicle.type, discountCode: foundVehicle.discountCard)
        accumulated.vehicles += 1
        accumulated.profits += bill
        onSuccess(bill)
        vehicles.remove(foundVehicle)
    }
    
    mutating func calculateBill(parkedTime: Int, vehicleType: VehicleType, discountCode: String?) -> Int {
        currentVehicle = vehicleType
        var billValue: Int = 0
        let hours: Int = Int(parkedTime / 60)
        if parkedTime <= 120 {
            return price
        } else if parkedTime % 60 == 0 {
            billValue = price * hours
        } else {
            let minutesRemaining = parkedTime - hours * 60
            var blocks = minutesRemaining / fractionOfMinutes
            if minutesRemaining % fractionOfMinutes != 0 {
                blocks += 1
            }
            billValue = price * hours + fractionValue * blocks
        }
        
        if let _ = discountCode {
            let discountValue: Int = Int(billValue * discount / 100)
            billValue = billValue - discountValue
        }
        return billValue
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
alkeParking.checkOutVehicle(plate: "AG432PP", onSuccess: { billValue in
    print( "Your fee is $\(billValue). Come back soon")}, onError: { print("Sorry, the check-out failed")})

alkeParking.checkOutVehicle(plate: "AC949PO", onSuccess: { billValue in
    print( "Your fee is $\(billValue). Come back soon")}, onError: { print("Sorry, the check-out failed")})

alkeParking.getProfits()
alkeParking.listPlate()

