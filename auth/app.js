import express from 'express'
import jwt from 'jsonwebtoken'

const SECRET = 'any-secret'
const PORT = process.env.PORT || 3000

const users:string[] = []

const app = express()
app.post('/login', (request, response) => {
    const {username} = request.body
    const token = jwt.sign({ username }, SECRET, {expiresIn: '1d'})
    return response.json({token})
})

app.listen(PORT, () => {
    console.log(`Serving auth at port ${PORT}`)
})