const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

// Enable CORS so the frontend can communicate with the backend
app.use(cors());
app.use(express.json());

// API Endpoint to guess the age
app.get('/api/guess', async (req, res) => {
    const { name } = req.query;

    if (!name) {
        return res.status(400).json({ error: "Please provide a name in the query parameter." });
    }

    try {
        // We use the public free API agify.io as our core logic 
        // (alternatively, we could just randomly generate an age based on the name length)
        const response = await fetch(`https://api.agify.io?name=${name}`);
        const data = await response.json();

        // Fallback random age if the external API fails or rate limits
        let age = data.age;
        if (!age) {
            age = Math.floor(Math.random() * (80 - 10 + 1)) + 10; 
        }

        res.json({
            name: name,
            age: age,
            message: `Based on the name ${name}, we guess you are ${age} years old!`
        });
    } catch (error) {
        res.status(500).json({ error: "Failed to guess age" });
    }
});

app.get('/health', (req, res) => {
    res.status(200).send("Backend is healthy");
});

app.listen(PORT, () => {
    console.log(`Backend service is running on port ${PORT}`);
});
