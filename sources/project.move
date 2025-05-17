module HelloMessage::EHR {
    use std::string::String;
    use aptos_framework::signer;
    
    struct Record has key {
        data: String
    }
    
    public entry fun create(doctor: &signer, data: String) {
        move_to(doctor, Record { data });
    }
    
    public entry fun update(doctor: &signer, data: String) acquires Record {
        let addr = signer::address_of(doctor);
        if (exists<Record>(addr)) {
            let record = borrow_global_mut<Record>(addr);
            record.data = data;
        }
    }
}