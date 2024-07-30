// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrganDonation {
    struct Patient {
        uint age;
        string name;
        string gender;
        string bloodType;
        string tissueType;
        string HLAantigen;
    }

    struct Organ {
        uint organId;
        string bloodType;
        string tissueType;
        string HLAantigen;
        bool available;
    }

    mapping(address => Patient) public patients;
    mapping(string => address[]) public organList;
    mapping(uint => Organ) public organs;
    uint public organIdCounter;

    constructor() {
        organIdCounter = 1;
        organs[organIdCounter++] = Organ(organIdCounter, "", "", "", true); // Dummy organ to start organId from 1
    }

    function sayHello() external pure returns (string memory) {
        return "Hey! It works!";
    }

    function addPatient(address patientAddress, uint age, string memory name, string memory gender, string memory bloodType, string memory tissueType, string memory HLAantigen) external {
        patients[patientAddress] = Patient(age, name, gender, bloodType, tissueType, HLAantigen);
    }

    function addOrgan(string memory organName, string memory bloodType, string memory tissueType, string memory HLAantigen) external {
        organList[organName].push(msg.sender);
        organs[organIdCounter++] = Organ(organIdCounter, bloodType, tissueType, HLAantigen, true);
    }

    function matchOrgans(string memory organName) external returns (uint[] memory, address[] memory) {
    address[] storage organOwners = organList[organName];
    uint[] memory matchedOrgans = new uint[](organOwners.length);
    address[] memory matchedPatients = new address[](organOwners.length);
    uint index = 0;

    for (uint i = 0; i < organOwners.length; i++) {
        Patient storage patient = patients[organOwners[i]];
        Organ storage organ = organs[i + 1]; 

        if (compareStrings(patient.bloodType, organ.bloodType) &&
            compareStrings(patient.tissueType, organ.tissueType) &&
            compareStrings(patient.HLAantigen, organ.HLAantigen) &&
            organ.available) {
            matchedOrgans[index] = organ.organId;
            matchedPatients[index] = organOwners[i];
            organ.available = false; 
            index++;
        }
    }

    return (matchedOrgans, matchedPatients);
}

    
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
