#!/usr/bin/env bash
set -e

MARKER="${1:-smoke}"

echo "🤖 Starting Appium server in background..."
nohup appium --port 4723 --base-path / > appium_android.log 2>&1 &
APPIUM_PID=$!
echo "Appium PID: $APPIUM_PID"

echo "⏳ Waiting for Appium server to respond on port 4723..."
for i in {1..30}; do
  if curl -s http://127.0.0.1:4723/status >/dev/null 2>&1; then
    echo "✅ Appium server is responsive!"
    break
  fi
  sleep 1
done

echo "📱 Installing debug APK on Android emulator..."
adb install -r build/app/outputs/flutter-apk/app-debug.apk

echo "🧪 Running Pytest Appium suite (marker: $MARKER)..."
cd appium_python
mkdir -p reports

PYTEST_ARGS=("--platform" "android" "--html=reports/report_android.html" "--self-contained-html")
if [ "$MARKER" != "all" ] && [ -n "$MARKER" ]; then
  PYTEST_ARGS+=("-m" "$MARKER")
fi

pytest "${PYTEST_ARGS[@]}"
