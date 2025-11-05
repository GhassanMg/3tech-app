# 🚀 Quick Start - API Testing

## 📦 What You Got

I've created a complete testing package for your 3obadi Rewards Platform:

1. **`3obadi_postman_collection.json`** - Full Postman collection with all endpoints
2. **`POSTMAN_TESTING_GUIDE.md`** - Comprehensive testing guide
3. **`test_data_setup.sql`** - SQL script to create test data
4. **`TESTING_QUICKSTART.md`** - This file (quick reference)

---

## ⚡ Super Quick Setup (5 minutes)

### Step 1: Setup Database
```bash
# Run your server to create tables
npm run start:dev

# Then run the test data script
mysql -u your_username -p your_database < test_data_setup.sql
```

### Step 2: Import Postman Collection
1. Open Postman
2. Click **Import** → Select `3obadi_postman_collection.json`
3. Done!

### Step 3: Start Testing
1. Go to **Authentication** → **Signup - Syriatel User**
2. Click **Send** (creates user)
3. Go to **Authentication** → **Login**
4. Click **Send** (JWT token auto-saved)
5. Now test any endpoint! 🎉

---

## 🎯 Top 5 Tests to Run First

### 1️⃣ Create User & Login
```
POST /api/v1/auth/signup
POST /api/v1/auth/login ← Token auto-saved
```

### 2️⃣ Check Points Balance
```
GET /api/v1/transitions/points
```

### 3️⃣ Scan a Winning Barcode
```
POST /api/v1/barcodes/consume
Body: { "code": "WIN-POINTS-100-001" }
```

### 4️⃣ Check Points Again (Should Increase)
```
GET /api/v1/transitions/points
```

### 5️⃣ View Barcode History
```
GET /api/v1/barcodes
```

---

## 🎁 Test Barcodes Created for You

After running `test_data_setup.sql`, you'll have:

### ✅ Winning Barcodes (Use these!)
- `WIN-POINTS-100-001` → Win 100 points
- `WIN-POINTS-100-002` → Win 100 points
- `WIN-POINTS-500-001` → Win 500 points
- `WIN-DISCOUNT-001` → Win discount code "SAVE20"
- `WIN-PHYSICAL-001` → Win T-Shirt prize

### ❌ Non-Winning Barcodes
- `LOSE-001` → Returns "حظ أوفر" (Better luck next time)
- `LOSE-002` → Returns "حظ أوفر"

### 🚫 Already Used (Test errors)
- `USED-001` → Returns "مستخدم من قبل" (Already used)

---

## 🔐 Authentication Flow

```
1. Signup → Creates user
   ↓
2. Login → Returns JWT token (auto-saved to {{jwt_token}})
   ↓
3. All protected endpoints automatically use {{jwt_token}}
   ↓
4. Token expires? → Just re-run Login
```

---

## 📊 Complete Flow Test

Follow this sequence to test the entire system:

```mermaid
User Signup → Login → Check Points (0) → 
Scan Winning Barcode → Check Points (+100) →
View Barcode History → Start Recharge →
Check Points (decreased) → View Transaction History
```

**In Postman:**
1. Auth → Signup
2. Auth → Login
3. Transitions → Get User Points (0)
4. Barcodes → Consume Barcode (`WIN-POINTS-100-001`)
5. Transitions → Get User Points (100)
6. Barcodes → Get My Scanned Barcodes
7. Transitions → Start Recharge (amount: 100)
8. Transitions → Get User Points (0)
9. Transitions → Get Transition History

---

## 🎨 Award Types

Your barcodes can award 3 different prize types:

### 🪙 Points
```json
{
  "award_type": "points",
  "points_awarded": "100",
  "total_points": 100
}
```
→ Points added to user balance

### 🎫 Discount Code
```json
{
  "award_type": "discount",
  "discount_code": "SAVE20",
  "message": "Discount code: SAVE20"
}
```
→ User receives discount code

### 🎁 Physical Prize
```json
{
  "award_type": "physical",
  "prize_name": "T-Shirt",
  "message": "Congratulations! You won: T-Shirt"
}
```
→ User wins physical item

---

## 📱 Mobile Number Formats

The API accepts both formats:

| You Send | System Stores | Provider Detected |
|----------|---------------|-------------------|
| `0933333333` | `963933333333` | Syriatel |
| `0944444444` | `963944444444` | MTN |
| `963933333333` | `963933333333` | Syriatel |

**SIM Provider Detection:**
- 4th digit is **3, 8, or 9** → Syriatel
- 4th digit is **anything else** → MTN

---

## 🛠️ Troubleshooting

### "401 Unauthorized"
→ Run the **Login** request again to refresh token

### "Barcode doesn't exist"
→ Use barcodes from `test_data_setup.sql` (WIN-POINTS-100-001, etc.)

### "Invalid amount type"
→ Use amounts: 500, 1000, 2000, 5000 (from amount_types table)

### "Not enough points"
→ Scan winning barcodes first, or manually add points:
```sql
UPDATE users SET points = 5000 WHERE mobile = '963933333333';
```

### "User already exists"
→ Change mobile number or delete user:
```sql
DELETE FROM users WHERE mobile = '963933333333';
```

---

## 🎓 Pro Tips

1. **Collection Variables**: All URLs use `{{base_url}}` - change once, applies everywhere
2. **Auto Token**: JWT token saves automatically after login - no copy/paste needed
3. **Test Scripts**: Login request has auto-save script built-in
4. **Folders**: Endpoints organized by module (Auth, Users, Barcodes, Transitions)
5. **Workflows**: Use "Testing Workflows" folder for pre-configured test sequences

---

## 📚 Full Documentation

For detailed information, see:
- **`POSTMAN_TESTING_GUIDE.md`** - Complete testing guide with all scenarios
- **`test_data_setup.sql`** - Database setup with comments
- **Project Analysis Report** - Full system documentation

---

## 🚀 Quick Commands

```bash
# Start server
npm run start:dev

# Setup test data
mysql -u root -p nest_3obadi < test_data_setup.sql

# Check if server is running
curl http://localhost:3000

# View test barcodes
mysql -u root -p nest_3obadi -e "SELECT barcode_id, winner, is_used FROM barcodes WHERE barcode_id LIKE 'WIN-%';"
```

---

## ✅ Testing Checklist

- [ ] Server running on port 3000
- [ ] Database has test data (run SQL script)
- [ ] Postman collection imported
- [ ] Signup works
- [ ] Login works (token auto-saved)
- [ ] Can consume winning barcode
- [ ] Points increase after winning
- [ ] Can view barcode history
- [ ] Can check points balance
- [ ] Can start recharge (if have points)

---

## 🎯 Success!

If you can complete all items in the checklist above, your API is fully functional and ready for production! 🎉

---

**Need Help?**
- Check `POSTMAN_TESTING_GUIDE.md` for detailed scenarios
- Review server logs in terminal
- Check Postman Console (View → Show Postman Console)
- Verify database data with SQL queries in `test_data_setup.sql`

---

**Happy Testing! 🚀**



