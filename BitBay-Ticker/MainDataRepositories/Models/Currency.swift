struct Currency: Codable, Hashable {
    
    let code: String
    let name: String?
    let minimumOffer: Double?
    let scale: Int?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
    
}
