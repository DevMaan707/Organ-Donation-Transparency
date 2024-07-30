// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PatientData {
    struct Diagnosis {
        string diagnosisid;
        string patientid;
        uint date;
        string doctorid;
        string description;
        string symptoms;
        string tests;
        string severity;
        string treatment;
        string medications;
        bool needOrgan;
    }

    struct Journals {
        string hospitalName;
        uint256 date;
        string reason;
        string tests;
        string medications;
        string testResults;
        string diagnosisid;
        string patientid;
    }

    struct Patient {
        string name;
        Diagnosis[] diagnosis;
        Journals[] journal;
        bool exists;
        string gender;
        uint age;
        string bloodtype;
        string HLAantigen;
    }

    struct Organ {
        string organName;
        string bloodType;
        string organId;
        string HLAagent;
        string tissueType;
        bool registered;
        address patientAddress; 
    }

    mapping(address => Patient) private patients;
    address[] private patientAddresses;
    Organ[] private organs;

  
    mapping(string => address[]) private organDonationList;

    
    event PatientAdded(address indexed patientAddress, string name);
    event DiagnosisUpdated(address indexed patientAddress, string diagnosisid);
    event JournalEntryAdded(address indexed patientAddress, string hospitalName, uint256 date);
    event OrganMatched(string organId, address patientAddress);

    modifier patientExists(address _patientAddress) {
        require(patients[_patientAddress].exists, "Patient does not exist.");
        _;
    }

     function testFunction() public pure returns (string memory) {
        return "it works";
    }

    function addPatient(
        address _patientAddress,
        string memory _name,
        string memory _gender,
        uint _age,
        string memory _bloodtype,
        string memory _HLAantigen
    ) public {
        require(!patients[_patientAddress].exists, "Patient already exists.");

        patients[_patientAddress] = Patient({
            name: _name,
            diagnosis: new Diagnosis[](0),
            journal: new Journals[](0) ,
            exists: true,
            gender: _gender,
            age: _age,
            bloodtype: _bloodtype,
            HLAantigen: _HLAantigen
        });

        patientAddresses.push(_patientAddress);

        emit PatientAdded(_patientAddress, _name);
    }

    function addDiagnosis(
        address _patientAddress,
        string memory _diagnosisid,
        uint _date,
        string memory _doctorid,
        string memory _description,
        string memory _symptoms,
        string memory _tests,
        string memory _severity,
        string memory _treatment,
        string memory _medications,
        bool _needOrgan
    ) public patientExists(_patientAddress) {
        patients[_patientAddress].diagnosis.push(Diagnosis({
            diagnosisid: _diagnosisid,
            patientid: string(abi.encodePacked(_patientAddress)),
            date: _date,
            doctorid: _doctorid,
            description: _description,
            symptoms: _symptoms,
            tests: _tests,
            severity: _severity,
            treatment: _treatment,
            medications: _medications,
            needOrgan: _needOrgan
        }));

        emit DiagnosisUpdated(_patientAddress, _diagnosisid);
    }

    function addJournalEntry(
        address _patientAddress,
        string memory _hospitalName,
        uint256 _date,
        string memory _reason,
        string memory _tests,
        string memory _medications,
        string memory _testResults,
        string memory _diagnosisid,
        string memory _patientid
    ) public patientExists(_patientAddress) {
        patients[_patientAddress].journal.push(Journals({
            hospitalName: _hospitalName,
            date: _date,
            reason: _reason,
            tests: _tests,
            medications: _medications,
            testResults: _testResults,
            diagnosisid: _diagnosisid,
            patientid: _patientid
        }));

        emit JournalEntryAdded(_patientAddress, _hospitalName, _date);
    }

    function addOrgan(
        string memory _organName,
        string memory _bloodType,
        string memory _organId,
        string memory _HLAagent,
        string memory _tissueType
    ) public {
        organs.push(Organ({
            organName: _organName,
            bloodType: _bloodType,
            organId: _organId,
            HLAagent: _HLAagent,
            tissueType: _tissueType,
            registered: false,
            patientAddress: address(0) 
        }));
    }

    function matchOrganToPatient(
        address _patientAddress,
      
        string memory _organName
    ) public patientExists(_patientAddress) returns (string memory organId, address patientAddr) {
        Patient storage patient = patients[_patientAddress];
        bool organMatched = false;

        for (uint i = 0; i < organs.length; i++) {
            
            if (keccak256(abi.encodePacked(organs[i].organName)) == keccak256(abi.encodePacked(_organName)) && !organs[i].registered) {
                organDonationList[_organName].push(_patientAddress);
                if (
                    keccak256(abi.encodePacked(organs[i].bloodType)) == keccak256(abi.encodePacked(patient.bloodtype)) &&
                    keccak256(abi.encodePacked(organs[i].tissueType)) == keccak256(abi.encodePacked(patient.diagnosis[0].severity)) && 
                    keccak256(abi.encodePacked(organs[i].HLAagent)) == keccak256(abi.encodePacked(patient.HLAantigen))
                ) {
                    organs[i].registered = true;
                    organs[i].patientAddress = _patientAddress; 
                    organMatched = true;
                    emit OrganMatched(organs[i].organId, _patientAddress);
                    return (organs[i].organId, _patientAddress);
                }
            }
        }

        require(organMatched, "No matching organ found");
    }

    function getDiagnoses(address _patientAddress) public view patientExists(_patientAddress) returns (Diagnosis[] memory) {
        return patients[_patientAddress].diagnosis;
    }

    function getJournalEntries(address _patientAddress) public view patientExists(_patientAddress) returns (Journals[] memory) {
        return patients[_patientAddress].journal;
    }

    function getAllPatients() public view returns (address[] memory) {
        return patientAddresses;
    }

    function getOrganDonationList(string memory _organName) public view returns (address[] memory) {
        return organDonationList[_organName];
    }
}
