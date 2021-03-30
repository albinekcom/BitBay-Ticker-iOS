struct TickerDetailsRowData: Identifiable {
    
    let id: String
    let title: String
    let value: String
    
    init(title: String, value: String) {
        id = title
        self.title = title
        self.value = value
    }
    
    init(title: String, doubleValue: Double?) {
        let valueString: String
        
        if let value = doubleValue {
            valueString = String(value)
        } else {
            valueString = "-"
        }
        
        self.init(title: title, value: valueString)
    }
}
