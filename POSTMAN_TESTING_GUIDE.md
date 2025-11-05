# 🧪 Postman Testing Guide - 3obadi Rewards Platform

## 📥 **Import the Collection**

1. Open Postman
2. Click **Import** button (top left)
3. Select the file: `3obadi_postman_collection.json`
4. Click **Import**

---

## ⚙️ **Setup & Configuration**

### **Collection Variables**

The collection includes these pre-configured variables:

| Variable | Default Value | Description |
|----------|--------------|-------------|
| `base_url` | `http://localhost:3000` | Your server URL |
| `jwt_token` | (auto-filled) | JWT token from login |
| `test_mobile` | `963933333333` | Test mobile number |
| `test_password` | `Test@123456` | Test password |

### **How to Update Variables**

1. Click on the collection name
2. Go to **Variables** tab
3. Update the **Current Value** column
4. Click **Save**

---

## 🚀 **Quick Start - Testing Flow**

### **Step 1: Start Your Server**

```bash
npm run start:dev
```

Ensure your server is running on `http://localhost:3000`

### **Step 2: Create a Test User**

1. Navigate to **Authentication** → **Signup - Syriatel User**
2. Click **Send**
3. You should receive a `200` or `201` response with user details

### **Step 3: Login**

1. Navigate to **Authentication** → **Login**
2. Click **Send**
3. **The JWT token will be automatically saved** to `{{jwt_token}}`
4. All subsequent authenticated requests will use this token

### **Step 4: Test Protected Endpoints**

Now you can test any protected endpoint like:
- **Barcodes** → Get My Scanned Barcodes
- **Transitions** → Get User Points Balance

---

## 📋 **Testing Checklist**

### ✅ **Authentication Module**

- [ ] Signup with Syriatel number (9639[3,8,9]xxxxxxx)
- [ ] Signup with MTN number (963944444444)
- [ ] Signup with short format (0933333333)
- [ ] Login with correct credentials
- [ ] Login with incorrect credentials (should fail)
- [ ] Request password reset
- [ ] Reset password with code
- [ ] Reset password with wrong code (should fail)

### ✅ **Users Module**

- [ ] Delete account with correct password
- [ ] Delete account with wrong password (should fail)
- [ ] Try to login after deletion (should fail)
- [ ] Re-signup with deleted account (should restore)

### ✅ **Barcodes Module**

**Prerequisites:** You need actual barcodes in your database. Use the admin endpoint or insert via SQL.

- [ ] Consume valid winning barcode
- [ ] Consume valid non-winning barcode (should return "حظ أوفر")
- [ ] Consume already used barcode (should fail)
- [ ] Consume non-existent barcode (should fail)
- [ ] Get my scanned barcodes
- [ ] Redeem barcode by phone number
- [ ] Redeem barcode immediately
- [ ] Generate barcodes (ADMIN ONLY)

### ✅ **Transitions Module**

**Prerequisites:** 
1. User must have points (scan winning barcodes first)
2. `amount_types` table must have valid amounts

- [ ] Check user points balance
- [ ] Start recharge with sufficient points
- [ ] Start recharge with insufficient points (should fail)
- [ ] Start recharge with invalid amount (should fail)
- [ ] Get transition history
- [ ] Verify points deducted after successful recharge

---

## 🧩 **Database Setup for Testing**

### **Required Database Entries**

#### **1. Create Amount Types**
```sql
INSERT INTO amount_types (amount, is_active) VALUES
(500, true),
(1000, true),
(2000, true),
(5000, true);
```

#### **2. Create Test Agent**
```sql
INSERT INTO agents (agent_name, agent_logo, agent_primary_color) VALUES
('Test Agent', 'https://via.placeholder.com/150', '#FF5733');
```

#### **3. Create Test Awards**
```sql
-- Points Award
INSERT INTO awards (award_type, award_value, percentage, award_description) VALUES
('points', '100', 50, 'Win 100 points!');

-- Discount Award
INSERT INTO awards (award_type, award_value, percentage, award_description) VALUES
('discount', 'DISCOUNT20', 30, 'Get 20% discount code');

-- Physical Award
INSERT INTO awards (award_type, award_value, percentage, award_description) VALUES
('physical', 'iPhone 15 Pro', 20, 'Win an iPhone 15 Pro!');
```

