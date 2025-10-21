Manuel.import express from 'express';
const app = express();
const PORT = process.env.PORT || 4001;

app.get('/', (req, res) => {
  res.json({ message: 'Hello from Hamlet Backend!' });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
