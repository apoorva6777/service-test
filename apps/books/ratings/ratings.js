// ratings.js

const express = require("express");
const app = express();
const port = 3002;

const ratingsDetails = {
    rating: 5, // 5 star rating
    comment: "An absolute classic! Fitzgerald's storytelling prowess shines through every page."
};

app.get("/", (req, res) => {
  console.log('Hello from ratings page')
  res.json(ratingsDetails);
});

app.listen(port, () => {
  console.log(`Ratings microservice is running on port ${port}`);
});
