# Project Guidelines

Keycloakify v11 — React + TypeScript + Vite. Build custom Keycloak login themes → `.jar`.

## Architecture

- `src/kc.gen.tsx` — **auto-generated, KHÔNG sửa**
- `src/main.tsx` — entrypoint, render `KcPage` khi có `window.kcContext`
- `src/login/KcPage.tsx` — router theo `kcContext.pageId`, thêm `case` để custom page
- `src/login/KcContext.ts` — mở rộng type `KcContextExtension`
- `src/login/KcPageStory.tsx` — mock context cho Storybook
- `src/login/i18n.ts` — cấu hình i18n (`.withCustomTranslations()`, `.withExtraLanguages()`)

## Commands

```bash
yarn install                        # Cài dependencies
yarn dev                            # Dev server (cần mock kcContext trong main.tsx)
yarn build                          # TypeScript check + Vite build
npm run build-keycloak-theme        # Build → .jar trong dist_keycloak/
npm run storybook                   # Storybook trên port 6006
yarn format                         # Prettier
```

### Keycloakify CLI (luôn dùng `npx`)

```bash
npx keycloakify eject-page              # Eject page component để custom sâu
npx keycloakify add-story               # Tạo Storybook story cho page
npx keycloakify start-keycloak          # Chạy Keycloak Docker với theme
npx keycloakify initialize-account-theme # Khởi tạo account theme
npx keycloakify initialize-email-theme   # Khởi tạo email theme
npx keycloakify update-kc-gen           # Regenerate kc.gen.tsx
```

Build `.jar` cần **Maven** + **Java**: `sudo apt-get install maven`

## Conventions

- **Không sửa `kc.gen.tsx`** — file auto-generated
- Custom page: thêm `case "xxx.ftl"` trong switch ở `KcPage.tsx`
- Story pattern: `createKcPageStory({ pageId: "xxx.ftl" })`
- CSS classes: `satisfies { [key in ClassKey]?: string }`
- Dev preview: uncomment mock block trong `main.tsx`, comment lại trước khi build

## Workflow custom page

1. `npx keycloakify eject-page` → chọn page
2. Thêm `case` trong `KcPage.tsx`
3. `npx keycloakify add-story` → tạo story
4. `npm run storybook` → preview
5. `npx keycloakify start-keycloak` → test thật
6. `npm run build-keycloak-theme` → build `.jar`

## Deployment

- Docker: mount `.jar` vào `/opt/keycloak/providers/`
- CI: `.github/workflows/ci.yaml` — bump version trong `package.json` → auto release `.jar`

## Security

- Không commit credentials hay realm secrets
- Env vars dùng pattern `kcEnvNames` / `kcEnvDefaults`

## Browser Automation (Chrome DevTools / Puppeteer / Playwright)

🚨 **QUAN TRỌNG**: CHỈ kill automation browser, KHÔNG kill browser user đang dùng!

### Cách Phân Biệt Browser Processes

```bash
# 1️⃣ List tất cả Chrome processes
ps aux | grep -i chrome | grep -v grep

# Output example:
# user  370434  ... node /path/chrome-devtools-mcp    ← Automation browser
# user  361127  ... /opt/google/chrome/chrome         ← User's Chrome (DON'T TOUCH)
```

### ✅ SAFE: Kill ONLY Automation Browser

```bash
# Step 1: Find automation process PID
ps aux | grep -i "chrome-devtools-mcp\|puppeteer\|playwright" | grep -v grep | awk '{print $2}'

# Step 2: Kill specific PID (ví dụ: 370434)
kill -9 370434
```

**Dấu hiệu nhận biết automation browser**:
- Process name chứa: `chrome-devtools-mcp`, `puppeteer`, `playwright`, `selenium`
- Parent process là Node.js hoặc testing framework
- Command line có `--remote-debugging-port`, `--headless`, etc.

### ❌ DANGEROUS: Commands to AVOID

