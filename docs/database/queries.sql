-- Сұраныс 1: 3+ кестені JOIN (қолданушы, URL, модель бойынша фишинг табылғандар)
SELECT u.username, ur.url_text, m.name AS model, s.verdict, s.probability
FROM scans s
JOIN users u     ON u.user_id  = s.user_id
JOIN urls ur     ON ur.url_id  = s.url_id
JOIN ml_models m ON m.model_id = s.model_id
WHERE s.verdict = 'phishing'
ORDER BY s.probability DESC;

-- Сұраныс 2: GROUP BY (әр қолданушы бойынша тексеру саны және фишинг саны)
SELECT u.username,
       COUNT(*) AS total_scans,
       SUM(CASE WHEN s.verdict = 'phishing' THEN 1 ELSE 0 END) AS phishing_count
FROM scans s
JOIN users u ON u.user_id = s.user_id
GROUP BY u.username
ORDER BY total_scans DESC, u.username;
