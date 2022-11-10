import Foundation

public struct SaunaSet {
    public static var empty: Self { .init(sauna: .empty, coolBath: .empty, relaxation: .empty) }
    
    public var sauna: Sauna
    public var coolBath: CoolBath
    public var relaxation: Relaxation
    
    public init(sauna: Sauna, coolBath: CoolBath, relaxation: Relaxation) {
        self.sauna = sauna
        self.coolBath = coolBath
        self.relaxation = relaxation
    }
    
    public struct Sauna {
        static var empty: Self { .init(time: nil) }
        
        public var time: TimeInterval?
        
        public init(time: TimeInterval?) {
            self.time = time
        }
    }
    
    public struct CoolBath {
        static var empty: Self { .init(time: nil) }
        
        public var time: TimeInterval?
        
        public init(time: TimeInterval?) {
            self.time = time
        }
    }
    
    public struct Relaxation {
        public enum RelaxationPlace {
            case outdoorAirBath
            case indoorAirBath
            case other
        }
        
        static var empty: Self { .init(time: nil, place: nil, way: nil) }
        
        public var time: TimeInterval?
        public var place: RelaxationPlace?
        public var way: String?
        
        public init(time: TimeInterval?, place: RelaxationPlace?, way: String?) {
            self.time = time
            self.place = place
            self.way = way
        }
    }
}

extension SaunaSet: Identifiable {
    public var id: UUID { UUID() }
}

// For save UserDefaults
extension SaunaSet: Codable {}
extension SaunaSet.Sauna: Codable {}
extension SaunaSet.CoolBath: Codable {}
extension SaunaSet.Relaxation: Codable {}
extension SaunaSet.Relaxation.RelaxationPlace: Codable {}

#if DEBUG
extension SaunaSet {
    public static var preview: Self {
        .init(
            sauna: .init(time: 5 * 60),
            coolBath: .init(time: 30),
            relaxation: .init(
                time: 10 * 60,
                place: .outdoorAirBath,
                way: "インフィニティチェア"
            )
        )
    }
}
#endif
