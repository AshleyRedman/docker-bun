import type { Serve } from 'bun';
import { Hono } from 'hono';

declare module 'bun' {
    interface Env {
        PORT?: string;
        NODE_ENV?: string;
        TZ?: string;
    }
}

const app = new Hono();

app.use(async function (c, next) {
    console.log(process.env);
    await next();
});

app.get('/', (c) => {
    return c.json({ hello: 'world' });
});

const server: Serve = {
    port: process.env.PORT,
    fetch: app.fetch
};

export default server;
