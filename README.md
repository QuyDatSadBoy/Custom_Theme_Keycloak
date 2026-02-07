# Keycloak Custom Theme - MIC ACE

Custom login theme cho Keycloak, build bằng [Keycloakify](https://keycloakify.dev) v11 (React + TypeScript + Vite).

## Yêu cầu

- Node.js >= 18
- Maven + Java (`sudo apt-get install maven`)
- Docker

## 1. Build theme

```bash
npm install
npm run build-keycloak-theme
```

Output: `dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar`

## 2. Build Docker image

```bash
docker build -t keycloak-micace-theme .
```

## 3. Chạy

### Option A: Dev nhanh (không cần DB)

```bash
docker run --rm -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
  keycloak-micace-theme start-dev
```

### Option B: Compose + PostgreSQL có sẵn

Sửa `.env` cho đúng config DB, rồi:

```bash
docker compose up
```

## 4. Kích hoạt theme

1. Vào http://localhost:8080/admin
2. Login `admin` / `admin`
3. Tạo hoặc chọn Realm (không dùng master)
4. **Realm Settings → Themes → Login Theme → keycloakify-starter**

## Dev & Preview

```bash
npm run storybook    # Preview trên port 6006
```
