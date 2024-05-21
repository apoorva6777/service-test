// details.js

const express = require("express");
const app = express();
const port = 3001;

const bookDetails = {
  title: "My Life Story",
  author: "F. Scott Fitzgerald",
  year: 1925,
  genre: "Fiction",
  summary: "The story of this world through the eyes of a young boy filled with boundless curiosity and an insatiable thirst for knowledge, readers embark on an epic quest to unravel the mysteries of the universe.",
};


app.get("/", (req, res) => {
  console.log('Hello from details page')
  res.json(bookDetails);
});

app.listen(port, () => {
  console.log(`Details microservice is running on port ${port}`);
});
