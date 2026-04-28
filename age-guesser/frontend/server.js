const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Serve the static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

app.get('/health', (req, res) => {
    res.status(200).send("Frontend is healthy");
});

app.listen(PORT, () => {
    console.log(`Frontend service is running on port ${PORT}`);
});
