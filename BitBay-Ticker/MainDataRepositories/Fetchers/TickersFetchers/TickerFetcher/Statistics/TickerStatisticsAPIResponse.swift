struct TickerStatisticsAPIResponse: Decodable {
    
    let status: String?
    let stats: StatisticsAPIResponse?
    
    struct StatisticsAPIResponse: Codable {
        let m: String? // NOTE: What is this "m"?
        let h: String?
        let l: String?
        let v: String?
        let r24h: String?
    }
    
}

