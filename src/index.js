require('dotenv').config();

const express = require('express');
const { databaseClient } = require('./database');

const app = express();

const { PORT, NODE_ENV } = process.env;

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.listen(PORT, async () => {
  await databaseClient.init();

  console.log(`Listening at http://localhost:${PORT}`);
  console.log(`Running app in ${NODE_ENV} mode`);
});