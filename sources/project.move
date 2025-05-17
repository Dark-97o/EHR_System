module HelloMessage::EHR {
    use std::string::{Self, String};
    use std::vector;
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    
    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_RECORD_NOT_FOUND: u64 = 2;
    const E_RECORD_EXISTS: u64 = 3;
    
    /// Struct representing a patient's health record
    struct HealthRecord has key, store {
        patient_id: address,
        data: String,        // Encrypted health data
        doctor_address: address,
        last_updated: u64,   // Timestamp of last update
        access_permissions: vector<address>  // Addresses with access permission
    }
    
    /// Function to create a new health record for a patient
    public fun create_health_record(
        doctor: &signer, 
        patient_address: address, 
        data: String
    ) {
        let doctor_address = signer::address_of(doctor);
        
        // Check if record already exists
        assert!(!exists<HealthRecord>(patient_address), E_RECORD_EXISTS);
        
        let record = HealthRecord {
            patient_id: patient_address,
            data: data,
            doctor_address: doctor_address,
            last_updated: timestamp::now_seconds(),
            access_permissions: vector[doctor_address, patient_address]
        };
        
        move_to(doctor, record);
    }
    
    /// Function to check if an address is authorized to access a record
    fun is_authorized(addr: address, record: &HealthRecord): bool {
        vector::contains(&record.access_permissions, &addr)
    }
    
    /// Function to update an existing health record
    public fun update_health_record(
        doctor: &signer,
        patient_address: address,
        new_data: String
    ) acquires HealthRecord {
        let doctor_address = signer::address_of(doctor);
        
        // Check if record exists
        assert!(exists<HealthRecord>(patient_address), E_RECORD_NOT_FOUND);
        
        let record = borrow_global_mut<HealthRecord>(patient_address);
        
        // Verify doctor has permission to update
        assert!(doctor_address == record.doctor_address || is_authorized(doctor_address, record), E_NOT_AUTHORIZED);
        
        // Update the record
        record.data = new_data;
        record.last_updated = timestamp::now_seconds();
    }
}