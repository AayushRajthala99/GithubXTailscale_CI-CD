import React, { useState, useEffect } from "react";
import "./App.css";

function App() {
  // 'message' will hold the data from the backend
  // 'setMessage' is the function we use to update it
  const [message, setMessage] = useState("Loading...");

  // useEffect runs when the component loads
  useEffect(() => {
    // We call the backend API
    // In the docker-compose setup, 'backend' is the hostname for the backend service.
    // When running locally (not in Docker), you would use 'http://localhost:5000'
    fetch("http://localhost:5000")
      .then((response) => response.json())
      .then((data) => {
        // We set the state variable with the message from the backend
        setMessage(data.message);
      })
      .catch((error) => {
        console.error("There was an error fetching the data:", error);
        setMessage("Failed to load data from backend");
      });
  }, []); // The empty array [] means this effect runs only once

  return (
    <div className="App">
      <header className="App-header">
        <h1>Frontend-Backend Integration</h1>
        <p>This message is fetched from your Python-Flask API:</p>
        <h2>{message}</h2>
      </header>
    </div>
  );
}

export default App;
