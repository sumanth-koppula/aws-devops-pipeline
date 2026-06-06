const express = require('express');
const router  = express.Router();

router.get('/info', (_req, res) => {
  res.json({
    name:    'P9 DevOps Demo API',
    version: process.env.APP_VERSION || '1.0.0',
    host:    process.env.HOSTNAME     || 'unknown'
  });
});

router.get('/env', (_req, res) => {
  res.json({
    environment: process.env.NODE_ENV  || 'development',
    region:      process.env.AWS_REGION || 'us-east-1'
  });
});

module.exports = router;