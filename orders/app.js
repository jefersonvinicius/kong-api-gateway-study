import express, { Router } from 'express';
import jwt from 'jsonwebtoken';

const PORT = process.env.PORT || 3001;

const orders = [];
let id = 1;
const createOrder = ({ username, items }) => {
    const total = items.reduce((total, item) => total + item.price, 0);
    return { id: id++, username, total, items };
};

const requestAuthToken = (request) => request.headers.authorization?.split(' ')[1];

const app = express();
app.use(express.json());
app.post('/orders', (request, response) => {
    const { username } = jwt.decode(requestAuthToken(request));
    const order = createOrder({ username, items: request.body.items });
    orders.push(order);
    return response.json({ order });
});

app.listen(PORT, () => {
    console.log(`Serving auth at port ${PORT}`);
});
