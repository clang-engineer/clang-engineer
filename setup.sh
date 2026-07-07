#!/bin/bash
# 병원 네트워크 전환 스크립트 (macOS) — 사용법은 usage() 참고
set -e

# ===== 헬퍼 =====
section() { echo "=============== $1 ==============="; }

# 설정 파일에서 주석(#)과 빈 줄을 제거
strip_conf() { grep -vE '^[[:space:]]*(#|$)' "$1"; }

usage() {
  echo "Usage: $0 <snuh|schmc> [private|public]"
  echo ""
  echo "  병원 네트워크 설정을 전환합니다. (기본: private)"
  echo ""
  echo "  private      내부망 — 고정IP + DNS + 라우팅 + hosts"
  echo "  public       외부망 — DHCP + 라우팅 삭제 + hosts 제거"
}

switch_wifi() {
  local ssid="$1" pw="${2:-}"
  section "WiFi 전환: $ssid"
  # shellcheck disable=SC2086  # pw가 비면(open 네트워크) 인자 자체를 넘기지 않아야 함
  networksetup -setairportnetwork "$WIFI_DEVICE" "$ssid" $pw \
    || echo "WiFi 전환 실패 — 건너뜁니다."
}

routes() {
  local action="$1"
  strip_conf "$PROFILE_DIR/routes.conf" | while read -r cidr _; do
    if [ "$action" = "add" ]; then
      echo "[ADD] $cidr"
      sudo route -n add -net "$cidr" "$GATEWAY" >/dev/null
    else
      echo "[DELETE] $cidr"
      sudo route delete -net "$cidr" "$GATEWAY" >/dev/null 2>&1 || true
    fi
  done
}

hosts_remove_block() {
  sudo sed -i '' "/$HOSTS_BEGIN/,/$HOSTS_END/d" /etc/hosts
}

# 내부 서버(hosts.conf 첫 항목)에 실제로 닿으면 0. Wi-Fi 연결·고정IP·라우트가
# 모두 맞아야 성공한다. networksetup은 전환 실패해도 exit 0이라, "완료" 메시지가
# 아니라 실제 도달로만 성공을 판정할 수 있다.
internal_reachable() {
  [ -f "$PROFILE_DIR/hosts.conf" ] || return 0
  local host
  host="$(strip_conf "$PROFILE_DIR/hosts.conf" | awk 'NR==1{print $1; exit}')"
  [ -n "$host" ] || return 0
  nc -z -G2 -w2 "$host" 443 >/dev/null 2>&1
}

# ===== 프로필별 동작 =====
setup_private() {
  if [ -n "${SSID_PRIVATE:-}" ]; then
    switch_wifi "$SSID_PRIVATE" "${SSID_PRIVATE_PW:-}"
  fi

  # CLI 전환은 Wi-Fi 연결·인증이 느리고 가변적이다. 연결 전에 적용하면 라우트가
  # 인터넷 인터페이스로 새므로, 내부망에 실제로 닿을 때까지 적용을 반복한다 (최대 ~30초).
  # (setmanual → route add 순서 유지: 게이트웨이를 내부 인터페이스에 먼저 잡아야 함)
  section "내부망 설정 적용 (접속될 때까지 반복)"
  [ -n "${IP_ADDR:-}" ] && echo "  고정 IP $IP_ADDR / GW $GATEWAY / DNS $DNS1, $DNS2"

  local ok=""
  for i in {1..10}; do
    if [ -n "${IP_ADDR:-}" ]; then
      sudo networksetup -setmanual "$WIFI_IF" "$IP_ADDR" "$SUBNET" "$GATEWAY"
      sudo networksetup -setdnsservers "$WIFI_IF" "$DNS1" "$DNS2"
    fi
    # 라우트는 도달의 "전제"라 매번 먼저 심는다. 라우트가 없으면 internal_reachable이
    # 항상 실패하므로 "닿을 때만 라우트 추가"는 데드락 — 길을 내야 확인되지, 확인돼야 내는 게 아님.
    # delete→add: route add는 이미 있으면 실패(재바인딩 안 됨)라, 지우고 새로 심어야
    # 연결 완성된 최신 상태(en1)로 다시 묶인다.
    routes delete >/dev/null 2>&1
    routes add >/dev/null 2>&1

    if internal_reachable; then
      ok=1
      break
    fi
    if [ "$i" -lt 10 ]; then
      echo "  ($i/10) 접속 대기..."
      sleep 3
    fi
  done

  if [ -f "$PROFILE_DIR/hosts.conf" ]; then
    section "/etc/hosts 갱신"
    hosts_remove_block
    {
      echo "$HOSTS_BEGIN"
      strip_conf "$PROFILE_DIR/hosts.conf"
      echo "$HOSTS_END"
    } | sudo tee -a /etc/hosts > /dev/null
  fi

  # 판정을 맨 끝에 — 이게 이 실행의 진짜 결론
  if [ -n "$ok" ]; then
    section "내부망 접속 확인 ✅"
  else
    section "내부망 접속 안 됨 ⚠️  — Wi-Fi가 ${SSID_PRIVATE:-내부망}에 붙는지 확인 후 다시 실행하세요."
  fi
}

setup_public() {
  if [ -n "${SSID_PUBLIC:-}" ]; then
    switch_wifi "$SSID_PUBLIC" "${SSID_PUBLIC_PW:-}"

    section "DHCP로 전환"
    sudo networksetup -setdhcp "$WIFI_IF"

    section "DNS 자동으로 전환"
    sudo networksetup -setdnsservers "$WIFI_IF" empty
  fi

  section "라우팅 삭제"
  routes delete

  if grep -q "$HOSTS_BEGIN" /etc/hosts 2>/dev/null; then
    section "/etc/hosts 블록 제거"
    hosts_remove_block
  fi

  section "${LABEL} 외부망(public) 전환 완료"
}

# ===== 메인 =====
# 인자 파싱
POSARGS=()
for arg in "$@"; do
  case "$arg" in
    -h|--help) usage; exit 0 ;;
    *)         POSARGS+=("$arg") ;;
  esac
done
set -- "${POSARGS[@]}"

if [ $# -lt 1 ]; then usage; exit 1; fi

HOSPITAL="$1"
MODE="${2:-private}"

# 프로필 로드
TOOLS_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE_DIR="$TOOLS_DIR/${HOSPITAL}"
if [ ! -d "$PROFILE_DIR" ]; then
  echo "프로필 디렉토리를 찾을 수 없습니다: $PROFILE_DIR"
  exit 1
fi
. "$PROFILE_DIR/config.env"

# 파생 값
LABEL="$(echo "$HOSPITAL" | tr '[:lower:]' '[:upper:]')"
HOSTS_BEGIN="# >>> ${LABEL}-NETWORK >>>"
HOSTS_END="# <<< ${LABEL}-NETWORK <<<"
# WIFI_IF     : networksetup 서비스 이름 (예: "Wi-Fi") — config.env에서 지정
# WIFI_DEVICE : -setairportnetwork용 BSD 장치 이름 (예: en0) — 하드웨어 포트에서 추출
WIFI_DEVICE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')"

# 실행
case "$MODE" in
  private) setup_private ;;
  public)  setup_public ;;
  *)       echo "알 수 없는 모드: $MODE"; usage; exit 1 ;;
esac
