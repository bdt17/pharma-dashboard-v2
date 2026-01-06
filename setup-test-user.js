const fs = require('fs');
const path = require('path');

const TEST_USERS_FILE = path.join(__dirname, 'test-users.json');
const DEFAULT_TEST_USER = {
  username: 'testuser',
  password: 'Pharma2026!',
  email: 'test@pharmatransport.org',
  role: 'tester',
  created: new Date().toISOString()
};

// Load or create test users
function ensureTestUser() {
  try {
    if (fs.existsSync(TEST_USERS_FILE)) {
      const users = JSON.parse(fs.readFileSync(TEST_USERS_FILE, 'utf8'));
      const testUser = users.find(u => u.username === DEFAULT_TEST_USER.username);
      if (testUser) {
        console.log('✅ Test user exists:', testUser.username);
        return testUser;
      }
    }
    
    // Create test users file
    const testUsers = [DEFAULT_TEST_USER];
    fs.writeFileSync(TEST_USERS_FILE, JSON.stringify(testUsers, null, 2));
    console.log('✅ Created test user:', DEFAULT_TEST_USER.username);
    console.log('📧 Email:', DEFAULT_TEST_USER.email);
    console.log('🔑 Password:', DEFAULT_TEST_USER.password);
    return DEFAULT_TEST_USER;
    
  } catch (error) {
    console.error('❌ Error setting up test user:', error.message);
    process.exit(1);
  }
}

// API endpoint for login check
function setupTestLogin(app) {
  app.post('/api/auth/test-login', (req, res) => {
    const { username, password } = req.body;
    const users = JSON.parse(fs.readFileSync(TEST_USERS_FILE, 'utf8'));
    const user = users.find(u => u.username === username && u.password === password);
    
    if (user) {
      res.json({ 
        success: true, 
        user: { username: user.username, role: user.role },
        message: 'Test login successful',
        dashboard: '/api/v1/dashboard'
      });
    } else {
      res.status(401).json({ success: false, message: 'Invalid test credentials' });
    }
  });
}

if (require.main === module) {
  console.log('🚀 Running test user setup...');
  ensureTestUser();
}

module.exports = { ensureTestUser, setupTestLogin };
