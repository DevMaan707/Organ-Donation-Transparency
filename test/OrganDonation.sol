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

    mapping(address => Patient) private patients;
    address[] private patientAddresses;

    // Events
    event PatientAdded(address indexed patientAddress, string name);
    event DiagnosisUpdated(address indexed patientAddress, string diagnosisid);
    event JournalEntryAdded(address indexed patientAddress, string hospitalName, uint256 date);

    modifier patientExists(address _patientAddress) {
        require(patients[_patientAddress].exists, "Patient does not exist.");
        _;
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
            diagnosis: new Diagnosis[](0) ,
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

    function getDiagnoses(address _patientAddress) public view patientExists(_patientAddress) returns (Diagnosis[] memory) {
        return patients[_patientAddress].diagnosis;
    }

    function getJournalEntries(address _patientAddress) public view patientExists(_patientAddress) returns (Journals[] memory) {
        return patients[_patientAddress].journal;
    }

    function getAllPatients() public view returns (address[] memory) {
        return patientAddresses;
    }
}
