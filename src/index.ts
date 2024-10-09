import type { Serve } from 'bun';
import { Hono } from 'hono';

const app = new Hono();

app.use(async function (c, next) {
    console.log(process.env);
    await next();
});

app.get('/', (c) => {
    return c.json({ hello: 'world' });
});

const server: Serve = {
    port: 3000,
    fetch: app.fetch
};

export default server;
