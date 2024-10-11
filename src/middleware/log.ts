import { type MiddlewareHandler } from 'hono';

export const log: MiddlewareHandler = async function (c, next) {
    console.log(c.req.path);
    console.log('Log middlware hit');
    await next();
};
