# Decentralized Electronic Health Record (EHR) System

A blockchain-based healthcare record management system built on the Aptos blockchain. This system enables secure, transparent, and patient-controlled electronic health records.

## Overview

This project implements a decentralized EHR system that allows:
- Doctors to create and update patient health records
- Secure storage of encrypted patient data on-chain
- Access control for patient data through permissions

The system is built on the Aptos blockchain, leveraging its secure and high-performance architecture.

## Components

### 1. Smart Contract

The core of the system is a Move smart contract (`HealthSystem::EHR`) that manages health records. It provides:

- Creation of new patient records
- Secure updating of existing records
- Access control mechanisms

### 2. Web Interface

The project includes a full-stack web application that allows users to:
- Connect their Aptos wallet
- Create and update health records
- View accessible health records
- Manage permissions

## Getting Started

### Prerequisites

- [Aptos CLI](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli/)
- [Node.js](https://nodejs.org/) (for hosting the web interface)
- [Petra Wallet](https://petra.app/) or another Aptos-compatible wallet

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/decentralized-ehr-aptos.git
cd decentralized-ehr-aptos
```

2. Deploy the smart contract:
```bash
aptos move publish --max-gas 100000000 --gas-unit-price 100
```

3. Host the web interface:
```bash
# If you have a simple HTTP server installed
python -m http.server 8080
# Or using Node.js
npx serve
```

4. Open the web interface in your browser at `http://localhost:8080`

## Smart Contract Details

### Contract Structure

The EHR contract provides a minimal implementation for health record management:

```move
module HealthSystem::EHR {
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
```

### Enhanced Version

For a more feature-complete implementation, the repository also includes an enhanced version with:
- Patient-specific record storage
- Access control mechanisms
- Timestamps for audit trails

```move
module HealthSystem::EnhancedEHR {
    use std::string::String;
    use std::vector;
    use aptos_framework::signer;
    use aptos_framework::timestamp;
    
    struct Record has key {
        patient: address,
        data: String,
        doctor: address,
        updated: u64,
        access: vector<address>
    }
    
    // Functions for creation, updates, and access management...
}
```

## Web Interface

The web interface provides a user-friendly way to interact with the EHR system. Key features include:

- Wallet connection with Petra or other Aptos wallets
- Record creation interface
- Record updating functionality
- Patient record viewing with proper access controls
- Client-side encryption for added security

## Security Considerations

- Health data is encrypted before being stored on-chain
- Access controls are implemented at the smart contract level
- Patient consent is required for record creation and access
- No sensitive data is stored in plaintext on-chain


3. Ensure your account has sufficient APT tokens for gas fees

## Future Enhancements

- Multi-signature requirements for critical health data
- Tiered access controls for different healthcare providers
- Integration with decentralized identity solutions
- Analytics dashboard for patients to monitor record access
- Support for different record types (images, lab results, etc.)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Aptos Labs for providing the blockchain infrastructure
- The Move language team for creating a secure smart contract language