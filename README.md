<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Multi Screen App - Project Showcase</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: Arial, sans-serif;
    }

    body {
      background: #f5f7fa;
      color: #222;
      padding: 30px;
      line-height: 1.6;
    }

    .container {
      max-width: 1100px;
      margin: auto;
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    }

    h1, h2 {
      margin-bottom: 15px;
      color: #111;
    }

    p {
      margin-bottom: 15px;
    }

    ul {
      margin-left: 20px;
      margin-bottom: 25px;
    }

    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-top: 20px;
    }

    .card {
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 10px;
      padding: 12px;
      text-align: center;
    }

    .card img {
      width: 100%;
      border-radius: 8px;
      margin-bottom: 10px;
    }

    .card h3 {
      font-size: 16px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Multi Screen Flutter App</h1>

    <p>
      This is a frontend-based Flutter application with multiple screens and dynamic UI features.
      The project demonstrates user registration, login flow, profile handling, dashboard navigation,
      dropdown selection, validation, and Shared Preferences integration.
    </p>

    <h2>Features Implemented</h2>
    <ul>
      <li>User Registration Screen with complete form validation</li>
      <li>Login Screen with dynamic email display</li>
      <li>Shared Preferences integration for storing registered user data</li>
      <li>After login, the same registered user name is displayed dynamically</li>
      <li>The same registered email is shown on the login screen</li>
      <li>Dropdown functionality implemented</li>
      <li>Dashboard screen navigation</li>
      <li>Profile screen with dynamic user details</li>
      <li>Inner screens navigation</li>
      <li>All UI is frontend-based and dynamically connected</li>
    </ul>

    <h2>Application Screenshots</h2>

    <div class="grid">
      <div class="card">
        <img src="./screenshots/registeration_screen.png" alt="Registration Screen">
        <h3>Registration Screen</h3>
      </div>

      <div class="card">
        <img src="./screenshots/login.png" alt="Login Screen">
        <h3>Login Screen</h3>
      </div>

      <div class="card">
        <img src="./screenshots/dashboard.png" alt="Dashboard">
        <h3>Dashboard</h3>
      </div>

      <div class="card">
        <img src="./screenshots/home.png" alt="Home Screen">
        <h3>Home Screen</h3>
      </div>

      <div class="card">
        <img src="./screenshots/dropdown.png" alt="Dropdown">
        <h3>Dropdown Feature</h3>
      </div>

      <div class="card">
        <img src="./screenshots/profilescreen.png" alt="Profile Screen">
        <h3>Profile Screen</h3>
      </div>

      <div class="card">
        <img src="./screenshots/innerscreen1.png" alt="Inner Screen">
        <h3>Inner Screen</h3>
      </div>

      <div class="card">
        <img src="./screenshots/validation.png" alt="Validation Screen">
        <h3>Validation</h3>
      </div>
    </div>
  </div>
</body>
</html>
