const http = require('http');
const port = process.env.PORT;

const MESSAGE = process.env.MESSAGE || 'Hello World';

const server = http.createServer((req, res) => {
  console.info(`Server received request: ${req.url}`);

  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end(MESSAGE);
})

server.listen(port, () => {
  console.log(`Server is running on PORT: ${port}`);
})
