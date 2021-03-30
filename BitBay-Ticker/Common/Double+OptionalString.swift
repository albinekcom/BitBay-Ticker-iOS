extension Double {
    
    init?(_ optionalString: String?) {
        guard let unwrappedString = optionalString else { return nil }
        
        self.init(unwrappedString)
    }
    
}