```bash
pkill -f chrome       # ❌ Kills ALL Chrome (user mất hết 50+ tabs!)
killall chrome        # ❌ Same problem
killall -9 chrome     # ❌ Force kill ALL Chrome
```

**Why dangerous**: User có thể đang work với nhiều tabs → mất hết progress!

### When to Kill Automation Browser

- ✅ After finishing browser automation tasks
- ✅ When browser stuck hoặc cần restart automation
- ✅ Clean up before ending work session

### Never Kill

- ❌ User's main Chrome browser
- ❌ Chrome processes với nhiều `--type=renderer` (user tabs)
- ❌ Chrome với `--profile-directory=Default` (user profile)

## Git Workflow

⚠️ **QUY TẮC**: KHÔNG được tự ý commit code!

### Allowed Actions

- ✅ `git status` - Check file changes
- ✅ `git diff` - Review changes
- ✅ `git add <file>` - Stage files (nếu user yêu cầu)
- ✅ Show git commands for user to run

### Forbidden Actions

- ❌ `git commit` - NEVER commit without explicit permission
- ❌ `git push` - NEVER push to remote
- ❌ `git merge` - NEVER merge branches automatically
- ❌ `git rebase` - NEVER rebase without permission

**Why**: User cần review changes trước khi commit. Commit message phải meaningful và có context.

## Advanced Features

### Dark Mode Persistence

Pass theme state từ app sang login theme qua query params:

```tsx
// App redirects to Keycloak
window.location.href = keycloakLoginUrl + "?kc_theme_name=dark";
```

Read trong theme:
```tsx
const isDark = kcContext.themeProperties?.darkMode === "true";
```

📖 Chi tiết: [KEYCLOAKIFY_COMPLETE_GUIDE.md#66-dark-mode-persistence]

### Theme Variants

Build nhiều theme variants từ 1 codebase (ví dụ: light/dark, brand A/B):

```ts
// vite.config.ts
keycloakify({
  themeName: ["my-theme-light", "my-theme-dark"]
})
```

📖 Chi tiết: [KEYCLOAKIFY_COMPLETE_GUIDE.md#81-theme-variants]

### Environment Variables

Pass env vars từ Keycloak server vào theme:

```ts
// vite.config.ts
keycloakify({
  environmentVariables: [
    { name: "API_URL", default: "https://api.example.com" }
  ]
})
```

Access trong theme: `import.meta.env.API_URL`

📖 Chi tiết: [KEYCLOAKIFY_COMPLETE_GUIDE.md#82-environment-variables]

### Account Theme

**2 loại:**
- **Single-Page** (account v3) - Keycloak 25+, backward compatible, React router
- **Multi-Page** (account v1) - Traditional, maintained by Keycloakify

```bash
npx keycloakify initialize-account-theme
# Chọn: single-page (recommended) hoặc multi-page
```

📖 Chi tiết: [KEYCLOAKIFY_COMPLETE_GUIDE.md#102-account-theme]

### Email Theme

**2 approaches:**

1. **keycloakify-emails plugin** (jsx-email, Vite-only):
```bash
npm install keycloakify-emails jsx-email
```

2. **Native FreeMarker**:
```bash
npx keycloakify initialize-email-theme
```

Assets: `src/email/resources/` → reference với `${url.resourcesUrl}/file.png`

📖 Chi tiết: [KEYCLOAKIFY_COMPLETE_GUIDE.md#103-email-theme]

### Admin Theme

Custom Keycloak Admin Console UI (React only):

```bash
npx keycloakify initialize-admin-theme
```

📖 Chi tiết: [KEYCLOAKIFY_COMPLETE_GUIDE.md#104-admin-theme]

## Resources

- 📘 [KEYCLOAKIFY_COMPLETE_GUIDE.md](../KEYCLOAKIFY_COMPLETE_GUIDE.md) - Chi tiết đầy đủ (2200+ lines)
- 📖 [docs.keycloakify.dev](https://docs.keycloakify.dev) - Official docs
- 💬 [Discord](https://discord.gg/kYFZG7fQmn) - Community support
