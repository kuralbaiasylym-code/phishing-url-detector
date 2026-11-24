<?php
// Деректер қорына қосылу
$host = 'localhost';
$db   = 'diploma_db';
$user = 'root';
$pass = '';

$conn = new mysqli($host, $user, $pass);

// Қателерді тексеру
if ($conn->connect_error) {
    die("Қате: " . $conn->connect_error);
}

// База жоқ болса жасаймыз
$conn->query("CREATE DATABASE IF NOT EXISTS $db");
$conn->select_db($db);

// Кестелерді құру (өткендегі скрипт негізінде)
$conn->query("CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE
)");

$conn->query("CREATE TABLE IF NOT EXISTS url_scans (
    scan_id INT AUTO_INCREMENT PRIMARY KEY,
    original_url TEXT NOT NULL,
    is_phishing BOOLEAN NOT NULL,
    confidence_score DECIMAL(5,2) NOT NULL,
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)");

$message = "";
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $url = $conn->real_escape_string($_POST['url']);
    
    // Қарапайым фишингті анықтау логикасы (мысалы, '@' немесе 'login' сөзі бар ма?)
    $is_phishing = (strpos($url, '@') !== false || strpos($url, 'login') !== false || strpos($url, 'free') !== false) ? 1 : 0;
    $confidence = $is_phishing ? 88.50 : 5.10;

    // Деректер қорына сақтау
    $sql = "INSERT INTO url_scans (original_url, is_phishing, confidence_score) VALUES ('$url', '$is_phishing', '$confidence')";
    if ($conn->query(s: $sql) === TRUE) {
        $message = $is_phishing ? "⚠️ Назар аударыңыз! Бұл сілтеме фишингтік болуы мүмкін!" : "✅ Сілтеме қауіпсіз.";
    } else {
        $message = "Қате орын алды: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="kk">
<head>
    <meta charset="UTF-8">
    <title>Фишингтік URL анықтау жүйесі</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; margin: 0; padding: 50px; text-align: center; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); display: inline-block; width: 400px; }
        input[type="text"] { width: 90%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
        button { background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .result { margin-top: 20px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h2>URL тексеру жүйесі</h2>
        <form method="POST">
            <input type="text" name="url" placeholder="https://example.com" required>
            <br>
            <button type="submit">Тексеру</button>
        </form>
        <?php if (!empty($message)): ?>
            <div class="result"><?php echo $message; ?></div>
        <?php endif; ?>
    </div>
</body>
</html>