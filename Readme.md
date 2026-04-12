# 🌤️ Weather Dashboard Mini-Project

A professional-grade, responsive Weather Web Application built with PHP, JavaScript, and the OpenWeatherMap API. This project securely fetches real-time weather data and a 5-day forecast while keeping sensitive API keys hidden on the backend.

---

## ✨ Features

- **Dynamic Global Search:** Search for current weather and forecasts for any city worldwide.
- **Current Weather Dashboard:** Displays temperature, weather conditions, humidity, and wind speed.
- **Extended 5-Day Forecast:** Responsive daily forecast cards.
- **Secure API Architecture:** API requests are handled server-side via PHP cURL to protect the OpenWeatherMap API key from client-side exposure.
- **Modern UI/UX:** Clean, responsive design featuring a Glassmorphism aesthetic.
- **Graceful Error Handling:** Provides clear user feedback for invalid cities, typos, or network errors.

---

## 🛠️ Tech Stack

| Layer       | Technology                      |
|-------------|---------------------------------|
| Frontend    | HTML5, CSS3, Vanilla JavaScript |
| Backend     | PHP                             |
| API         | OpenWeatherMap (Free Tier)      |
| Environment | Apache (httpd) / Localhost (XAMPP/MAMP) |

---

## 🚀 Installation & Setup

### Prerequisites

1. A web server environment with PHP support (Apache/Nginx natively, or XAMPP/MAMP).
2. An active API key from [OpenWeatherMap](https://openweathermap.org/).

---

### Installation (XAMPP / MAMP / Any OS)

1. Start your local web server (e.g., start the Apache service in XAMPP/MAMP).
2. Create a folder named `weather-app` inside your server's public web directory:

   | Platform             | Path                                      |
   |----------------------|-------------------------------------------|
   | Linux (Apache)       | `/var/www/html/weather-app/`              |
   | XAMPP (Windows)      | `C:\xampp\htdocs\weather-app\`            |
   | MAMP (macOS)         | `/Applications/MAMP/htdocs/weather-app/` |

3. Place all project files (`index.php`, `weather.php`, `config.php`, `css/`, `js/`) inside this folder.

---

## 🔑 Configuration (Required)

Before running the application, you must configure your OpenWeatherMap API key. The application will not fetch data without it.

1. Open the `config.php` file located in the root of the project directory.
2. Replace `'YOUR_API_KEY_HERE'` with your actual API key string:

```php
<?php
// Store your API key securely.
define('OWM_API_KEY', 'your_actual_api_key_string_here');
?>
```

3. Save the file.

---

## 💻 Usage

1. Open your preferred web browser.
2. Navigate to your local server address:

```
http://localhost/weather-app/
```

3. Enter a city name (e.g., `New Delhi`) in the search bar and click **Search**.
