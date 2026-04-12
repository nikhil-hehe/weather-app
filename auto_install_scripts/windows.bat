<# :
@echo off
echo ========================================================
echo Weather Dashboard - Windows Setup
echo ========================================================
echo.
powershell -ExecutionPolicy Bypass -NoProfile -Command "Invoke-Expression $([System.IO.File]::ReadAllText('%~f0'))"
echo.
echo Setup Complete! Press any key to exit...
pause >nul
goto :eof
#>

# --- PowerShell Script Starts Here ---

# 1. Determine Installation Directory
$xamppDir = "C:\xampp\htdocs\weather-app"
$TargetDir = $xamppDir

if (!(Test-Path "C:\xampp\htdocs\")) {
    $TargetDir = "$PWD\weather-app"
    Write-Host "XAMPP not found at C:\xampp\htdocs. Creating in current directory instead: $TargetDir" -ForegroundColor Yellow
} else {
    Write-Host "XAMPP detected! Installing to: $TargetDir" -ForegroundColor Green
}

# 2. Create Folders
New-Item -ItemType Directory -Force -Path "$TargetDir\css" | Out-Null
New-Item -ItemType Directory -Force -Path "$TargetDir\js" | Out-Null

# 3. Create config.php
$configPhp = @"
<?php
define('OWM_API_KEY', 'YOUR_API_KEY_HERE');
?>
"@
Set-Content -Path "$TargetDir\config.php" -Value $configPhp -Encoding UTF8

# 4. Create weather.php
$weatherPhp = @"
<?php
header('Content-Type: application/json');
require_once 'config.php';

if (!isset(`$_GET['city']) || empty(trim(`$_GET['city']))) {
    http_response_code(400);
    echo json_encode(['error' => 'City name is required.']);
    exit;
}

`$city = urlencode(trim(`$_GET['city']));
`$apiKey = OWM_API_KEY;

`$currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?q={`$city}&appid={`$apiKey}&units=metric";
`$forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?q={`$city}&appid={`$apiKey}&units=metric";

function fetchFromAPI(`$url) {
    `$ch = curl_init();
    curl_setopt(`$ch, CURLOPT_URL, `$url);
    curl_setopt(`$ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt(`$ch, CURLOPT_TIMEOUT, 10);
    `$response = curl_exec(`$ch);
    `$httpCode = curl_getinfo(`$ch, CURLINFO_HTTP_CODE);
    curl_close(`$ch);

    return ['data' => `$response, 'code' => `$httpCode];
}

`$currentWeather = fetchFromAPI(`$currentWeatherUrl);

if (`$currentWeather['code'] !== 200) {
    http_response_code(`$currentWeather['code']);
    `$errorData = json_decode(`$currentWeather['data'], true);
    echo json_encode(['error' => `$errorData['message'] ?? 'Failed to fetch weather data.']);
    exit;
}

`$forecast = fetchFromAPI(`$forecastUrl);

echo json_encode([
    'current' => json_decode(`$currentWeather['data']),
    'forecast' => json_decode(`$forecast['data'])
]);
?>
"@
Set-Content -Path "$TargetDir\weather.php" -Value $weatherPhp -Encoding UTF8

# 5. Create index.php
$indexPhp = @"
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
                <div class="forecast-container" id="forecast-container">
                </div>
            </section>
        </main>
    </div>
    <script src="js/app.js"></script>
</body>
</html>
"@
Set-Content -Path "$TargetDir\index.php" -Value $indexPhp -Encoding UTF8

# 6. Create css/style.css
$styleCss = @"
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Poppins', sans-serif;
}
body {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
    color: #fff;
    padding: 20px;
}
.glass-container {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 20px;
    padding: 30px;
    width: 100%;
    max-width: 600px;
    box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
}
header { margin-bottom: 20px; }
form { display: flex; gap: 10px; }
input {
    flex: 1; padding: 12px 20px; border: none; border-radius: 30px;
    background: rgba(255, 255, 255, 0.2); color: #fff; outline: none; font-size: 16px;
}
input::placeholder { color: rgba(255, 255, 255, 0.7); }
button {
    padding: 12px 25px; border: none; border-radius: 30px;
    background: #00c6ff; color: #fff; font-weight: 600; cursor: pointer; transition: 0.3s;
}
button:hover { background: #0072ff; }
.hidden { display: none !important; }
#error-message {
    color: #ff6b6b; margin-top: 10px; text-align: center;
    background: rgba(255, 0, 0, 0.1); padding: 10px; border-radius: 10px;
}
#current-weather { text-align: center; margin-bottom: 30px; }
.temp-container {
    display: flex; justify-content: center; align-items: center;
    gap: 10px; font-size: 3rem; font-weight: 600; margin: 10px 0;
}
#current-description { text-transform: capitalize; font-size: 1.2rem; margin-bottom: 20px; }
.details {
    display: flex; justify-content: space-around;
    background: rgba(255, 255, 255, 0.05); padding: 15px; border-radius: 15px;
}
.detail-box { display: flex; flex-direction: column; }
.detail-box span:first-child { font-size: 0.9rem; opacity: 0.8; }
.detail-box span:last-child { font-weight: 600; }
h3 {
    margin-bottom: 15px; font-weight: 400; border-bottom: 1px solid rgba(255, 255, 255, 0.2); padding-bottom: 5px;
}
.forecast-container {
    display: flex; gap: 10px; overflow-x: auto; padding-bottom: 10px;
}
.forecast-item {
    background: rgba(255, 255, 255, 0.1); padding: 15px; border-radius: 15px;
    min-width: 100px; text-align: center; flex-shrink: 0;
}
.forecast-item img { width: 50px; }
::-webkit-scrollbar { height: 8px; }
::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.05); border-radius: 10px; }
::-webkit-scrollbar-thumb { background: rgba(255, 255, 255, 0.2); border-radius: 10px; }
"@
Set-Content -Path "$TargetDir\css\style.css" -Value $styleCss -Encoding UTF8

# 7. Create js/app.js
$appJs = @"
document.getElementById('search-form').addEventListener('submit', async function(e) {
    e.preventDefault();
    const city = document.getElementById('city-input').value;
    const errorMsg = document.getElementById('error-message');
    const weatherContent = document.getElementById('weather-content');
    const submitBtn = this.querySelector('button');

    errorMsg.classList.add('hidden');
    weatherContent.classList.add('hidden');
    submitBtn.textContent = 'Loading...';
    submitBtn.disabled = true;

    try {
        const response = await fetch(`weather.php?city=`${encodeURIComponent(city)}`);
        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || 'Something went wrong');
        }

        updateCurrentWeather(data.current);
        updateForecast(data.forecast);
        weatherContent.classList.remove('hidden');

    } catch (error) {
        errorMsg.textContent = error.message;
        errorMsg.classList.remove('hidden');
    } finally {
        submitBtn.textContent = 'Search';
        submitBtn.disabled = false;
    }
});

