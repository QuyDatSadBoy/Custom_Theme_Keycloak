# 📘 Hướng Dẫn Đầy Đủ Keycloakify v11

> **Tài liệu toàn diện về Keycloakify - Custom Keycloak Theme với React**
>
> Biên soạn từ [docs.keycloakify.dev](https://docs.keycloakify.dev) và Context7

---

## 📋 Mục Lục

- [1. Giới Thiệu](#1-giới-thiệu)
- [2. Quick Start](#2-quick-start)
- [3. CSS Customization](#3-css-customization)
- [4. Testing Your Theme](#4-testing-your-theme)
- [5. Deploying Your Theme](#5-deploying-your-theme)
- [6. Common Use Case Examples](#6-common-use-case-examples)
- [7. Internationalization (i18n)](#7-internationalization-i18n)
- [8. Advanced Features](#8-advanced-features)
- [9. Page-Specific Guides](#9-page-specific-guides)
- [10. Theme Types](#10-theme-types)

---

## 1. Giới Thiệu

### 1.1. Keycloakify là gì?

**Keycloakify** là một build tool mạnh mẽ cho phép bạn tạo custom Keycloak themes sử dụng các công nghệ frontend hiện đại như **React, Angular, và Svelte**.

### 1.2. Tại sao nên dùng Keycloakify?

- ✅ **Modern Frontend Stack**: Sử dụng TypeScript, React, và các thư viện styling (Tailwind, MUI, shadcn/ui, CSS)
- ✅ **Hot Reloading**: Test theme dễ dàng với hot reloading trong cả Storybook và Keycloak Docker
- ✅ **Automated Bundling**: Tự động bundle theme thành file JAR để import vào Keycloak
- ✅ **Version Compatibility**: Tương thích ngược từ Keycloak 11 và hỗ trợ các phiên bản mới (26+)
- ✅ **Real-time Validation**: Validation frontend tích hợp sẵn (ví dụ: kiểm tra độ dài password ngay lập tức)
- ✅ **Community Support**: Discord channel và GitHub issues hỗ trợ nhanh chóng

### 1.3. Framework Hỗ Trợ

| Framework | Hỗ trợ | Ghi chú |
|-----------|--------|---------|
| **React** | ⭐⭐⭐⭐⭐ | **Recommended** - Tích hợp hoàn chỉnh nhất, hỗ trợ đầy đủ Admin Theme |
| **Angular** | ⭐⭐⭐⭐ | Một số hạn chế: Account Theme UI khác mặc định, không hỗ trợ Admin Theme |
| **Svelte** | ⭐⭐⭐⭐ | Tương tự Angular |

### 1.4. Demo & Resources

- 🎨 [Storybook Demo](https://storybook.keycloakify.dev)
- 📖 [Official Docs](https://docs.keycloakify.dev)
- 💬 [Discord Community](https://discord.gg/kYFZG7fQmn)
- 🐛 [GitHub Issues](https://github.com/keycloakify/keycloakify/issues)
- 🚀 [Live Example - Neon](https://neon.tech) (click Login/Sign Up)

---

## 2. Quick Start

### 2.1. Clone Starter Project

```bash
git clone https://github.com/keycloakify/keycloakify-starter
cd keycloakify-starter
yarn install  # hoặc npm install, pnpm install
```

### 2.2. Tạo Story Cho Login Page

```bash
npx keycloakify add-story
# Chọn: login -> login.ftl
```

**⚠️ Lưu ý**: Luôn dùng `npx` để chạy CLI tools (chuẩn trong JS projects)

### 2.3. Run Storybook

```bash
npm run storybook
```

Browser sẽ mở tại port 6006, bạn sẽ thấy login page với các scenarios khác nhau.

### 2.4. Thử CSS Customization Đầu Tiên

**Bước 1**: Tạo file CSS

```css
/* src/login/main.css */
.kcFormHeaderClass {
    border: 3px solid red;
}
```

**Bước 2**: Import CSS vào KcPage

```tsx
// src/login/KcPage.tsx
import "./main.css";
// ...
```

**Kết quả**: Header của login card sẽ có border màu đỏ.

---

## 3. CSS Customization

### 3.1. Hiểu về CSS Class System

Khi inspect DOM trong Storybook, bạn sẽ thấy 2 loại classes:

#### **Class `kc-*`** (Keycloakify Classes)
- Ví dụ: `kcLabelClass`, `kcButtonClass`, `kcFormClass`
- **Không có style mặc định**
- Mục đích: Làm selector cho custom styles của bạn

#### **Class `pf-*`** (PatternFly Classes)
- Ví dụ: `pf-c-button`, `pf-m-primary`, `pf-c-form__label`
- **Có sẵn styles** từ PatternFly CSS framework (của RedHat)
- Keycloak dùng PatternFly để build tất cả UIs

### 3.2. Applying Custom CSS

```css
/* src/login/main.css */
.kcLabelClass {
   border: 3px solid red;
}
```

```tsx
// src/login/KcPage.tsx
import "./main.css";
// ...
```

### 3.3. Removing Default PatternFly Styles

#### **Cách 1: Remove từng class cụ thể**

**Trường hợp**: Bạn muốn unstyle Sign In button

```tsx
// src/login/KcPage.tsx
const classes = {
    kcButtonClass: "",
    kcButtonPrimaryClass: "",
    kcButtonBlockClass: "",
    kcButtonLargeClass: ""
} satisfies { [key in ClassKey]?: string };
```

Sau khi remove, button sẽ trở về default HTML style, bạn có thể tự do style theo ý muốn.

#### **Cách 2: Remove tất cả default styles**

```tsx
// src/login/KcPages.tsx
<DefaultPage
    kcContext={kcContext}
    i18n={i18n}
    classes={classes}
    Template={Template}
    doUseDefaultCss={false}  // ⭐ Set thành false
    UserProfileFormFields={UserProfileFormFields}
    doMakeUserConfirmPassword={doMakeUserConfirmPassword}
/>
```

**Lợi ích**: 
- Tất cả `pf-*` classes bị strip ra
- PatternFly stylesheet không được load
- Bạn có clean slate để style từ đầu

#### **Cách 3: Disable chỉ một số pages**

```tsx
// src/login/KcPages.tsx
switch (kcContext.pageId) {
    case "login.ftl":
        return (
            <Login
                {...{ kcContext, i18n, classes }}
                Template={Template}
                doUseDefaultCss={false}  // Chỉ login.ftl không dùng default CSS
            />
        );
    default:
        return (
            <DefaultPage
                kcContext={kcContext}
                i18n={i18n}
                classes={classes}
                Template={Template}
                doUseDefaultCss={true}  // Pages khác vẫn giữ default
                UserProfileFormFields={UserProfileFormFields}
                doMakeUserConfirmPassword={doMakeUserConfirmPassword}
            />
        );
}
```

### 3.4. Remove Classes Trong Ejected Components

Nếu bạn đã eject page với `npx keycloakify eject-page` và set `doUseDefaultCss={false}`, bạn có thể xóa `kcClsx` trong code:

**Trước khi xóa**:
```tsx
<input
    className={kcClsx(
        "kcButtonClass", 
        "kcButtonPrimaryClass", 
        "kcButtonBlockClass", 
        "kcButtonLargeClass"
    )}
/>
```

**Sau khi xóa** (nếu không cần):
```tsx
<input className="your-custom-class" />
```

**⚠️ Chú ý**: Nếu bạn đã define CSS cho `.kcButtonClass`, thì remove sẽ làm mất style đó.

---

## 4. Testing Your Theme

### 4.1. Testing Outside of Keycloak (Storybook)

#### **Tại sao dùng Storybook?**
- Preview pages với mock data
- Hot reloading cực nhanh
- Test nhiều scenarios khác nhau (error states, different languages, etc.)

#### **Add Story cho một page**

```bash
npx keycloakify add-story
# Chọn page muốn test (ví dụ: login -> register.ftl)
```

#### **Run Storybook**

```bash
npm run storybook
```

#### **Tạo Custom Story với Mock Context**

```tsx
// src/login/pages/Register.stories.tsx
import type { Meta, StoryObj } from "@storybook/react";
import { createKcPageStory } from "../KcPageStory";

const { KcPageStory } = createKcPageStory({ pageId: "register.ftl" });

const meta = {
    title: "login/register.ftl",
    component: KcPageStory
} satisfies Meta<typeof KcPageStory>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
    render: () => <KcPageStory />
};

// Story với Chinese language
export const InChinese: Story = {
    render: () => (
        <KcPageStory
            kcContext={{
                locale: {
                    currentLanguageTag: "zh-CN"
                }
            }}
        />
    )
};
```

### 4.2. Testing Inside of Keycloak (Docker)

#### **Prerequisites**

1. **Install Docker Desktop**: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)

2. **Install Maven**: Cần để build `.jar` files

```bash
# Check xem đã có chưa
mvn --version

# MacOS (dùng Homebrew)
brew install maven

# Ubuntu/Debian
sudo apt-get install maven

# Windows
# Download từ https://maven.apache.org/download.cgi
```

#### **Run Keycloak in Docker**

```bash
npx keycloakify start-keycloak
```

CLI sẽ hỏi bạn chọn Keycloak version (ví dụ: 26.0.7, 25.0.1, 22.0.5, etc.)

#### **Sau khi container chạy**

Bạn sẽ thấy 2 links:

**1. Keycloak Admin Console**: [http://localhost:8080](http://localhost:8080)

- Pre-configured với theme của bạn
- Realm: `myrealm`
- Test user: `testuser` / `password123`
- Config lưu trong `.keycloakify/` directory (persist across restarts)

**2. Test Web App**: [https://my-theme.keycloakify.dev](https://my-theme.keycloakify.dev)

- App redirect đến login theme của bạn
- Auto-rebuild khi bạn edit theme
- Refresh page để thấy changes

#### **Inspect `window.kcContext`**

Sau khi login với `testuser/password123`, bạn sẽ được redirect tới page để:
- Xem decoded ID token (JWT)
- Access custom [Account theme](https://docs.keycloakify.dev/theme-types/account-theme)
- Access custom [Admin theme](https://docs.keycloakify.dev/theme-types/admin-theme)

#### **Advanced Options**

```bash
# Custom Keycloak image, load extensions, import realm config
npx keycloakify start-keycloak --help
```

Reference: [startKeycloakOptions](https://docs.keycloakify.dev/features/compiler-options/startkeycloakoptions)

---

## 5. Deploying Your Theme

### 5.1. Building the JAR File

**⚠️ Chú ý**: Section này cho **PRODUCTION deployment**, không phải dev testing.

```bash
npm run build-keycloak-theme
```

Command này tạo `/dist_keycloak` directory chứa JAR files.

#### **Chọn đúng JAR file**

Mặc định, Keycloakify generate nhiều JAR files cho các Keycloak versions khác nhau:

| Keycloak Version | JAR File |
|------------------|----------|
| **11-21, 26+** | `keycloak-theme-for-kc-all-other-versions.jar` |
| **22-25** | `keycloak-theme-for-kc-22-to-25.jar` |

**Customize JAR names/targets**: Xem [keycloakVersionTargets](https://docs.keycloakify.dev/features/compiler-options/keycloakversiontargets)

### 5.2. Loading JAR into Keycloak

#### **Docker**

```bash
docker run \
    # ...other options
    -v "./dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar":/opt/keycloak/providers/keycloak-theme.jar \
    quay.io/keycloak/keycloak:26.0.7 \
    start
```

#### **Docker Compose**

```yaml
version: '3.8'
services:
  keycloak:
    image: quay.io/keycloak/keycloak:26.0.7
    volumes:
      - ./dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar:/opt/keycloak/providers/keycloak-theme.jar
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
    ports:
      - "8080:8080"
    command: start
```

#### **Helm (Kubernetes)**

```yaml
extraVolumes:
  - name: keycloak-theme
    hostPath:
      path: /path/to/dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar

extraVolumeMounts:
  - name: keycloak-theme
    mountPath: /opt/keycloak/providers/keycloak-theme.jar
```

#### **Bare Metal**

Copy JAR vào `/opt/keycloak/providers/`:

```bash
cp ./dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar /opt/keycloak/providers/
```

### 5.3. Enabling Your Theme

1. Login vào **Keycloak Admin Console**
2. Chọn **Realm của bạn** (⚠️ **KHÔNG dùng master realm**)
3. Left sidebar: **Realm Settings**
4. Tab: **Themes**
5. Dropdown **Login Theme**: Chọn theme của bạn (tên định nghĩa trong [themeName option](https://docs.keycloakify.dev/features/compiler-options/themename))

**💡 Tip**: Nếu bạn implement [theme variants](https://docs.keycloakify.dev/features/theme-variants), bạn sẽ thấy nhiều options trong dropdown.

---

## 6. Common Use Case Examples

### 6.1. Using a Component Library

**Tại sao starter repo ít components?**

Keycloakify internalizes tất cả components của default UI, chỉ expose `DefaultPage`. Lý do:
- Chỉ show pages bạn đã modify
- Không overwhelm người chỉ muốn CSS customization

#### **Eject Page để Custom với Component Library**

```bash
npx keycloakify eject-page
# Chọn page muốn custom (ví dụ: login -> login.ftl)
```

Command này copy component từ Keycloakify source vào project của bạn.

#### **Video Tutorial: Customize Login với MUI**

[📹 Xem video hướng dẫn chi tiết](https://youtu.be/PhNE-3EwwP8)

**Timestamps:**
- Eject page
- Install MUI
- Replace components
- Disable default styles ([xem tại 22:18](https://youtu.be/PhNE-3EwwP8?si=s3e9DjaIlhG2uxQC&t=1338))

### 6.2. Custom Fonts

#### **Option 1: Web Font Service (Google Fonts)**

```css
/* src/login/main.css */
@import url('https://fonts.googleapis.com/css2?family=Playwrite+NL:wght@100..400&display=swap');

.kcHeaderWrapperClass {
    font-family: "Playwrite NL", cursive;
}
```

```tsx
// src/login/KcPage.tsx
import "./main.css";
```

#### **Option 2: Self-Hosted Fonts** (Internal Network)

**Bước 1**: Download font vào `src/login/assets/fonts/geist/`

**Bước 2**: Create CSS

```css
/* src/login/main.css */
@import url(./assets/fonts/geist/main.css);

body {
  font-family: Geist;
}
```

**Bước 3**: Import

```tsx
// src/login/KcPage.tsx
import "./main.css";
```

**Lợi ích**: Font được bundle trong JAR, không cần CDN (phù hợp enterprise với strict network control).

### 6.3. Changing Background Image

**Bước 1**: Download background từ [coolbackgrounds.io](https://coolbackgrounds.io/) → save vào `src/login/assets/background.png`

**Bước 2**: Apply CSS

```css
/* src/login/main.css */
body.kcBodyClass {
  background: url(./assets/background.png) no-repeat center center fixed;
}
```

**Bước 3**: Import

```tsx
// src/login/KcPage.tsx
import "./main.css";
```

**💡 Advanced**: Muốn replace image without rebuild? Xem section ["Replacing the image without re-building the theme"](https://docs.keycloakify.dev/common-use-case-examples/changing-the-background-image)

### 6.4. Adding Your Logo

#### **Eject Template**

```bash
npx keycloakify eject-page
# Chọn: login -> Template.tsx
```

#### **Add Logo**

**Bước 1**: Save logo vào `src/login/assets/logo.png`

**Bước 2**: Import và sử dụng

```tsx
// src/login/Template.tsx
import logoPngUrl from "./assets/logo.png";

// ...trong code
<div className={kcClsx("kcLoginClass")}>
    <div id="kc-header" className={kcClsx("kcHeaderClass")}>
        <div id="kc-header-wrapper" className={kcClsx("kcHeaderWrapperClass")}>
            <img src={logoPngUrl} width={500}/>
        </div>
    </div>
    {/* ... */}
</div>
```

#### **Hot-Swap Logo (Optional)**

Nếu muốn update logo mà không rebuild theme:

**Bước 1**: Move logo vào `public/img/logo.png`

**Bước 2**: Absolute import

```tsx
// src/login/Template.tsx (Vite)
<img src={`${import.meta.env.BASE_URL}img/logo.png`} width={500}/>
```

**Lợi ích**: 
- URL correct ngay cả khi customize `base` trong `vite.config.ts`
- Có thể SSH vào Keycloak server và hot-swap: `/opt/keycloak/themes/<theme-name>/login/resources/dist/img/logo.png`

### 6.5. Using Tailwind CSS

#### **Setup Tailwind với Vite**

Follow: [Tailwind Vite Installation](https://tailwindcss.com/docs/guides/vite#react)

#### **Demo Starter**

Xem branch `tailwind` của starter template: [keycloakify-starter/tree/tailwind](https://github.com/keycloakify/keycloakify-starter/tree/tailwind)

**Thay đổi chính:**

1. **Apply Tailwind với `@apply` directive**:

```css
/* src/login/index.css */
.kcButtonClass {
    @apply bg-blue-500 text-white px-4 py-2 rounded;
}
```

2. **Dùng Geist font** (từ Vercel):

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Geist', 'sans-serif'],
      },
    },
  },
}
```

```css
/* src/login/index.css */
@import url(./assets/fonts/geist/main.css);

body {
    @apply font-sans;
}
```

3. **Eject page và apply Tailwind classes**:

```bash
npx keycloakify eject-page
# Chọn: login -> login.ftl
```

```tsx
// src/login/pages/Login.tsx
<button className="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded">
    {msg("doLogIn")}
</button>
```

**Xem diff**: [Demo Tailwind Commit](https://github.com/keycloakify/keycloakify-starter/commit/e6c71f13acbc65ccb8f57172c45e8c04a2151007)

### 6.6. Dark Mode Persistence

**Use case**: User browse app trong dark mode → click Login → login pages cũng dark mode

#### **Trong Web Application**

Append `&dark=true` hoặc `&dark=false` vào Keycloak auth URL:

```tsx
// Example với oidc-spa + MUI
import { useOidc } from "oidc";
import { useTheme } from "@mui/material/styles";
import Button from "@mui/material/Button";
import { assert } from "tsafe/assert";

export function AuthButtons() {
  const { isUserLoggedIn, login } = useOidc();

  assert(!isUserLoggedIn, "User should not be logged in");

  const theme = useTheme();

  const extraQueryParams = {
    dark: theme.palette.mode === "dark" ? "true" : "false",
    ui_locales: "en"
  };

  return (
    <>
      <Button onClick={() => login({ 
          doesCurrentHrefRequiresAuth: false, 
          extraQueryParams 
      })}>
        Login
      </Button>
      <Button variant="contained" onClick={() => login({ 
          doesCurrentHrefRequiresAuth: false,
          transformUrlBeforeRedirect: url => {
            const urlObj = new URL(url);
            urlObj.pathname = urlObj.pathname.replace(/\/auth$/, "/registrations");
            return urlObj.href;
          },
          extraQueryParams
      })}>
        Register
      </Button>
    </>
  );
}
```

#### **Trong Login Theme**

**Bước 1**: Utility để read `dark` query param

```ts
// src/shared/isDark.ts
const SESSION_STORAGE_KEY = "isDark";

function getIsDark(): boolean {
    from_url: {
        const url = new URL(window.location.href);
        const value = url.searchParams.get("dark");

        if (value === null) break from_url;

        // Remove &dark= từ URL
        url.searchParams.delete("dark");
        window.history.replaceState({}, "", url.toString());

        const isDark = value === "true";
        
        // Persist in sessionStorage
        sessionStorage.setItem(SESSION_STORAGE_KEY, `${isDark}`);
        return isDark;
    }

    from_session_storage: {
        const value = sessionStorage.getItem(SESSION_STORAGE_KEY);
        if (value === null) break from_session_storage;
        return value === "true";
    }

    // Fallback: browser preference
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
}
```

**Bước 2**: Apply trong KcPage với React/MUI

```tsx
// src/login/KcPage.tsx
import { createTheme, ThemeProvider } from "@mui/material/styles";
import { getIsDark } from "../shared/isDark";

const theme_dark = createTheme({ palette: { mode: "dark" } });
const theme_light = createTheme({ palette: { mode: "light" } });

export default function KcPage(props: { kcContext: KcContext }) {
    return (
        <ThemeProvider theme={getIsDark() ? theme_dark : theme_light}>
            <KcPageContextualized {...props} />
        </ThemeProvider>
    );
}
```

---

## 7. Internationalization (i18n)

### 7.1. Basic Principles

#### **Enable i18n trong Keycloak Admin**

1. Login → Realm Settings → Localization
2. **Supported Locales**: Chọn languages (ví dụ: en, fr, es)

#### **Chế độ hoạt động**

- Keycloak render UI theo language mà user chọn
- ⚠️ **Không nên dùng dropdown select** trên UI
- ✅ **Best practice**: Pass `?ui_locales=fr` query param từ app của bạn

```tsx
// oidc-spa example
login({
  doesCurrentHrefRequiresAuth: false,
  extraQueryParams: {
    ui_locales: "fr"  // ForceFrench UI
  }
})
```

#### **Cách hoạt động trong code**

```tsx
// src/login/pages/Register.tsx
export default function Register(props: RegisterProps) {
    const { i18n } = props;
    const { msg, msgStr, advancedMsg, advancedMsgStr } = i18n;

    return (
        <a href={url.loginUrl}>
            {msg("backToLogin")}  {/* Renders HTML */}
        </a>
    );
}
```

**Các hàm i18n:**

| Function | Return | Dùng khi |
|----------|--------|----------|
| `msg(key)` | `JSX.Element` | Render HTML (có `<strong>`, `<br>`, etc.) |
| `msgStr(key)` | `string` | Cần literal string (aria-label, placeholder, etc.) |
| `advancedMsg(key)` | `JSX.Element` | Key không statically defined (realm-specific) |
| `advancedMsgStr(key)` | `string` | Key không statically defined (string) |

#### **Xem default messages**

```
node_modules/keycloakify/src/login/i18n/messages_defaultSet/
├── en.ts
├── fr.ts
├── es.ts
└── ...
```

⚠️ **Không edit trực tiếp**, chỉ đọc để tham khảo.

### 7.2. Previewing Pages in Different Languages (Storybook)

```tsx
// src/login/pages/Login.stories.tsx
import type { Meta, StoryObj } from "@storybook/react";
import { createKcPageStory } from "../KcPageStory";

const { KcPageStory } = createKcPageStory({ pageId: "login.ftl" });

const meta = {
    title: "login/login.ftl",
    component: KcPageStory
} satisfies Meta<typeof KcPageStory>;

export default meta;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
    render: () => <KcPageStory />
};

export const French: Story = {
    render: () => (
        <KcPageStory
            kcContext={{
                locale: {
                    currentLanguageTag: "fr"
                }
            }}
        />
    )
};

export const Spanish: Story = {
    render: () => (
        <KcPageStory
            kcContext={{
                locale: {
                    currentLanguageTag: "es"
                }
            }}
        />
    )
};
```

#### **Set default language cho tất cả stories**

```tsx
// src/login/KcPageStory.tsx
export const { getKcContextMock } = createGetKcContextMock({
  kcContextExtension,
  kcContextExtensionPerPage,
  overrides: {
    locale: {
      currentLanguageTag: "de",  // German by default
    },
  },
  overridesPerPage: {},
});
```

### 7.3. Adding/Changing Translation Messages

#### **At Theme Level**

**Identify message key** (inspect HTML → tìm `data-kc-msg` attribute)

Example: Change "Sign in to your account" → "Log in to your ACME account"

```ts
// src/login/i18n.ts
import { i18nBuilder } from "keycloakify/login";
import type { ThemeName } from "../kc.gen";

const { useI18n, ofTypeI18n } = i18nBuilder
    .withThemeName<ThemeName>()
    .withExtraLanguages({ /* ... */ })
    .withCustomTranslations({
        en: {
            loginAccountTitle: "Log in to your ACME account",
            myCustomMessage: "This is a custom message"
        },
        // cspell: disable
        fr: {
            loginAccountTitle: "Connectez-vous à votre compte ACME",
            myCustomMessage: "Ceci est un message personnalisé"
        }
        // cspell: enable
    })
    .build();

type I18n = typeof ofTypeI18n;

export { useI18n, type I18n };
```

**⚠️ Quan trọng**: 
- Translations phải **statically declarable** (không import từ file ngoài)
- Lý do: Keycloakify analyze code lúc build để Keycloak biết server-side messages

#### **Custom Message Keys**

```tsx
// Trong component
const { msg } = i18n;

<p>{msg("myCustomMessage")}</p>
```

TypeScript sẽ biết `"myCustomMessage"` là valid key.

#### **At Realm Level** (Keycloak Admin Console)

- Realm Settings → Localization → Create/Edit message bundles
- Phù hợp cho: `termsText`, User Profile Attributes labels, etc.

**⚠️ Limitation**: Không phải tất cả realm-level translations đều work.

**Workaround** (nếu cần):

```ts
// vite.config.ts
keycloakify({
    kcContextExclusionsFtl: `
        <@addToXKeycloakifyMessagesIfMessageKey str="doRegister" />
        <@addToXKeycloakifyMessagesIfMessageKey str="invalidUserMessage" />
    `
})
```

### 7.4. Adding Support for Extra Languages

**Default supported**: 30 languages (ar, ca, cs, da, de, el, en, es, fa, fi, fr, hu, it, ja, ka, lt, lv, nl, no, pl, pt-BR, pt, ru, sk, sv, th, tr, uk, zh-CN, zh-TW)

**Thêm Hindi (hi)**:

**Bước 1**: Create translation file

```ts
// src/login/i18n.hi.ts
import type { MessageKey_defaultSet } from "keycloakify/login";

const messages: Record<MessageKey_defaultSet, string> = {
    // cspell: disable
    doLogIn: "साइन इन करें",
    doRegister: "रजिस्टर करें",
    // ... tất cả các keys khác
    // cspell: enable
};

export default messages;
```

**💡 Tip**: Dùng ChatGPT để translate (copy từ `node_modules/keycloakify/src/login/i18n/messages_defaultSet/en.ts`)

**Bước 2**: Index trong `i18n.ts`

```ts
// src/login/i18n.ts
import { i18nBuilder } from "keycloakify/login";
import type { ThemeName } from "../kc.gen";

const { useI18n, ofTypeI18n } = i18nBuilder
    .withThemeName<ThemeName>()
    .withExtraLanguages({
        hi: {
            // cspell: disable-next-line
            label: "हिन्दी",
            getMessages: () => import("./i18n.hi")
        }
    })
    .build();

type I18n = typeof ofTypeI18n;

export { useI18n, type I18n };
```

**Bước 3**: Enable trong Keycloak Admin Console

- Realm Settings → Localization → Supported Locales
- Chọn "Hindi"

---

## 8. Advanced Features

### 8.1. Theme Variants

**Use case**: Tạo nhiều themes từ 1 codebase (ví dụ: theme cho client A, B, C khác nhau)

#### **Define variants**

```ts
// vite.config.ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { keycloakify } from "keycloakify/vite-plugin";

export default defineConfig({
  plugins: [
    react(),
    keycloakify({
      themeName: ["keycloakify-starter", "keycloakify-starter-variant-1"],
    }),
  ],
});
```

#### **Use in code**

```tsx
// kcContext.themeName === "keycloakify-starter" | "keycloakify-starter-variant-1"

if (kcContext.themeName === "keycloakify-starter-variant-1") {
    // Load different CSS, logo, etc.
    import("./variant1.css");
}
```

#### **Different translations per variant**

```ts
// src/login/i18n.ts
const { useI18n, ofTypeI18n } = i18nBuilder
    .withThemeName<ThemeName>()
    .withExtraLanguages({ /* ... */ })
    .withCustomTranslations({
        en: {
            doLogIn: "Log in!",
            loginAccountTitle: {
                "my-theme-1": "Log in to your ACME1 account",
                "my-theme-2": "Log in to your ACME2 account"
            }
        },
        fr: {
            doLogIn: "Se connecter!",
            loginAccountTitle: {
                "my-theme-1": "Connectez-vous à votre compte ACME1",
                "my-theme-2": "Connectez-vous à votre compte ACME2"
            }
        }
    })
    .build();
```

**Result**: Keycloak Admin dropdown sẽ show cả 2 theme variants.

### 8.2. Environment Variables

**Use case**: Customize theme mà không rebuild (ví dụ: API URL, color palette khác nhau cho mỗi customer)

#### **Define in vite.config.ts**

```ts
// vite.config.ts
export default defineConfig({
    plugins: [
        react(),
        keycloakify({
            environmentVariables: [
                { name: "MY_APP_API_URL", default: "" },
                { name: "MY_APP_PALETTE", default: "dracula" }
            ]
        })
    ]
});
```

#### **Access in code**

```tsx
const { properties } = kcContext;

console.log(properties.MY_APP_API_URL);    // ""
console.log(properties.MY_APP_PALETTE);     // "dracula"
```

#### **Set values on Keycloak server**

**Docker**:
```bash
docker run \
    --env MY_APP_API_URL='https://api.my-org.com' \
    --env MY_APP_PALETTE='solaris' \
    quay.io/keycloak/keycloak:26.0.7 \
    start
```

**Docker Compose**:
```yaml
environment:
  MY_APP_API_URL: 'https://api.my-org.com'
  MY_APP_PALETTE: 'solaris'
```

**Test locally**:
```bash
MY_APP_PALETTE="solaris" MY_APP_API_URL="..." npx keycloakify start-keycloak
```

#### **Storybook stories với ENV values**

```tsx
export const Solaris: Story = {
    render: () => (
        <KcPageStory
            kcContext={{
                properties: {
                    MY_APP_PALETTE: "solaris"
                },
            }}
        />
    )
};
```

### 8.3. Styling Custom Pages (Extensions)

**Use case**: Extension như Phase Two thêm page mới (ví dụ: `otp-form.ftl`), Keycloakify không có sẵn style.

#### **Step 1: Declare page trong KcContext**

```tsx
// src/login/KcPageStory.tsx
const kcContextExtensionPerPage: KcContextExtensionPerPage = {
    "otp-form.ftl": { /* properties cần thiết */ }
};
```

#### **Step 2: Create page component**

```tsx
// src/login/pages/OtpForm.tsx
import { getKcClsx } from "keycloakify/login/lib/kcClsx";
import type { PageProps } from "keycloakify/login/pages/PageProps";
import type { KcContext } from "../KcContext";
import type { I18n } from "../i18n";

export default function OtpForm(props: PageProps<Extract<KcContext, { pageId: "otp-form.ftl" }>, I18n>) {
    const { kcContext, i18n, doUseDefaultCss, Template, classes } = props;
    const { kcClsx } = getKcClsx({ doUseDefaultCss, classes });
    const { msg, msgStr } = i18n;
    const { url } = kcContext;

    return (
        <Template
            kcContext={kcContext}
            i18n={i18n}
            doUseDefaultCss={doUseDefaultCss}
            classes={classes}
            displayInfo={false}
            headerNode={/* Header code */}
        >
            {/* Page code */}
        </Template>
    );
}
```

#### **Step 3: Type definitions**

```tsx
// src/login/KcContext.ts
export type KcContextExtensionPerPage = {
    "otp-form.ftl": {
        auth: {
            attemptedUsername: string;
        };
        url: {
            loginRestartFlowUrl: string;
            loginAction: string;
        };
    };
};
```

#### **Step 4: Custom translations**

```ts
// src/login/i18n.ts
.withCustomTranslations({
    en: {
        doResend: "Resend"
    },
    fr: {
        doResend: "Renvoyer"
    }
})
```

#### **Step 5: Mock trong story**

```tsx
// src/login/KcPageStory.tsx
const kcContextExtensionPerPage: KcContextExtensionPerPage = {
    "otp-form.ftl": {
        auth: {
            attemptedUsername: "user@user.com"
        },
        url: {
            loginRestartFlowUrl: "#",
            loginAction: "#"
        }
    }
};
```

#### **Step 6: Add to router**

```tsx
// src/login/KcPage.tsx
case "otp-form.ftl":
    return (
        <OtpForm
            {...{ kcContext, i18n, classes }}
            Template={Template}
            doUseDefaultCss={true}
        />
    );
```

**💡 Load extension trong dev**: Dùng [extensionJars option](https://docs.keycloakify.dev/features/compiler-options/startkeycloakoptions) với `npx keycloakify start-keycloak`

### 8.4. Integrating Existing Native Themes

**Use case**: Bạn đã có theme FreeMarker, muốn migrate sang Keycloakify

#### **Simple**: Copy paste vào `src/`

```
src/
├── login/
│   ├── theme.properties
│   ├── messages/
│   │   ├── messages_en.properties
│   │   └── messages_fr.properties
│   ├── resources/
│   │   ├── css/
│   │   │   └── styles.css
│   │   └── img/
│   │       └── logo.png
│   └── login.ftl
```

Keycloakify tự động include vào JAR.

#### **Theme Variants Support**

**FreeMarker variable**:
```html
<!-- src/login/login.ftl -->
<h1>${xKeycloakify.themeName}</h1>
```

**Custom translations per variant**:

```
messages/messages_en_override_vanilla.properties
messages/messages_en_override_chocolate.properties
```

```properties
# messages_en_override_vanilla.properties
loginAccountTitle=Welcome to Vanilla Theme

# messages_en_override_chocolate.properties
loginAccountTitle=Welcome to Chocolate Theme
```

---

## 9. Page-Specific Guides

### 9.1. Registration Page

#### **Video Tutorial**

[📹 Customize Register Page (Full Tutorial)](https://www.youtube.com/watch?v=lMOLrdqilqE)

**Timestamps:**
- [01:28](https://www.youtube.com/watch?v=lMOLrdqilqE&t=88s) - User Profile Attributes Configuration
- [11:05](https://www.youtube.com/watch?v=lMOLrdqilqE&t=665s) - Password Policies Configuration
- [13:27](https://www.youtube.com/watch?v=lMOLrdqilqE&t=807s) - Email Domain Accept List
- [15:10](https://www.youtube.com/watch?v=lMOLrdqilqE&t=910s) - Adding Custom User Attributes to JWT
- [16:31](https://www.youtube.com/watch?v=lMOLrdqilqE&t=991s) - Exporting Realm Configuration
- [19:14](https://www.youtube.com/watch?v=lMOLrdqilqE&t=1154s) - Creating Storybook Stories
- [23:53](https://www.youtube.com/watch?v=lMOLrdqilqE&t=1433s) - Customizing with CSS
- [26:35](https://www.youtube.com/watch?v=lMOLrdqilqE&t=1595s) - Customizing with React

#### **Quick Steps**

```bash
# Eject register page
npx keycloakify eject-page
# Chọn: login -> register.ftl

# Add story
npx keycloakify add-story
# Chọn: login -> register.ftl

# Run storybook
npm run storybook
```

### 9.2. Terms and Conditions Page

#### **Enable trong Keycloak**

1. Realm Settings
2. Tab: **Authentication**
3. Tab: **Required Actions**
4. **Terms and condition**: ✅ Enabled + **Set as Default Action**

#### **Define Terms Text**

**Keycloak Admin Console** (recent versions):

1. Realm Settings → Localization
2. Create/Edit message bundles
3. Override `termsText` key cho từng language

[📹 Video hướng dẫn chi tiết](https://docs.keycloakify.dev/page-specific-guides/terms-and-conditions-page)

#### **Customize Page Rendering**

```bash
npx keycloakify eject-page
# Chọn: login -> terms.ftl

npx keycloakify add-story
# Chọn: login -> terms.ftl
```

**Trong component**:

```tsx
// src/login/Terms.tsx
const { msg, msgStr } = i18n;

// msg("termsText") returns JSX.Element (HTML)
// msgStr("termsText") returns string (if you need to transform)

<div dangerouslySetInnerHTML={{ __html: msgStr("termsText") }} />
```

**💡 Use iframe**: [Xem discussion](https://github.com/keycloakify/keycloakify/discussions/687)

---

## 10. Theme Types

### 10.1. Difference Between Theme Types

#### **4 Theme Types**

| Type | Description |
|------|-------------|
| **Login Theme** | UI cho login/register pages (user-facing) |
| **Account Theme** | Account management UI (user update email, password, etc.) |
| **Email Theme** | Email templates (confirmation, password reset, etc.) |
| **Admin Theme** | Admin Console UI (Keycloak configuration) |

#### **Features Shared Across All Types**

- ✅ [Testing inside Keycloak](https://docs.keycloakify.dev/testing-your-theme/inside-of-keycloak)
- ✅ [Theme Variants](https://docs.keycloakify.dev/features/theme-variants)
- ✅ [Environment Variables](https://docs.keycloakify.dev/features/environment-variables) (except Email)

#### **Login & Multi-Page Account Only**

- ❌ [Testing outside Keycloak](https://docs.keycloakify.dev/testing-your-theme/outside-of-keycloak) (Storybook)
- ❌ [npx keycloakify eject-page](https://docs.keycloakify.dev/common-use-case-examples/using-a-component-library)
- ❌ [i18n system](https://docs.keycloakify.dev/features/i18n) (other types handle differently)

### 10.2. Account Theme

#### **2 Options**

1. **Single-Page** (Modern, React SPA)
2. **Multi-Page** (Giống Login theme, server-rendered)

#### **10.2.1. Single-Page Account Theme**

**Initialize**:

```bash
npx keycloakify initialize-account-theme
# Chọn: Single-Page
```

[📹 Video Tutorial](https://www.youtube.com/watch?v=UKU6zGCH-CY)

**Timestamps:**
- [00:00](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=0s) – Intro
- [03:33](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=213s) – Changing the logo
- [07:46](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=466s) – Using a custom button component
- [14:13](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=853s) – Update process
- [16:55](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=1015s) – Translations (i18n)
- [18:23](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=1103s) – Enabling in Keycloak Admin Console

**Run Server**:

```bash
npx keycloakify start-keycloak
```

**Update Logo**:

1. Own file: `npx keycloakify own --path "account/root/Header.tsx"`
2. Add logo vào `src/account/assets/`
3. Update import: `import logoSvgUrl from "../assets/your-logo.svg";`
4. Run server

**Custom PatternFly Component**:

```tsx
// src/shared/@patternfly/react-core/CustomButton.tsx
import { type ButtonProps, Button } from "@patternfly/react-core";
import { css } from "@patternfly/react-styles";
import styles from "./CustomButton.module.css";

export function CustomButton(props: ButtonProps) {
  const { children, variant = "primary", className: className_props, ...rest } = props;
  const className = css(styles.button, styles[variant], className_props);

  if (variant === "link") {
    return (
      <Button {...rest} className={className} variant="link">
        {children}
      </Button>
    );
  }

  return (
    <button {...rest} className={className}>
      {children}
    </button>
  );
}
```

```tsx
// src/shared/@patternfly/react-core/index.tsx
export * from "@patternfly/react-core";
export { CustomButton as Button } from "./CustomButton";
```

#### **10.2.2. Multi-Page Account Theme**

**Initialize**:

```bash
npx keycloakify initialize-account-theme
# Chọn: Multi-Page
```

**Workflow**: Giống y hệt Login theme

```bash
npx keycloakify add-story
# Chọn: account -> ...

npx keycloakify eject-page
# Chọn: account -> ...
```

**i18n**: Replace `/login/` thành `/account/` trong imports

**Use REST API**: Fetch data dynamically

```tsx
// Example: Call Account REST API
// Reference: https://github.com/keycloak/keycloak/tree/main/js/apps/account-ui/src/api
```

[Demo branch: account_api_poc](https://github.com/keycloakify/keycloakify-starter/tree/account_api_poc)

### 10.3. Email Theme

#### **Option 1: keycloakify-emails (JSX Email)**

**Setup** (Vite only):

```bash
npm install keycloakify-emails jsx-email
```

- [keycloakify-emails GitHub](https://github.com/timofei-iatsenko/keycloakify-emails)
- [jsx-email](https://jsx.email/)

**Example**: Xem `/example` directory trong repo

#### **Option 2: Native FreeMarker Templates**

```bash
npx keycloakify initialize-email-theme
# Chọn: native
```

**Using assets**:

```
src/email/resources/kc-logo.png
```

```html
<!-- src/email/html/email-verification.ftl -->
<img src="${url.resourcesUrl}/kc-logo.png" />
```

### 10.4. Admin Theme

**Initialize**:

```bash
npx keycloakify initialize-admin-theme
```

**Workflow**: Giống y hệt Single-Page Account Theme

[📹 Video Tutorial - Admin Theme section](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=1195s) ([19:55](https://www.youtube.com/watch?v=UKU6zGCH-CY&t=1195s))

---

## 📚 Appendix

### Commands Reference

```bash
# CLI Commands (luôn dùng npx)
npx keycloakify eject-page              # Eject page component
npx keycloakify add-story               # Tạo Storybook story
npx keycloakify start-keycloak          # Chạy Keycloak Docker
npx keycloakify initialize-account-theme    # Init account theme
npx keycloakify initialize-email-theme      # Init email theme
npx keycloakify initialize-admin-theme      # Init admin theme
npx keycloakify update-kc-gen           # Regenerate kc.gen.tsx

# NPM Scripts
npm install                             # Cài dependencies
npm run dev                             # Dev server
npm run build                           # TypeScript check + Vite build
npm run build-keycloak-theme            # Build JAR
npm run storybook                       # Storybook
npm run format                          # Prettier
```

### File Structure

```
keycloakify-starter/
├── .keycloakify/              # Keycloak config (persist across restarts)
├── dist_keycloak/             # JAR files (sau khi build)
├── public/                    # Static assets
│   └── keycloakify-dev-resources/   # Storybook mock files (KHÔNG SỬA)
├── src/
│   ├── kc.gen.tsx             # ⚠️ AUTO-GENERATED, KHÔNG SỬA
│   ├── main.tsx               # Entrypoint
│   ├── login/                 # Login theme
│   │   ├── KcPage.tsx         # Router theo pageId
│   │   ├── KcContext.ts       # Type extensions
│   │   ├── KcPageStory.tsx    # Storybook mock context
│   │   ├── i18n.ts            # i18n config
│   │   ├── main.css           # Global CSS
│   │   ├── Template.tsx       # Template component
│   │   └── pages/             # Page components
│   │       ├── Login.tsx
│   │       ├── Login.stories.tsx
│   │       ├── Register.tsx
│   │       └── ...
│   ├── account/               # (Optional) Account theme
│   ├── email/                 # (Optional) Email theme
│   └── admin/                 # (Optional) Admin theme
├── vite.config.ts             # Vite + Keycloakify config
└── package.json
```

### TypeScript Type Tips

```tsx
// Page Props
import type { PageProps } from "keycloakify/login/pages/PageProps";
import type { KcContext } from "../KcContext";
import type { I18n } from "../i18n";

type LoginProps = PageProps<Extract<KcContext, { pageId: "login.ftl" }>, I18n>;

// ClassKey type
import type { ClassKey } from "keycloakify/login";

const classes = {
    kcButtonClass: "custom-button",
} satisfies { [key in ClassKey]?: string };
```

### Environment Variables Best Practices

✅ **DO**:
- Define default values
- Use for deployment-specific configs (API URLs, colors, feature flags)
- Test locally với env vars trước khi deploy

❌ **DON'T**:
- Commit credentials/secrets
- Use cho sensitive data (dùng Keycloak secrets hoặc Vault)

### Troubleshooting

#### **Maven not found**

```bash
# MacOS
brew install maven

# Ubuntu/Debian
sudo apt-get install maven

# Check
mvn --version
```

#### **Docker not running**

```bash
# Check Docker status
docker ps

# Start Docker Desktop hoặc
sudo systemctl start docker
```

#### **Storybook không hiện page**

- Check `add-story` đã chạy chưa
- Check `npm run storybook` output có errors không
- Clear cache: `rm -rf node_modules/.cache`

#### **Theme không apply trong Keycloak**

- Check JAR đã load đúng chưa (logs của Keycloak)
- Check theme name trong Realm Settings → Themes
- Clear browser cache
- Restart Keycloak

#### **Hot reload không work**

- Check `npx keycloakify start-keycloak` vẫn đang chạy
- Check file changes có save không
- Check terminal có errors không

---

## 11. 🎨 Alternative Starter Themes

### Moving Away from PatternFly

Keycloakify v11 hỗ trợ starter themes với UI toolkits phổ biến thay vì PatternFly mặc định. Dùng starter themes nếu:
- ✅ Bạn đã quen với Tailwind CSS + ShadCN UI hoặc MUI
- ✅ Muốn setup nhanh với toolkit familiar
- ✅ Không muốn học PatternFly từ đầu

### 11.1. Shadcn UI (Tailwind CSS) Starter

**🎯 Best cho**: Projects đang dùng Tailwind + ShadCN UI, modern design system

#### **8-Step Setup Guide**

##### **Step 1: Create Vite Project**

```bash
npm create vite@latest my-keycloak-theme
# Select: React + TypeScript
cd my-keycloak-theme
```

##### **Step 2: Add Dependencies**

```bash
npm install keycloakify @oussemasahbeni/keycloakify-login-shadcn
```

**Packages**:
- `keycloakify`: Core library
- `@oussemasahbeni/keycloakify-login-shadcn`: Login theme với Tailwind + ShadCN UI components

##### **Step 3: Initialize Keycloakify**

```bash
npx keycloakify init
```

**Chọn options**:
- Theme type: `login` ✅
- Add stories: `yes` ✅ (để có Storybook)

##### **Step 4: Update vite.config.ts**

```ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { keycloakify } from 'keycloakify/vite-plugin'
import tailwindcss from '@tailwindcss/vite'
import path from 'path'

export default defineConfig({
  plugins: [
    react(),
    tailwindcss(), // ⬅️ Tailwind plugin
    keycloakify({ 
      accountThemeImplementation: "none" // ⬅️ Chỉ login theme
    })
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src') // ⬅️ Path aliases
    }
  }
})
```

##### **Step 5: Update TypeScript Paths**

**tsconfig.json** & **tsconfig.app.json**:

```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"]  // ⬅️ Enable @/ imports
    }
  }
}
```

**Usage**: `import Logo from "@/assets/logo.svg"`

##### **Step 6: Git Initialization (REQUIRED)**

```bash
git init .
git add -A
git commit -m "Initial commit"
```

**⚠️ Why Required**: Keycloakify tracks file changes với Git để build theme correctly.

##### **Step 7: Key Commands**

```bash
# Preview UI components trong Storybook
npm run storybook

# Build .jar theme
npm run build-keycloak-theme

# Test theme trong Docker Keycloak
npx keycloakify start-keycloak
```

##### **Step 8: Understanding "Own" Command**

📹 **Video tutorial**: Timestamp [4:05](https://youtu.be/xxx) - explains how to "own" files

**Concept**: Eject Keycloakify's internal components để customize:

```bash
npx keycloakify eject-page
# Select page: login.ftl, register.ftl, etc.
```

**Result**: Component file copied to `src/login/pages/` → bạn có full control

#### **Resources**

| Resource | Link |
|----------|------|
| 🎨 Storybook Demo | [oussemasahbeni.github.io/keycloakify-shadcn-starter](https://oussemasahbeni.github.io/keycloakify-shadcn-starter/) |
| 💻 GitHub Repo | [Oussemasahbeni/keycloakify-shadcn-starter](https://github.com/Oussemasahbeni/keycloakify-shadcn-starter) |
| 📦 NPM Package | `@oussemasahbeni/keycloakify-login-shadcn` |

---

### 11.2. MUI (Material-UI) Starter

**🎯 Best cho**: Projects đã dùng Material-UI, corporate design systems

#### **Quick Setup**

```bash
# Clone starter
git clone https://github.com/jk-powered-de/keycloakify-mui-starter.git
cd keycloakify-mui-starter

# Install & run
npm install
npm run storybook
```

#### **Features**

- ✅ Material-UI components
- ✅ PatternFly-based với MUI styling
- ✅ Ready-made login/register pages
- ✅ Storybook examples

#### **Resources**

| Resource | Link |
|----------|------|
| 💻 GitHub Repo | [jk-powered-de/keycloakify-mui-starter](https://github.com/jk-powered-de/keycloakify-mui-starter) |
| 📖 MUI Docs | [mui.com](https://mui.com) |

---

### 11.3. When to Use Starter Themes

| Scenario | Use Starter Theme? | Reason |
|----------|-------------------|---------|
| Already using Tailwind | ✅ Shadcn UI | Match existing stack |
| Already using MUI | ✅ MUI Starter | Reuse components |
| Learning from scratch | ⚠️ Default PatternFly | More examples/docs |
| Need complete control | ⚠️ Build từ đầu | Custom everything |

---

## 12. ❓ FAQ & Troubleshooting

### 12.1. Common Questions

#### **Q1: How does Keycloakify work internally?**

**Short Answer**: Keycloakify transforms React components → FreeMarker templates (.ftl) → bundles vào .jar theme.

**Deep Dive**: Xem GitHub discussion chi tiết:
- 🔗 [How Keycloakify Works (Discussion)](https://github.com/keycloakify/keycloakify/discussions/346#discussioncomment-5889791)

**Key Concepts**:
- FTL compilation: React → FreeMarker templates
- Static asset bundling: CSS/JS/images packed into JAR
- Runtime context: `window.kcContext` available trên client
- Build process: `npx keycloakify build` generates JAR

---

#### **Q2: Images/CSS work in Storybook but not in Keycloak?**

**Problem**: Assets broken khi deploy to Keycloak or `npx keycloakify start-keycloak`

**🛑 INVALID Code (Không work với Vite/CRA)**:

```tsx
<img src="/logo.png" />        // ❌ Không reliable
<img src="logo.png" />         // ❌ Không supported officially
```

**✅ Solution 1: Using Bundler (RECOMMENDED)**

Place asset trong `src/`:

```
src/
  login/
    assets/
      logo.png  ⬅️
    Template.tsx
```

**Import trong component**:

```tsx
import logoPngUrl from "./assets/logo.png";

export function Template() {
  return <img src={logoPngUrl} alt="Logo" />;
}
```

**Why**: Bundler (Vite/Webpack) resolves path correctly & includes asset trong build.

---

**✅ Solution 2: Using Public Directory**

Place asset trong `public/`:

```
public/
  img/
    logo.png  ⬅️
```

**Usage**:

```tsx
// Vite Projects
<img src={import.meta.env.BASE_URL + "img/logo.png"} />

// Create React App / Webpack
<img src={process.env.PUBLIC_URL + "/img/logo.png"} />
```

**When to use**: Assets should remain unchanged after build (fonts, third-party files, etc.)

---

#### **Q3: Is window.kcContext a security concern?**

**Concern**: "kcContext exposes too much realm configuration!"

**Answer**: ✅ **Safe** - No sensitive data included

`window.kcContext` chỉ chứa:
- Page ID (`pageId: "login.ftl"`)
- Realm display name
- Client ID
- User profile attributes
- Social providers list
- Theme messages

**What's NOT included**:
- ❌ Passwords
- ❌ Secrets
- ❌ Private keys
- ❌ Database credentials

**Filtering specific values**:

Nếu vẫn muốn hide specific properties, dùng compiler option:

```tsx
// vite.config.ts
keycloakify({
  kcContextExclusionsFtl: [
    "realm.displayName",
    "social.providers"
  ]
})
```

📖 **Docs**: [kcContextExclusionsFtl](https://doc-old.keycloakify.dev/features/compiler-options/kccontextexclusionsftl)

---

#### **Q4: How do I identify the page to customize?**

**Method**: Open DevTools → check `window.kcContext.pageId`

**Steps**:

1. Open Keycloak login page trong browser
2. Open DevTools (F12) → Console tab
3. Type: `window.kcContext.pageId`
4. Result: `"register.ftl"`, `"login.ftl"`, etc.

**Scenarios**:

##### **Scenario 1: No kcContext**

Error: `window.kcContext is undefined`

**Reason**: Theme not enabled on realm/client

**Fix**: Check deployment guide → enable theme on Keycloak Admin Console

---

##### **Scenario 2: Page not in Storybook**

`pageId: "custom-verify-email.ftl"` (không có trong [Storybook reference](https://storybook.keycloakify.dev))

**Reason**: Third-party Keycloak extension adds custom page

**Fix**: Follow guide [Styling a Custom Page Not Included in Base Keycloak](https://docs.keycloakify.dev/features/styling-a-custom-page-not-included-in-base-keycloak)

---

#### **Q5: Can I use react-hooks-form?**

**Answer**: ⚠️ **Not Recommended**

**Why NOT**:
- ❌ Keycloak server = authoritative for validation (password policies, email restrictions, etc.)
- ❌ Hard coding rules in theme = maintenance nightmare
- ❌ Rules change on server → theme out of sync

**Example**: Password must be 12+ chars → defined on **Keycloak Admin**, not theme.

**Validation criteria available in**:
- `kcContext.profile.attributesByName[*].validators`
- `kcContext.passwordPolicies`

Implementing these manually trong `react-hooks-form` = not straightforward.

---

**✅ BETTER SOLUTION: useUserProfileForm**

Keycloakify provides `useUserProfileForm` hook:
- ✅ Similar API to react-hooks-form
- ✅ Built-in Keycloak validators
- ✅ Auto syncs với password policies

**Reference**: [UserProfileFormFields.tsx#L20-L27](https://github.com/keycloakify/keycloakify/blob/8eaaffb25a7b6d6c8b7e455d5005dc31d70b8927/src/login/UserProfileFormFields.tsx#L20-L27)

**Pro Tip**: Chỉ implement field types your company actually uses (không cần checkboxes/multi-value if not needed).

---

#### **Q6: I can't find what I need in kcContext - TypeScript says undefined**

**Problem**: `kcContext.social` undefined on register page (TypeScript error)

**Reason**: Default type definitions only include what default pages use. At runtime, có nhiều data hơn!

**Example**: Enable Google/Facebook sign-up on register page:

##### **Step 1: Extend KcContext Type**

**src/login/KcContext.ts**:

```ts
import type { ExtendKcContext } from "keycloakify/login";

export type KcContextExtension = {
  // Declare social property on register page
  "register.ftl": {
    social: Extract<KcContext, { pageId: "login.ftl" }>["social"];
  };
};

export type KcContext = ExtendKcContext<KcContextExtension>;
```

**Explanation**: Borrow `social` type from login page → apply to register page.

---

##### **Step 2: Augment Mock for Storybook**

**src/login/KcPageStory.tsx**:

```tsx
import { getKcContextMock } from "keycloakify/login/KcPageStory";

const { kcContext } = createGetKcContext<KcContextExtension>({
  mockData: [
    {
      pageId: "register.ftl",
      // Reuse social mock from login page
      social: getKcContextMock({
        pageId: "login.ftl",
        overrides: {},
      }).kcContext.social,
    },
  ],
});
```

---

##### **Step 3: Use in Component**

**src/login/pages/Register.tsx**:

```tsx
export default function Register({ kcContext, ...props }: PageProps<Extract<KcContext, { pageId: "register.ftl" }>>) {
  const { social } = kcContext; // ✅ TypeScript giờ biết social.providers exists

  return (
    <div>
      {social.providers.map(p => (
        <button key={p.providerId}>
          Sign up with {p.displayName}
        </button>
      ))}
    </div>
  );
}
```

**Result**: ✅ No TypeScript errors, có autocomplete!

---

#### **Q7: How do I add extra pages?**

**Answer**: ❌ **You can't add NEW pages** - Keycloak controls authentication flow.

**Why**: Theme only customizes **existing pages** defined by Keycloak.

**Workaround for Multi-Step Registration**:

Dynamically swap React components **within single page**:

```tsx
export default function Register({ kcContext }: PageProps) {
  const [step, setStep] = useState(1);

  if (step === 1) return <StepBasicInfo onNext={() => setStep(2)} />;
  if (step === 2) return <StepAddress onNext={() => setStep(3)} />;
  if (step === 3) return <StepConfirmation />;
}
```

---

**Exception: Custom Keycloak Java Extension**

Nếu bạn có custom Java extension định nghĩa new user-facing pages:

📖 **Follow guide**: [Styling a Custom Page Not Included in Base Keycloak](https://docs.keycloakify.dev/features/styling-a-custom-page-not-included-in-base-keycloak)

---

### 12.2. Browser Process Management for Automation

**⚠️ CRITICAL**: Khi kill automation browser, **CHỈ kill specific PID**, KHÔNG kill all Chrome!

#### **Safe Method**:

```bash
# 1️⃣ List all Chrome processes
ps aux | grep -i chrome | grep -v grep

# 2️⃣ Identify automation browser PID
# Look for: "node .../chrome-devtools-mcp" or similar automation process
# Example output:
#   user  84735  ... node /path/chrome-devtools-mcp  ⬅️ This is automation
#   user 361127  ... /opt/google/chrome/chrome       ⬅️ User's Chrome (DON'T TOUCH)

# 3️⃣ Kill ONLY automation PID
kill -9 84735
```

#### **❌ DANGEROUS Commands (NEVER USE)**:

```bash
pkill -f chrome       # ❌ Kills ALL Chrome (including user's browser with 50+ tabs!)
killall chrome        # ❌ Same problem
```

**Why Dangerous**: User có thể đang dùng Chrome với nhiều tabs → mất hết work!

#### **Tip**: Automation browsers thường có:
- Process name chứa "devtools", "puppeteer", "playwright", "selenium"
- Parent process là Node.js hoặc testing framework

---

## 🎓 Next Steps

1. ✅ **Clone starter & run Storybook**
2. ✅ **Apply CSS customizations**
3. ✅ **Test trong Keycloak Docker**
4. ✅ **Eject pages & custom với component library**
5. ✅ **Setup i18n**
6. ✅ **Build JAR & deploy**

### Advanced Topics (tự explore)

- [Compiler Options](https://docs.keycloakify.dev/features/compiler-options)
- [keycloakVersionTargets](https://docs.keycloakify.dev/features/compiler-options/keycloakversiontargets)
- [startKeycloakOptions](https://docs.keycloakify.dev/features/compiler-options/startkeycloakoptions)
- [themeName](https://docs.keycloakify.dev/features/compiler-options/themename)
- [CI/CD với GitHub Actions](https://github.com/keycloakify/keycloakify-starter/blob/main/.github/workflows/ci.yaml)

---

## 📞 Support & Community

- 💬 [Discord](https://discord.gg/kYFZG7fQmn) - Fastest response
- 🐛 [GitHub Issues](https://github.com/keycloakify/keycloakify/issues) - Bug reports & feature requests
- 📖 [Official Docs](https://docs.keycloakify.dev) - Comprehensive documentation
- 🎨 [Storybook Demo](https://storybook.keycloakify.dev) - Live examples

---

## 📝 License

Tài liệu này được chia sẻ dưới MIT License.

**Credits**: Biên soạn từ [docs.keycloakify.dev](https://docs.keycloakify.dev) (Official documentation) và [Context7](https://www.context7.com).

---

*Tài liệu được tạo vào: February 2026*
*Keycloakify Version: v11*
*React Version: 18+*
*Keycloak Compatible: 11 - 26+*
