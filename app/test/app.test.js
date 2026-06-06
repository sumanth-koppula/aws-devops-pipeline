const request = require('supertest');
const { app, server } = require('../src/index');

afterAll(() => server.close());

describe('Health Routes', () => {
  test('GET /health → 200', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('ok');
  });

  test('GET /health/live → 200', async () => {
    const res = await request(app).get('/health/live');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('alive');
  });

  test('GET /health/ready → 200', async () => {
    const res = await request(app).get('/health/ready');
    expect(res.statusCode).toBe(200);
  });
});

describe('API Routes', () => {
  test('GET /api/info → 200', async () => {
    const res = await request(app).get('/api/info');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('name');
  });
});

describe('Metrics Route', () => {
  test('GET /metrics → prometheus text format', async () => {
    const res = await request(app).get('/metrics');
    expect(res.statusCode).toBe(200);
    expect(res.text).toContain('p9_http_requests_total');
  });
});