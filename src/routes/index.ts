import { Hono } from 'hono';

export const home = new Hono();

home.get('/', (c) => {
    return c.json({
        hello: 'world'
    });
});
