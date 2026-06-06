require('dotenv').config();
const express = require('express');
const client  = require('prom-client');
const winston = require('winston');

const healthRouter  = require('./routes/health');
const apiRouter     = require('./routes/api');
const { metricsMiddleware, register } = require('./middleware/metrics');

// ── Logger ──────────────────────────────────────────────────────────
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [new winston.transports.Console()]
});

// ── App ──────────────────────────────────────────────────────────────
const app  = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(metricsMiddleware);

app.use('/health', healthRouter);
app.use('/api',    apiRouter);

// Prometheus scrape endpoint
app.get('/metrics', async (_req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

// Global error handler
app.use((err, _req, res, _next) => {
  logger.error({ message: err.message, stack: err.stack });
  res.status(500).json({ error: 'Internal Server Error' });
});

const server = app.listen(PORT, () => {
  logger.info(`P9 app listening on port ${PORT}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM received — shutting down gracefully');
  server.close(() => process.exit(0));
});

module.exports = { app, server };