function updateCurrentWeather(data) {
    document.getElementById('city-name').textContent = `${data.name}, ${data.sys.country}`;
    document.getElementById('current-temp').textContent = `${Math.round(data.main.temp)}°C`;
    document.getElementById('current-description').textContent = data.weather[0].description;
    document.getElementById('humidity').textContent = `${data.main.humidity}%`;
    document.getElementById('wind-speed').textContent = `${data.wind.speed} m/s`;
    
    const iconCode = data.weather[0].icon;
    document.getElementById('current-icon').src = `https://openweathermap.org/img/wn/${iconCode}@2x.png`;
}

function updateForecast(data) {
    const container = document.getElementById('forecast-container');
    container.innerHTML = '';

    const dailyData = data.list.filter(item => item.dt_txt.includes('12:00:00'));

    dailyData.forEach(day => {
        const date = new Date(day.dt * 1000);
        const dayName = date.toLocaleDateString('en-US', { weekday: 'short' });
        const iconCode = day.weather[0].icon;
        const temp = Math.round(day.main.temp);

        const html = `<div class="forecast-item">
                <div>${dayName}</div>
                <img src="https://openweathermap.org/img/wn/${iconCode}.png" alt="icon">
                <div>${temp}°C</div>
            </div>`;
        container.innerHTML += html;
    });
}
"@
Set-Content -Path "$TargetDir\js\app.js" -Value $appJs -Encoding UTF8

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "IMPORTANT: Edit config.php in the folder and add your API key." -ForegroundColor Yellow
if ($TargetDir -match "xampp") {
    Write-Host "Make sure XAMPP Apache is running and visit: http://localhost/weather-app/" -ForegroundColor White
} else {
    Write-Host "To run this without XAMPP, open a terminal in $TargetDir and type:`nphp -S localhost:8000" -ForegroundColor White
}
Write-Host "========================================================`n" -ForegroundColor Cyan
