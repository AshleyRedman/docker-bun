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

app.use(async function (_, next) {
    console.log('Middlware hit');
    await next();
});

app.get('/', (c) => {
    console.log('Route hit');
    return c.json({
        hello: 'world'
    });
});

const server: Serve = {
    port: process.env.PORT,
    fetch: app.fetch
};

console.log(`Stage: ${process.env.NODE_ENV}`);

export default server;
