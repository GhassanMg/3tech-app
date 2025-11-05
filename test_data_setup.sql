-- ============================================================
-- 3OBADI REWARDS PLATFORM - TEST DATA SETUP
-- ============================================================
-- This script creates sample data for testing the API
-- Run this after your server has created the database schema
-- ============================================================

-- ============================================================
-- 1. CREATE AMOUNT TYPES
-- ============================================================
-- These are the valid recharge amounts users can redeem
-- ============================================================

INSERT INTO amount_types (amount, is_active) VALUES
(500, true),
(1000, true),
(2000, true),
(5000, true),
(10000, true)
ON DUPLICATE KEY UPDATE is_active = true;

-- ============================================================
-- 2. CREATE TEST AGENTS
-- ============================================================
-- Agents are brands/companies that run promotional campaigns
-- ============================================================

INSERT INTO agents (agent_name, agent_logo, agent_primary_color) VALUES
('Pepsi Syria', 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Pepsi_logo_2014.svg/200px-Pepsi_logo_2014.svg.png', '#0045AD'),
('Coca-Cola Syria', 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Coca-Cola_logo.svg/200px-Coca-Cola_logo.svg.png', '#F40009'),
('Galaxy Chocolate', 'https://via.placeholder.com/150/8B4513/FFFFFF?text=Galaxy', '#8B4513'),
('Test Agent', 'https://via.placeholder.com/150/FF5733/FFFFFF?text=Test', '#FF5733')
ON DUPLICATE KEY UPDATE agent_name = VALUES(agent_name);

-- ============================================================
-- 3. CREATE AWARDS
-- ============================================================
-- Three types: points, discount, physical
-- percentage field can be used for weighted random selection
-- ============================================================

-- Points Awards (most common)
INSERT INTO awards (award_type, award_value, percentage, award_description) VALUES
('points', '50', 40, 'Congratulations! You won 50 points'),
('points', '100', 30, 'Great! You won 100 points'),
('points', '200', 15, 'Amazing! You won 200 points'),
('points', '500', 10, 'Jackpot! You won 500 points'),
('points', '1000', 3, 'MEGA WIN! You won 1000 points!');

-- Discount Awards
INSERT INTO awards (award_type, award_value, percentage, award_description) VALUES
('discount', 'SAVE10', 30, 'Get 10% off your next purchase'),
('discount', 'SAVE20', 20, 'Get 20% off your next purchase'),
('discount', 'SAVE50', 10, 'Get 50% off your next purchase'),
('discount', 'FREESHIP', 25, 'Free shipping on your next order');

-- Physical Prizes
INSERT INTO awards (award_type, award_value, percentage, award_description) VALUES
('physical', 'T-Shirt', 40, 'Win a branded T-Shirt!'),
('physical', 'Cap', 30, 'Win a branded Cap!'),
('physical', 'Backpack', 15, 'Win a premium Backpack!'),
('physical', 'Bluetooth Speaker', 10, 'Win a Bluetooth Speaker!'),
('physical', 'Smartwatch', 3, 'Win a Smartwatch!'),
('physical', 'iPhone 15 Pro', 1, 'GRAND PRIZE: iPhone 15 Pro!'),
('physical', 'Samsung Galaxy S24', 1, 'GRAND PRIZE: Samsung Galaxy S24!');

-- ============================================================
-- 4. CREATE TEST BARCODES
-- ============================================================
-- Create a variety of barcodes for testing different scenarios
-- ============================================================

-- Get agent_id and award_id (adjust these if your IDs are different)
SET @agent_pepsi = (SELECT agent_id FROM agents WHERE agent_name = 'Pepsi Syria' LIMIT 1);
SET @agent_test = (SELECT agent_id FROM agents WHERE agent_name = 'Test Agent' LIMIT 1);
SET @award_points_100 = (SELECT award_id FROM awards WHERE award_type = 'points' AND award_value = '100' LIMIT 1);
SET @award_points_500 = (SELECT award_id FROM awards WHERE award_type = 'points' AND award_value = '500' LIMIT 1);
SET @award_discount = (SELECT award_id FROM awards WHERE award_type = 'discount' AND award_value = 'SAVE20' LIMIT 1);
SET @award_physical = (SELECT award_id FROM awards WHERE award_type = 'physical' AND award_value = 'T-Shirt' LIMIT 1);

-- Winner Barcodes - Points
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('WIN-POINTS-100-001', @agent_test, @award_points_100, true, false, false),
('WIN-POINTS-100-002', @agent_test, @award_points_100, true, false, false),
('WIN-POINTS-100-003', @agent_test, @award_points_100, true, false, false),
('WIN-POINTS-500-001', @agent_pepsi, @award_points_500, true, false, false),
('WIN-POINTS-500-002', @agent_pepsi, @award_points_500, true, false, false);

-- Winner Barcodes - Discount
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('WIN-DISCOUNT-001', @agent_test, @award_discount, true, false, false),
('WIN-DISCOUNT-002', @agent_test, @award_discount, true, false, false);

-- Winner Barcodes - Physical
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('WIN-PHYSICAL-001', @agent_test, @award_physical, true, false, false),
('WIN-PHYSICAL-002', @agent_test, @award_physical, true, false, false);

-- Non-Winner Barcodes (Better luck next time)
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('LOSE-001', @agent_test, @award_points_100, false, false, false),
('LOSE-002', @agent_test, @award_points_100, false, false, false),
('LOSE-003', @agent_pepsi, @award_points_100, false, false, false),
('LOSE-004', @agent_pepsi, @award_points_100, false, false, false),
('LOSE-005', @agent_test, @award_points_100, false, false, false);

-- Already Used Barcodes (for testing error scenarios)
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('USED-001', @agent_test, @award_points_100, true, true, false),
('USED-002', @agent_test, @award_points_100, true, true, true);

-- ============================================================
-- 5. CREATE TEST USERS (Optional)
-- ============================================================
-- You can create users via API or manually here
-- Password: Test@123456 (hashed)
-- ============================================================

-- Note: It's better to create users via the signup API endpoint
-- But if you need to create them manually, use the API first to get proper hash
-- Then you can reference them here

-- Example query to check if test user exists:
-- SELECT * FROM users WHERE mobile = '963933333333';

-- To give a user admin rights:
-- UPDATE users SET role = 'ADMIN' WHERE mobile = '963933333333';

-- To give a user points for testing:
-- UPDATE users SET points = 5000 WHERE mobile = '963933333333';

-- ============================================================
-- 6. VERIFICATION QUERIES
-- ============================================================
-- Run these to verify your test data was created successfully
-- ============================================================

-- Check amount types
SELECT 'Amount Types:' as Info;
SELECT * FROM amount_types ORDER BY amount;

-- Check agents
SELECT 'Agents:' as Info;
SELECT agent_id, agent_name, agent_primary_color FROM agents;

-- Check awards
SELECT 'Awards:' as Info;
SELECT award_id, award_type, award_value, award_description FROM awards ORDER BY award_type, award_value;

-- Check barcodes
SELECT 'Barcodes Summary:' as Info;
SELECT 
    a.agent_name,
    aw.award_type,
    COUNT(*) as barcode_count,
    SUM(CASE WHEN b.winner = true THEN 1 ELSE 0 END) as winning_barcodes,
    SUM(CASE WHEN b.is_used = true THEN 1 ELSE 0 END) as used_barcodes
FROM barcodes b
JOIN agents a ON b.agent_id = a.agent_id
JOIN awards aw ON b.award_id = aw.award_id
GROUP BY a.agent_name, aw.award_type;

-- List all winner barcodes for easy testing
SELECT 'Available Winner Barcodes (Use these in Postman):' as Info;
SELECT 
    b.barcode_id,
    a.agent_name,
    aw.award_type,
    aw.award_value,
    b.is_used
FROM barcodes b
JOIN agents a ON b.agent_id = a.agent_id
JOIN awards aw ON b.award_id = aw.award_id
WHERE b.winner = true AND b.is_used = false
ORDER BY aw.award_type, aw.award_value;

-- ============================================================
-- 7. CLEANUP SCRIPT (Use if you want to reset test data)
-- ============================================================

/*
-- WARNING: This will delete all test data!
-- Uncomment to use:

DELETE FROM barcodes WHERE barcode_id LIKE 'WIN-%' OR barcode_id LIKE 'LOSE-%' OR barcode_id LIKE 'USED-%';
DELETE FROM awards WHERE award_description LIKE '%test%' OR award_description LIKE '%Test%';
DELETE FROM agents WHERE agent_name LIKE '%Test%';
DELETE FROM amount_types WHERE amount IN (500, 1000, 2000, 5000, 10000);
DELETE FROM users WHERE mobile LIKE '96393%' OR mobile LIKE '96394%' OR mobile LIKE '96395%';
DELETE FROM transitions;
DELETE FROM mobile_verifications;
DELETE FROM password_verifications;

-- Reset auto-increment (optional)
ALTER TABLE amount_types AUTO_INCREMENT = 1;
ALTER TABLE agents AUTO_INCREMENT = 1;
ALTER TABLE awards AUTO_INCREMENT = 1;
ALTER TABLE transitions AUTO_INCREMENT = 1;
*/

-- ============================================================
-- 8. USEFUL QUERIES FOR TESTING
-- ============================================================

-- Get user's points
-- SELECT mobile, name, points, sim_provider FROM users WHERE mobile = '963933333333';

-- Get user's barcode history
-- SELECT b.barcode_id, a.agent_name, aw.award_type, aw.award_value, b.is_used, b.used_at 
-- FROM barcodes b
-- JOIN users u ON b.user_id = u.user_id
-- JOIN agents a ON b.agent_id = a.agent_id
-- JOIN awards aw ON b.award_id = aw.award_id
-- WHERE u.mobile = '963933333333'
-- ORDER BY b.used_at DESC;

-- Get user's transition history
-- SELECT t.transition_id, t.is_success, t.is_accepted, amt.amount, t.sent_at
-- FROM transitions t
-- JOIN users u ON t.user_id = u.user_id
-- JOIN amount_types amt ON t.amount_id = amt.amount_type_id
-- WHERE u.mobile = '963933333333'
-- ORDER BY t.sent_at DESC;

-- Find unused winning barcodes
-- SELECT barcode_id FROM barcodes WHERE winner = true AND is_used = false LIMIT 10;

-- Check system statistics
-- SELECT 
--     (SELECT COUNT(*) FROM users WHERE deleted_at IS NULL) as total_users,
--     (SELECT COUNT(*) FROM barcodes) as total_barcodes,
--     (SELECT COUNT(*) FROM barcodes WHERE winner = true) as winning_barcodes,
--     (SELECT COUNT(*) FROM barcodes WHERE is_used = true) as used_barcodes,
--     (SELECT COUNT(*) FROM transitions) as total_transitions,
--     (SELECT COUNT(*) FROM transitions WHERE is_success = true) as successful_transitions,
--     (SELECT SUM(points) FROM users WHERE deleted_at IS NULL) as total_points_in_system;

-- ============================================================
-- DONE! Your test data is ready.
-- Now you can use the Postman collection to test all endpoints.
-- ============================================================

SELECT '✅ Test data setup completed successfully!' as Status;
SELECT 'Check the verification queries above for a summary of created data.' as Note;
SELECT 'Use the barcode IDs listed above in your Postman collection.' as Tip;



