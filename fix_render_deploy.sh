#!/bin/bash
echo "🔧 Restoring missing Rails files..."
cp root_backup_*/Gemfile* ./
cp root_backup_*/Rakefile ./ 2>/dev/null || touch Rakefile
cp root_backup_*/config.ru ./ 2>/dev/null || true
cat > Rakefile << 'RAKEEOF'
require_relative "config/application"
Rails.application.load_tasks
RAKEEOF
cat > bin/render-build.sh << 'BUILD'
#!/usr/bin/env bash
set -e
bundle install --without development test
rm -rf public/assets tmp/cache
RAILS_ENV=production bundle exec rails assets:precompile
echo "✅ Rails 8 pharma dashboard ready"
BUILD
chmod +x bin/render-build.sh
git add . && git commit -m "Fix Render: restore Gemfile/Rakefile" && git push origin main
