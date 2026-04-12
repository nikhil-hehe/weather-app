<?php
header('Content-Type: application/json');
require_once 'config.php';

if (!isset($_GET['city']) || empty(trim($_GET['city']))) {
    http_response_code(400);
    echo json_encode(['error' => 'City name is required.']);
    exit;
}

$city = urlencode(trim($_GET['city']));
$apiKey = OWM_API_KEY;

$currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?q={$city}&appid={$apiKey}&units=metric";
$forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?q={$city}&appid={$apiKey}&units=metric";

function fetchFromAPI($url) {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 10);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    return ['data' => $response, 'code' => $httpCode];
}

$currentWeather = fetchFromAPI($currentWeatherUrl);

if ($currentWeather['code'] !== 200) {
    http_response_code($currentWeather['code']);
    $errorData = json_decode($currentWeather['data'], true);
    echo json_encode(['error' => $errorData['message'] ?? 'Failed to fetch weather data.']);
    exit;
}

$forecast = fetchFromAPI($forecastUrl);

echo json_encode([
    'current' => json_decode($currentWeather['data']),
    'forecast' => json_decode($forecast['data'])
]);
?>
