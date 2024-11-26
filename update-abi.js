// When contracts are modified or recompiled, their ABIs (stored in artifacts/contracts/Lock.json) should automatically propagate to the 
// backend (voting-system-backend/contracts) and frontend (voting-system-frontend/src/services).

const fs = require('fs');
const path = require('path');

const artifactsDir = path.join(__dirname, 'artifacts/contracts');
const backendContractsDir = path.join(__dirname, 'voting-system-backend/contracts');
const frontendServicesDir = path.join(__dirname, 'voting-system-frontend/src/services');

// Helper: Copy ABI from source to destination
function copyABI(contractName) {
    const sourcePath = path.join(artifactsDir, contractName, `${contractName}.json`);
    const backendDestPath = path.join(backendContractsDir, `${contractName}.json`);
    const frontendDestPath = path.join(frontendServicesDir, `${contractName}.json`);

    if (fs.existsSync(sourcePath)) {
        const abiData = JSON.parse(fs.readFileSync(sourcePath, 'utf8')).abi;
        fs.writeFileSync(backendDestPath, JSON.stringify(abiData, null, 2));
        console.log(`✅ ABI updated in backend for ${contractName}`);
        fs.writeFileSync(frontendDestPath, JSON.stringify(abiData, null, 2));
        console.log(`✅ ABI updated in frontend for ${contractName}`);
    } else {
        console.error(`❌ ABI not found for contract: ${contractName}`);
    }
}

function updateABIs() {
    const contracts = fs.readdirSync(artifactsDir);
    contracts.forEach((contract) => {
        const contractName = contract.split('.')[0]; 
        if (contractName) {
            copyABI(contractName);
        }
    });
}

updateABIs();
