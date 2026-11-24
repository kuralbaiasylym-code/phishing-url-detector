-- 1-сұраныс: 3 кестелік JOIN (users, url_scans, scan_models/ml_models)
SELECT 
    u.username,
    s.target_url,
    s.status,
    m.model_name,
    sm.confidence
FROM users u
JOIN url_scans s ON u.user_id = s.user_id
JOIN scan_models sm ON s.scan_id = sm.scan_id
JOIN ml_models m ON sm.model_id = m.model_id;

-- 2-сұраныс: GROUP BY арқылы әр қолданушының тексерген сілтемелер саны мен орташа қауіп деңгейі
SELECT 
    u.username,
    COUNT(s.scan_id) AS total_scans,
    ROUND(AVG(s.risk_score), 2) AS avg_risk_score
FROM users u
JOIN url_scans s ON u.user_id = s.user_id
GROUP BY u.username;
