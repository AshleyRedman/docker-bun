import type { Serve } from 'bun';
import { Hono } from 'hono';
import { home } from './routes';
import { health } from './routes/health';

declare module 'bun' {
    interface Env {
        PORT?: string;
        NODE_ENV?: string;
        TZ?: string;
    }
}

const app = new Hono();

app.basePath('/');
app.route('/', home);
app.route('/health', health);

const server: Serve = {
    port: process.env.PORT,
    fetch: app.fetch
};

console.log(`Stage: ${process.env.NODE_ENV}`);

export default server;
