// Main backend entry point

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const routes = require('./routes/index');

const app = express();

app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => {
    res.send('Welcome to our DS Project')
  })

app.use('/api', routes);


const PORT = 8000;
app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));


module.exports = app;