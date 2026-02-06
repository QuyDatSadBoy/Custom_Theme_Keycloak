# Project Guidelines

Keycloakify v11 — React + TypeScript + Vite. Build custom Keycloak login themes → `.jar`.

## 📚 Documentation Workflow

**⚠️ CRITICAL: ALWAYS read documentation BEFORE working on Keycloakify tasks!**

### Step-by-Step Workflow

1. **Start with TOC** → Read [TABLE_OF_CONTENTS.md](../Guide_Keycloak_From_Docs/TABLE_OF_CONTENTS.md)
   - Understand what's covered in guide (2357 lines)
   - Get line numbers for relevant sections
   
2. **Jump to Relevant Section** → Use line numbers to read specific content
   ```bash
   # Example: Need CSS customization info
   # TOC shows: Section 3 (lines 107-228)
   code Guide_Keycloak_From_Docs/KEYCLOAKIFY_COMPLETE_GUIDE.md:107
   ```

3. **If Info NOT in Guide** → Search externally
   - **Official Docs**: https://docs.keycloakify.dev/ (primary source)
   - **Context7**: Latest API updates
   - **Web Search**: Community solutions
   - **Always cite source** with URL

4. **Reference Line Numbers** in responses
   ```markdown
   ✅ Good: "For CSS customization, see Section 3 (lines 107-228)"
   ❌ Bad: "The guide mentions CSS customization somewhere"
   ```

### Documentation Files

- **[KEYCLOAKIFY_COMPLETE_GUIDE.md](../Guide_Keycloak_From_Docs/KEYCLOAKIFY_COMPLETE_GUIDE.md)** (2357 lines) — Complete Vietnamese guide
  - All setup, CSS, testing, i18n, advanced features
  - FAQ with 7 common questions
  - Compiler options reference (Appendix A)
  
- **[TABLE_OF_CONTENTS.md](../Guide_Keycloak_From_Docs/TABLE_OF_CONTENTS.md)** — Navigation index
  - Section summaries with line numbers
  - "What's covered" vs "Search externally" guide
  - AI agent lookup strategy

- **This file** — Coding conventions & quick reference

---

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

---

## Advanced Features

For detailed guides on advanced Keycloakify features, see [KEYCLOAKIFY_COMPLETE_GUIDE.md](../Guide_Keycloak_From_Docs/KEYCLOAKIFY_COMPLETE_GUIDE.md):

- **Dark Mode Persistence** (Section 6.6, lines 701-788) — App ↔ Login theme communication
- **Theme Variants** (Section 8.1, lines 1040-1088) — Multiple themes from single codebase
- **Environment Variables** (Section 8.2, lines 1090-1165) — Pass env vars to theme
- **Account Theme** (Section 10.2, lines 1469-1515) — Single-Page vs Multi-Page
- **Email Theme** (Section 10.3, lines 1517-1558) — jsx-email vs FreeMarker
- **Admin Theme** (Section 10.4, lines 1560-1577) — Custom Admin Console
- **Compiler Options** (Appendix A, lines 2227-2342) — Complete reference table

Quick reference:
```bash
npx keycloakify initialize-account-theme  # Account theme setup
npx keycloakify initialize-email-theme    # Email theme setup
npx keycloakify initialize-admin-theme    # Admin theme setup (React only)
```

---

## Resources

- 📘 [KEYCLOAKIFY_COMPLETE_GUIDE.md](../Guide_Keycloak_From_Docs/KEYCLOAKIFY_COMPLETE_GUIDE.md) - Chi tiết đầy đủ (2357 lines)
- 📖 [docs.keycloakify.dev](https://docs.keycloakify.dev) - Official docs
- 💬 [Discord](https://discord.gg/kYFZG7fQmn) - Community support