#### **4. Create Test Barcodes**
```sql
-- Winner barcode (with points)
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('test-barcode-001', 1, 1, true, false, false);

-- Non-winner barcode
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('test-barcode-002', 1, 1, false, false, false);

-- Winner barcode (with discount)
INSERT INTO barcodes (barcode_id, agent_id, award_id, winner, is_used, is_redeemed) VALUES
('test-barcode-003', 1, 2, true, false, false);
```

---

## 🎯 **Test Scenarios**

### **Scenario 1: Complete User Journey**

Use the **Testing Workflows** → **Complete User Flow** folder. Run requests in order:

1. ✅ Signup → Creates new user
2. ✅ Login → Gets JWT token (auto-saved)
3. ✅ Check Points → Shows initial points (0)
4. ✅ Scan Barcode → Replace with valid UUID from DB
5. ✅ View My Barcodes → Shows scanned history

### **Scenario 2: Points & Recharge Flow**

1. Login as user with points
2. GET `/api/v1/transitions/points` → Check balance
3. POST `/api/v1/transitions/start` with `amount: 500`
4. GET `/api/v1/transitions/points` → Verify points deducted
5. GET `/api/v1/transitions` → Check transaction history

### **Scenario 3: Barcode Award Types**

Test all three award types:

**A. Points Award:**
```json
// Consume barcode with award_type = 'points'
POST /api/v1/barcodes/consume
{
  "code": "test-barcode-001"
}

// Expected Response:
{
  "agent": "Test Agent",
  "award_type": "points",
  "points_awarded": "100",
  "total_points": 100,
  "message": "You have been awarded 100 points!"
}
```

**B. Discount Award:**
```json
// Consume barcode with award_type = 'discount'
POST /api/v1/barcodes/consume
{
  "code": "test-barcode-003"
}

// Expected Response:
{
  "agent": "Test Agent",
  "award_type": "discount",
  "discount_code": "DISCOUNT20",
  "message": "Discount code: DISCOUNT20",
  "instructions": "Use this code at checkout to get your discount"
}
```

**C. Physical Prize:**
```json
// Consume barcode with award_type = 'physical'
POST /api/v1/barcodes/consume
{
  "code": "test-barcode-004"
}

// Expected Response:
{
  "agent": "Test Agent",
  "award_type": "physical",
  "prize_name": "iPhone 15 Pro",
  "message": "Congratulations! You won: iPhone 15 Pro",
  "instructions": "Contact us to arrange prize collection"
}
```

### **Scenario 4: Admin Functions**

1. Create admin user in database:
```sql
UPDATE users SET role = 'ADMIN' WHERE mobile = '963933333333';
```

2. Login as admin
3. POST `/api/v1/barcodes/generate`
```json
{
  "count": 100,
  "agent_id": 1,
  "award_id": 1
}
```
4. Check your project root for `output_*.xlsx` file

---

## 🔍 **Common Issues & Solutions**

### **Issue 1: JWT Token Not Working**

**Symptom:** Getting `401 Unauthorized` on protected routes

**Solution:**
1. Re-run the Login request
2. Check that `{{jwt_token}}` variable is populated
3. Verify token in Headers: `Authorization: Bearer {{jwt_token}}`

### **Issue 2: Barcode Not Found**

**Symptom:** "The requested barcode doesn't exist"

**Solution:**
- Make sure you have barcodes in your database
- Use actual UUID from `barcodes` table
- Run the SQL inserts from "Database Setup" section above

### **Issue 3: Invalid Amount Type**

**Symptom:** "Invalid amount type" when starting recharge

**Solution:**
- Insert amount types into `amount_types` table
- Use only amounts that exist in the table (500, 1000, 2000, 5000)

### **Issue 4: User Already Exists**

**Symptom:** "User already exist" on signup

**Solution:**
- Use a different mobile number
- Or delete the user: `DELETE FROM users WHERE mobile = '963933333333'`
- Or use soft-deleted user (will auto-restore)

