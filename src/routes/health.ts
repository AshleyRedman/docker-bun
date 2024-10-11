import { Hono } from 'hono';
import { log } from '../middleware/log';

export const health = new Hono();

health.use(log);

health
    /**
     * @ GET /health
     */
    .get('/', (c) => {
        return c.json(process.env);
    })
    /**
     * @ GET /health/:seg
     */
    .get('/:seg', async (c) => {
        const a = c.req.param('seg');
        return c.json(a);
    });
