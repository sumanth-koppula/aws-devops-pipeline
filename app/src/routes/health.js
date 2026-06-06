const express = require('express');
const router  = express.Router();

// Liveness probe
router.get('/live', (_req, res) => {
  res.status(200).json({ status: 'alive', timestamp: new Date().toISOString() });
});

// Readiness probe (check DB if needed)
router.get('/ready', async (_req, res) => {
  try {
    // In production, verify DB connection here
    res.status(200).json({ status: 'ready', uptime: process.uptime() });
  } catch (err) {
    res.status(503).json({ status: 'not_ready', error: err.message });
  }
});

// Generic health (ALB target group check)
router.get('/', (_req, res) => {
  res.status(200).json({
    status:  'ok',
    version: process.env.APP_VERSION || '1.0.0',
    env:     process.env.NODE_ENV    || 'development'
  });
});

module.exports = router;