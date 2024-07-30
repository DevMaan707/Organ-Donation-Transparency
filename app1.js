const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const port = 4579;
app.use(bodyParser.json());



//defining all web3 stuff
const ethers = require('ethers');
const providers = new ethers.JsonRpcProvider('http:127.0.0.1:8545');
const contractAddress = '';
const {abi} = require('');
const { default: Diagnosis } = require('./routes/Diagnosis');
const { default: Journal } = require('./routes/Journal');


//defining all routes
app.post('/get-diagnosis',Diagnosis(req,res));

app.post('/get-journal',Journal(req,res));

app.post('/store-details',Details(req,res));

//starting server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});
