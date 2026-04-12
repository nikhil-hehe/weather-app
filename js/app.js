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
        const response = await fetch(`weather.php?city=${encodeURIComponent(city)}`);
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

        const html = `
            <div class="forecast-item">
                <div>${dayName}</div>
                <img src="https://openweathermap.org/img/wn/${iconCode}.png" alt="icon">
                <div>${temp}°C</div>
            </div>
        `;
        container.innerHTML += html;
    });
}
