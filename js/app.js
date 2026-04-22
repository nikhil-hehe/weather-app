const searchForm = document.getElementById('search-form');
const cityInput = document.getElementById('city-input');
const errorMessage = document.getElementById('error-message');
const weatherContent = document.getElementById('weather-content');
const cityName = document.getElementById('city-name');
const currentIcon = document.getElementById('current-icon');
const currentTemp = document.getElementById('current-temp');
const currentDesc = document.getElementById('current-description');
const humidityEl = document.getElementById('humidity');
const windSpeedEl = document.getElementById('wind-speed');
const forecastContainer = document.getElementById('forecast-container');

const appHero = document.getElementById('app-hero');

searchForm.addEventListener('submit', function (e) {
    e.preventDefault(); // stop page reload
    const city = cityInput.value.trim();
    if (city) getWeather(city);
});

async function getWeather(city) {
    errorMessage.classList.add('hidden');
    weatherContent.classList.add('hidden');

    try {
        const res = await fetch('weather.php?city=' + encodeURIComponent(city));
        const data = await res.json();

        if (!res.ok || data.error) {
            showError(data.error || 'City not found.');
            return;
        }

        displayWeather(data);

    } catch (err) {
        showError('Network error. Please try again.');
    }searchForm.addEventListener('submit', function (e) {

}

function displayWeather(data) {
    const cur = data.current;

    cityName.textContent = cur.name + ', ' + cur.sys.country;
    currentTemp.textContent = Math.round(cur.main.temp) + '°C';
    currentDesc.textContent = cur.weather[0].description;
    humidityEl.textContent = cur.main.humidity + '%';
    windSpeedEl.textContent = cur.wind.speed + ' m/s';

    const iconCode = cur.weather[0].icon;
    currentIcon.src = 'https://openweathermap.org/img/wn/' + iconCode + '@2x.png';

    setBackground(cur.weather[0].id);

    buildForecast(data.forecast.list);

    appHero.classList.add('hidden');

    weatherContent.classList.remove('hidden');
}

function setBackground(id) {
    if (id >= 200 && id < 300) document.body.className = 'stormy';
    else if (id >= 300 && id < 600) document.body.className = 'rainy';
    else if (id >= 600 && id < 700) document.body.className = 'snowy';
    else if (id >= 700 && id < 800) document.body.className = 'misty';
    else if (id === 800) document.body.className = 'sunny';
    else document.body.className = 'cloudy';
}

function buildForecast(list) {
    forecastContainer.innerHTML = '';
    const seenDays = [];

    for (const item of list) {
        const day = new Date(item.dt * 1000).toLocaleDateString('en-US', { weekday: 'short' });

        if (seenDays.includes(day)) continue;
        seenDays.push(day);
        if (seenDays.length > 5) break;

        const iconCode = item.weather[0].icon;
        const temp = Math.round(item.main.temp) + '°C';

        const card = document.createElement('div');
        card.className = 'forecast-card';
        card.innerHTML = `
      <span class="forecast-day">${day}</span>
      <img src="https://openweathermap.org/img/wn/${iconCode}.png" alt="">
      <span class="forecast-temp">${temp}</span>
    `;
        forecastContainer.appendChild(card);
    }
}

function showError(msg) {
    errorMessage.textContent = msg;
    errorMessage.classList.remove('hidden');
}
