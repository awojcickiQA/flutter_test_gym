#!/bin/bash
# ==============================================================================
# Skrypt uruchamiania testów Appium dla aplikacji Flutter Test Gym
# ==============================================================================

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR"

# Eksport ścieżek Android SDK
if [ -z "$ANDROID_HOME" ]; then
    if [ -d "$HOME/Library/Android/sdk" ]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
    elif [ -d "/usr/local/lib/android/sdk" ]; then
        export ANDROID_HOME="/usr/local/lib/android/sdk"
    elif [ -d "/Users/arturwojcicki/Library/Android/sdk" ]; then
        export ANDROID_HOME="/Users/arturwojcicki/Library/Android/sdk"
    fi
fi
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"
if [ -n "$ANDROID_HOME" ]; then
    export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
fi

# Weryfikacja i automatyczne uruchomienie serwera Appium w razie potrzeby
check_appium_server() {
    if ! nc -z 127.0.0.1 4723 2>/dev/null; then
        echo "⚡ Serwer Appium nie jest uruchomiony na porcie 4723. Uruchamianie w tle..."
        nohup appium --port 4723 --base-path / > /tmp/appium.log 2>&1 &
        local APPIUM_PID=$!
        echo "⏳ Oczekiwanie na gotowość serwera Appium (PID: $APPIUM_PID)..."
        local RETRIES=15
        while [ $RETRIES -gt 0 ]; do
            if nc -z 127.0.0.1 4723 2>/dev/null; then
                echo "✅ Serwer Appium jest gotowy!"
                break
            fi
            sleep 1
            RETRIES=$((RETRIES - 1))
        done
        if [ $RETRIES -le 0 ]; then
            echo "❌ Nie udało się uruchomić serwera Appium. Sprawdź log w /tmp/appium.log"
            exit 1
        fi
    else
        echo "✅ Serwer Appium działa na porcie 4723."
    fi
}

check_appium_server

# Aktywacja wirtualnego środowiska Python
if [ -d ".venv" ]; then
    source .venv/bin/activate
elif command -v pytest >/dev/null 2>&1; then
    echo "ℹ️ Używanie aktywnego/systemowego środowiska Python z zainstalowanym pytest."
else
    echo "❌ Środowisko .venv nie istnieje i nie znaleziono polecenia pytest. Zainstaluj zależności wpisując:"
    echo "   python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"
    exit 1
fi

PLATFORM="android"
MARKER=""
EXTRA_ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --platform|-p)
            PLATFORM="$2"
            shift 2
            ;;
        --marker|-m)
            MARKER="$2"
            shift 2
            ;;
        --help|-h)
            echo "Użycie: ./run_tests.sh [opcje] [argumenty pytest]"
            echo "Opcje:"
            echo "  -p, --platform <android|ios>   Wybór platformy (domyślnie: android)"
            echo "  -m, --marker <nazwa_markera>   Uruchomienie testów z danym markerem (np. smoke, shop, forms)"
            echo "  --help, -h                     Pomoc"
            echo ""
            echo "Dostępne markery w pytest.ini:"
            echo "  smoke, navigation, forms, gestures, lists, async_arena, overlays, shop, device, accessibility, inspector"
            echo ""
            echo "Przykłady:"
            echo "  ./run_tests.sh --platform android -m smoke"
            echo "  ./run_tests.sh --platform ios -m shop"
            echo "  ./run_tests.sh -k test_home"
            exit 0
            ;;
        *)
            EXTRA_ARGS+=("$1")
            shift
            ;;
    esac
done

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="$REPORT_DIR/report_${PLATFORM}_${TIMESTAMP}.html"

NORMALIZED_ARGS=()
for arg in "${EXTRA_ARGS[@]}"; do
    if [[ "$arg" =~ ^test_[a-zA-Z0-9_]+\.py.* ]] && [[ ! "$arg" =~ ^tests/ ]]; then
        NORMALIZED_ARGS+=("tests/$arg")
    elif [[ "$arg" =~ ^test_[a-zA-Z0-9_]+$ ]]; then
        NORMALIZED_ARGS+=("-k" "$arg")
    else
        NORMALIZED_ARGS+=("$arg")
    fi
done

CMD=("pytest" "--platform" "$PLATFORM" "--html=$REPORT_FILE" "--self-contained-html")

if [ -n "$MARKER" ]; then
    CMD+=("-m" "$MARKER")
fi

CMD+=("${NORMALIZED_ARGS[@]}")

echo "=============================================================================="
echo "🚀 Uruchamianie testów Appium dla platformy: $PLATFORM"
if [ -n "$MARKER" ]; then
    echo "🏷️  Filtr markerów: $MARKER"
fi
echo "📊 Raport HTML: $REPORT_FILE"
echo "=============================================================================="

"${CMD[@]}"
