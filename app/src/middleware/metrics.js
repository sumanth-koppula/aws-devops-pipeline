const client = require('prom-client');

const register = new client.Registry();
client.collectDefaultMetrics({ register, prefix: 'p9_node_' });

// Custom: HTTP request duration histogram
const httpDuration = new client.Histogram({
  name: 'p9_http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.01, 0.05, 0.1, 0.3, 0.5, 1, 2, 5],
  registers: [register]
});

// Custom: Request counter
const httpRequests = new client.Counter({
  name: 'p9_http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
  registers: [register]
});

// Middleware that instruments every request
const metricsMiddleware = (req, res, next) => {
  const end = httpDuration.startTimer();
  res.on('finish', () => {
    const labels = {
      method:      req.method,
      route:       req.route ? req.route.path : req.path,
      status_code: res.statusCode
    };
    end(labels);
    httpRequests.inc(labels);
  });
  next();
};

module.exports = { metricsMiddleware, register };