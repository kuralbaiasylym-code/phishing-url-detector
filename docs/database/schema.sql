-- Фишингтік URL-сілтемелерді анықтау жүйесі: деректер қоры (PostgreSQL)
DROP TABLE IF EXISTS url_features CASCADE;
DROP TABLE IF EXISTS scans CASCADE;
DROP TABLE IF EXISTS features CASCADE;
DROP TABLE IF EXISTS ml_models CASCADE;
DROP TABLE IF EXISTS urls CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    user_id       INT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL,
    created_at    TIMESTAMP    NOT NULL
);

CREATE TABLE urls (
    url_id        INT PRIMARY KEY,
    url_text      VARCHAR(2048) NOT NULL,
    domain        VARCHAR(255)  NOT NULL,
    first_seen_at TIMESTAMP     NOT NULL
);

CREATE TABLE ml_models (
    model_id   INT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    algorithm  VARCHAR(50)  NOT NULL,
    accuracy   NUMERIC(5,4) NOT NULL,
    trained_at TIMESTAMP    NOT NULL
);

CREATE TABLE features (
    feature_id  INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL
);

CREATE TABLE scans (
    scan_id     INT PRIMARY KEY,
    user_id     INT          NOT NULL REFERENCES users(user_id),
    url_id      INT          NOT NULL REFERENCES urls(url_id),
    model_id    INT          NOT NULL REFERENCES ml_models(model_id),
    verdict     VARCHAR(20)  NOT NULL,
    probability NUMERIC(5,4) NOT NULL,
    scanned_at  TIMESTAMP    NOT NULL
);

CREATE TABLE url_features (
    url_feature_id INT PRIMARY KEY,
    url_id         INT NOT NULL REFERENCES urls(url_id),
    feature_id     INT NOT NULL REFERENCES features(feature_id),
    value          NUMERIC(12,4) NOT NULL,
    UNIQUE (url_id, feature_id)
);

INSERT INTO users VALUES
(1,'aigerim','aigerim@mail.kz','hash_a1','user','2026-09-01 10:00:00'),
(2,'nurlan','nurlan@mail.kz','hash_n2','user','2026-09-03 12:30:00'),
(3,'dana','dana@mail.kz','hash_d3','user','2026-09-10 09:15:00'),
(4,'admin','admin@phishdetect.kz','hash_ad','admin','2026-08-25 08:00:00');

INSERT INTO urls VALUES
(1,'https://www.google.com/search?q=test','google.com','2026-10-01 10:00:00'),
(2,'http://paypa1-secure-login.xyz/verify','paypa1-secure-login.xyz','2026-10-02 11:00:00'),
(3,'http://192.168.10.5/kaspi/login.php','192.168.10.5','2026-10-03 14:20:00'),
(4,'https://egov.kz/cms/kk','egov.kz','2026-10-04 09:40:00'),
(5,'http://halyk-bonus.top/@claim','halyk-bonus.top','2026-10-05 16:10:00');

INSERT INTO ml_models VALUES
(1,'RF_v1','RandomForest',0.9420,'2026-10-10 12:00:00'),
(2,'XGB_v1','XGBoost',0.9610,'2026-10-20 12:00:00'),
(3,'LR_baseline','LogisticRegression',0.8975,'2026-10-05 12:00:00');

INSERT INTO features VALUES
(1,'url_length','URL ұзындығы'),
(2,'has_ip','Домен орнына IP-мекенжай болуы (1/0)'),
(3,'num_dots','URL-дегі нүктелер саны'),
(4,'has_at_symbol','@ таңбасының болуы (1/0)'),
(5,'is_https','HTTPS қолданылуы (1/0)');

INSERT INTO scans VALUES
(1,1,1,2,'legitimate',0.0210,'2026-11-01 10:05:00'),
(2,1,2,2,'phishing',0.9730,'2026-11-01 10:07:00'),
(3,2,3,2,'phishing',0.9215,'2026-11-02 18:30:00'),
(4,2,4,1,'legitimate',0.0480,'2026-11-03 09:00:00'),
(5,3,5,2,'phishing',0.9890,'2026-11-04 20:10:00'),
(6,3,1,1,'legitimate',0.0350,'2026-11-05 11:45:00');

INSERT INTO url_features VALUES
(1,1,1,36),
(2,1,2,0),
(3,1,3,2),
(4,1,4,0),
(5,1,5,1),
(6,2,1,37),
(7,2,2,0),
(8,2,3,1),
(9,2,4,0),
(10,2,5,0),
(11,3,1,36),
(12,3,2,1),
(13,3,3,3),
(14,3,4,0),
(15,3,5,0),
(16,4,1,21),
(17,4,2,0),
(18,4,3,1),
(19,4,4,0),
(20,4,5,1),
(21,5,1,31),
(22,5,2,0),
(23,5,3,1),
(24,5,4,1),
(25,5,5,0);