### **Issue 5: Not Enough Points**

**Symptom:** "User Doesn't Have Enough Points"

**Solution:**
1. Scan winning barcodes first to earn points
2. Or manually add points: 
```sql
UPDATE users SET points = 5000 WHERE mobile = '963933333333';
```

---

## 📊 **Response Status Codes**

| Code | Meaning | Common Causes |
|------|---------|---------------|
| 200 | Success | Request completed successfully |
| 201 | Created | User/resource created |
| 400 | Bad Request | Validation error, invalid data |
| 401 | Unauthorized | Missing/invalid JWT token |
| 403 | Forbidden | Insufficient permissions (not admin) |
| 404 | Not Found | User/barcode not found |
| 409 | Conflict | User already exists, barcode already used |
| 500 | Server Error | Internal server error, check logs |

---

## 🔧 **Advanced Testing**

### **Environment Setup**

Create separate environments for:

**Development:**
- base_url: `http://localhost:3000`
- test_mobile: `963933333333`

**Staging:**
- base_url: `https://staging.3obadi.com`
- test_mobile: `963944444444`

**Production:**
- base_url: `https://api.3obadi.com`
- test_mobile: (use real account)

### **Automated Testing with Newman**

Install Newman (Postman CLI):
```bash
npm install -g newman
```

Run collection:
```bash
newman run 3obadi_postman_collection.json
```

### **Collection Runner**

1. Click **Runner** in Postman
2. Select "3obadi Rewards Platform API"
3. Select requests to run
4. Click **Run 3obadi Rewards Platform API**
5. View results

---

## 📝 **Test Data Management**

### **Test Users**

| Mobile | Password | Role | SIM Provider | Use Case |
|--------|----------|------|--------------|----------|
| 963933333333 | Test@123456 | USER | Syriatel | General testing |
| 963944444444 | Test@123456 | USER | MTN | MTN testing |
| 963988888888 | Admin@123 | ADMIN | Syriatel | Admin functions |

### **Test Barcodes**

Create a set of test barcodes for different scenarios:
- Winning barcodes (winner=true)
- Non-winning barcodes (winner=false)
- Used barcodes (is_used=true)
- Redeemed barcodes (is_redeemed=true)

---

## 🎓 **Tips & Best Practices**

1. **Always start with Login** - Most endpoints require authentication
2. **Use Variables** - Leverage `{{jwt_token}}`, `{{test_mobile}}` for reusability
3. **Check Console** - Postman console shows detailed request/response info
4. **Save Responses** - Save example responses for documentation
5. **Test Edge Cases** - Try invalid inputs, expired tokens, etc.
6. **Monitor Responses** - Use Tests tab to add assertions
7. **Use Environments** - Switch between dev/staging/prod easily

---

## 🐛 **Debugging**

### **Enable Verbose Logging**

1. Open Postman Console (View → Show Postman Console)
2. Make requests
3. See detailed logs including headers, body, timing

### **Check Server Logs**

Your NestJS server logs will show:
- Incoming requests (LoggerMiddleware)
- Database queries (TypeORM)
- Errors and stack traces

### **Database Verification**

After each test, verify in database:
```sql
-- Check user points
SELECT mobile, points FROM users WHERE mobile = '963933333333';

-- Check barcode usage
SELECT barcode_id, is_used, winner FROM barcodes WHERE barcode_id = 'test-barcode-001';

-- Check transitions
SELECT * FROM transitions ORDER BY sent_at DESC LIMIT 5;
```

---

## ✅ **Success Criteria**

You've successfully tested the API when:

- [x] Users can signup and login
- [x] JWT authentication works
- [x] Barcodes can be scanned and consumed
- [x] Points are awarded correctly
- [x] Points can be redeemed for mobile recharge
- [x] All three award types work (points, discount, physical)
- [x] Admin can generate barcodes
- [x] Soft delete works correctly
- [x] Password reset flow works

---

## 📞 **Support**

If you encounter issues:

1. Check the server is running
2. Verify database has required data
3. Check Postman Console for errors
4. Review server logs
5. Verify JWT token is valid and not expired

---

**Happy Testing! 🚀**



