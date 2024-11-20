// Main backend entry point

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const routes = require('./routes'); // Import API routes

const app = express();

app.use(cors());
app.use(bodyParser.json());

// Set up routes
app.get('/', (req, res) => {
    res.send('Welcome to our DS Project')
  })
app.use('/api', routes);

const PORT = 8000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));
