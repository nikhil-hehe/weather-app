<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
</head>

<body>

    <div class="glass-container">

        <div id="app-hero">
            <div id="hero-icon">⛅</div>
            <h1 id="hero-title">Weather</h1>
            <p id="hero-subtitle">Search any city to get started</p>
        </div>

        <header>
            <form id="search-form">
                <input type="text" id="city-input" placeholder="e.g. Ghaziabad" autocomplete="off" required>
                <button type="submit">Search</button>
            </form>
            <div id="error-message" class="hidden"></div>
        </header>

        <main id="weather-content" class="hidden">
            <section id="current-weather">
                <h1 id="city-name">--</h1>
                <div class="temp-container">
                    <img id="current-icon" src="" alt="Weather Icon">
                    <span id="current-temp">--°C</span>
                </div>
                <p id="current-description">--</p>
                <div class="details">
                    <div class="detail-box">
                        <span>Humidity</span>
                        <span id="humidity">--%</span>
                    </div>
                    <div class="detail-box">
                        <span>Wind Speed</span>
                        <span id="wind-speed">-- m/s</span>
                    </div>
                </div>
            </section>

            <section id="forecast-section">
                <h3>5-Day Forecast</h3>
                <div class="forecast-container" id="forecast-container"></div>
            </section>
        </main>

    </div>

    <script src="js/app.js"></script>
</body>

</html>
