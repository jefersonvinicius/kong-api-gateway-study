import express, { Router } from 'express';
import fs from 'fs';
import path from 'path';
import url from 'url';
import jwt from 'jsonwebtoken';

const currentDir = path.dirname(url.fileURLToPath(import.meta.url));
const packageJson = JSON.parse(fs.readFileSync(path.resolve(currentDir, 'package.json')));
const SECRET = '123123';
const PORT = process.env.PORT || 3000;

const users = [];
let id = 1;
const createUser = (username) => ({ id: id++, username, createdAt: new Date() });
const usernameHasTaken = (username) => users.map((user) => user.username).includes(username);
const getUserByUsername = (username) => users.find((user) => user.username === username);

const requestAuthToken = (request) => request.headers.authorization?.split(' ')[1];

const app = express();
app.use(express.json());
app.get('/healthy', (_, response) => {
    return response.json({
        status: 'running',
        version: packageJson.version,
    });
});
app.post('/signup', (request, response) => {
    const { username } = request.body;
    if (usernameHasTaken(username)) {
        return response.status(409).json({ message: 'Username has already taken' });
    }
    const token = jwt.sign({ username }, SECRET, { expiresIn: '1d' });
    const user = createUser(username);
    users.push(user);
    return response.json({ user, token });
});

app.post('/login', (request, response) => {
    const { username } = request.body;
    const user = getUserByUsername(username);
    const token = jwt.sign({ username }, SECRET, { expiresIn: '1d' });
    return response.json({ user, token });
});

const privateRouter = Router();
privateRouter.use((request, response, next) => {
    try {
        const token = requestAuthToken(request);
        const decoded = jwt.verify(token, SECRET);
        response.locals.tokenDecoded = decoded;
        next();
    } catch (error) {
        return response.status(401).json({ message: 'Authentication failed' });
    }
});

privateRouter.get('/current', (request, response) => {
    const user = getUserByUsername(response.locals.tokenDecoded.username);
    return response.json({ user });
});

app.use(privateRouter);

app.listen(PORT, () => {
    console.log(`Serving auth at port ${PORT}`);
});
