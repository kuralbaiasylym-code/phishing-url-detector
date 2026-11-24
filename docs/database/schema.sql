CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE url_scans (
    scan_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    target_url TEXT NOT NULL,
    risk_score DECIMAL(5,2) NOT NULL,
    status ENUM('Safe', 'Phishing', 'Suspicious') NOT NULL,
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE ml_models (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    version VARCHAR(20) NOT NULL,
    accuracy DECIMAL(5,2) NOT NULL,
    trained_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- M:N аралық кесте (scan_models)
CREATE TABLE scan_models (
    scan_id INT NOT NULL,
    model_id INT NOT NULL,
    confidence DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (scan_id, model_id),
    FOREIGN KEY (scan_id) REFERENCES url_scans(scan_id) ON DELETE CASCADE,
    FOREIGN KEY (model_id) REFERENCES ml_models(model_id) ON DELETE CASCADE
);

CREATE TABLE reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    scan_id INT NOT NULL,
    details TEXT NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (scan_id) REFERENCES url_scans(scan_id) ON DELETE CASCADE
);

CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    scan_id INT NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'Reviewed', 'Resolved') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (scan_id) REFERENCES url_scans(scan_id) ON DELETE CASCADE
);

-- Бастапқы деректер (INSERT)
INSERT INTO users (username, email, password_hash, role) VALUES
('assylm_k', 'assylm@aues.kz', 'hash_pass_1', 'user'),
('ermek_dev', 'ermek@aues.kz', 'hash_pass_2', 'user'),
('admin_sys', 'admin@aues.kz', 'hash_admin_0', 'admin');

INSERT INTO ml_models (model_name, version, accuracy) VALUES
('Random Forest Classifier', 'v1.2', 96.40),
('Neural Network PhishDetect', 'v2.0', 98.15),
('SVM Baseline Model', 'v1.0', 91.80);

INSERT INTO url_scans (user_id, target_url, risk_score, status) VALUES
(1, 'http://secure-login-bank-update.com', 94.50, 'Phishing'),
(1, 'https://github.com/kuralbaiasylym-code', 2.10, 'Safe'),
(2, 'http://free-prize-winner-2026.net', 88.70, 'Phishing');

INSERT INTO scan_models (scan_id, model_id, confidence) VALUES
(1, 1, 95.00),
(1, 2, 98.20),
(2, 2, 99.10),
(3, 1, 87.50),
(3, 3, 90.00);

INSERT INTO reports (scan_id, details) VALUES
(1, 'High phishing probability detected due to suspicious domain keywords.'),
(2, 'SSL certificate valid, domain reputation clean.');

INSERT INTO complaints (user_id, scan_id, description, status) VALUES
(2, 3, 'False positive check requested for promotional domain.', 'Pending');
