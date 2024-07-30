const express = require('express');
const ethers = require('ethers');

const app = express();
const port = 3001;

const rpcUrl = 'http://127.0.0.1:8545';
const contractAddress = '0x33742a719FE3120FDd4AD24B8f288902Dfd39583';
const abi =  [
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "organName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "bloodType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "tissueType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "HLAantigen",
				"type": "string"
			}
		],
		"name": "addOrgan",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "patientAddress",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "age",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "gender",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "bloodType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "tissueType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "HLAantigen",
				"type": "string"
			}
		],
		"name": "addPatient",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "organName",
				"type": "string"
			}
		],
		"name": "matchOrgans",
		"outputs": [
			{
				"internalType": "uint256[]",
				"name": "",
				"type": "uint256[]"
			},
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "organIdCounter",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "organList",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "organs",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "organId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "bloodType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "tissueType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "HLAantigen",
				"type": "string"
			},
			{
				"internalType": "bool",
				"name": "available",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "patients",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "age",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "gender",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "bloodType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "tissueType",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "HLAantigen",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "sayHello",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	}
] ;

const provider = new ethers.JsonRpcProvider(rpcUrl);
const signer = new ethers.Wallet('33313afb6ecaf0ab84d724ea5639893b9000b0ac3dc3321c63fff6508d14be94', provider);
const contract = new ethers.Contract(contractAddress, abi, signer);

app.use(express.json());

//write for hi function
app.get('/sayHello', async (req, res) => {
    try {
        const result = await contract.sayHello();
        res.send({ message: result });
    } catch (error) {
        console.error('Error calling sayHello function:', error);
        res.status(500).send({ error: 'Failed to call sayHello function' });
    }
}); 
app.post('/addPatient', (req, res) => {
    return new Promise(async (resolve, reject) => {
        const { patientAddress, name, gender, age, bloodtype, tissueType, HLAantigen } = req.body;

        try {
            const tx = await contract.addPatient(patientAddress, age, name, gender, bloodtype, tissueType, HLAantigen);
            await tx.wait();

            resolve({ status: 'Patient added successfully', transactionHash: tx.hash });
        } catch (error) {
            console.error('Error adding patient:', error);
            reject({ error: 'Failed to add patient' });
        }
    }).then((result) => {
        res.send(result);
    }).catch((error) => {
        res.status(500).send(error);
    });
});



app.get('/getDiagnoses/:patientAddress', async (req, res) => {
    const { patientAddress } = req.params;

    try {
        const diagnoses = await contract.getDiagnoses(patientAddress);
        res.send({ diagnoses });
    } catch (error) {
        console.error('Error getting diagnoses:', error);
        res.status(500).send({ error: 'Failed to get diagnoses' });
    }
});

app.get('/getPatientName/:patientAddress', async (req, res) => {
    const { patientAddress } = req.params;

    try {
        const patientName = await contract.getPatientName(patientAddress);
        res.send({ patientName });
    } catch (error) {
        console.error('Error getting patient name:', error);
        res.status(500).send({ error: 'Failed to get patient ' });
    }
});

app.get('/testFunction', async (req, res) => {
    try {
        const result = await contract.testFunction();
        res.send({ result });
    } catch (error) {
        console.error('Error testing function:', error);
        res.status(500).send({ error: 'Failed to test function' });
    }
});

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});name
