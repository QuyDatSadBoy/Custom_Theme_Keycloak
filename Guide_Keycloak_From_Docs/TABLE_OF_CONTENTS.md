# 📚 Keycloakify v11 Complete Guide - Table of Contents

> **Quick Navigation Guide for AI Agents**  
> This document maps the entire [KEYCLOAKIFY_COMPLETE_GUIDE.md](KEYCLOAKIFY_COMPLETE_GUIDE.md) structure.

---

## 📊 Document Overview

- **Total Lines**: 2357
- **Sections**: 12 major sections + 2 appendices
- **Language**: Vietnamese (with English code examples)
- **Framework**: React + TypeScript + Vite
- **Keycloak Versions**: 11-26+

---

## 🗂️ Section Index with Line Numbers

### Section 1: Giới Thiệu (Lines 24-56)
**Topics**: What is Keycloakify, How it works, Key benefits, Requirements

**Key Concepts**:
- Client-side rendering architecture
- FreeMarker → React transformation
- No backend changes needed

---

### Section 2: Quick Start (Lines 57-106)
**Topics**: Installation, First 5-minute test, Project structure

**Includes**:
- Clone starter repo
- Storybook preview
- Understanding `kc.gen.tsx` (auto-generated)
- Key directory structure

---

### Section 3: CSS Customization (Lines 107-228)
**Topics**: 6 methods to customize theme appearance

**Methods Covered**:
1. PatternFly CSS variables override
2. Custom CSS import
3. Inline styles
4. CSS Modules
5. styled-components/Emotion
6. Tailwind CSS setup

**Special Topics**: Geist font integration, @apply directive

---

### Section 4: Testing Your Theme (Lines 229-393)

#### 4.1: Testing Outside Keycloak (Lines 231-293)
- Storybook setup & usage
- Creating custom stories
- **Alternative**: Dev mode testing without Storybook (Lines 284-293)

#### 4.2: Testing Inside Keycloak (Lines 295-393)
- Docker prerequisites (Maven, Docker Desktop)
- `npx keycloakify start-keycloak` workflow
- Test web app integration
- Advanced options with `startKeycloakOptions`

---

### Section 5: Deploying Your Theme (Lines 394-478)
**Topics**: Building JAR files, Loading into Keycloak, Enabling theme

**Deployment Targets**:
- Docker / Docker Compose
- Helm (Kubernetes)
- Bare Metal

**Key Info**: JAR file selection for different Keycloak versions

---

### Section 6: Common Use Case Examples (Lines 479-788)

#### 6.1: Using Component Library (Lines 481-510)
- Why starter has few components (DefaultPage architecture)
- Eject page workflow
- Video tutorial: MUI integration

#### 6.2: Custom Fonts (Lines 512-582)
- Option 1: Google Fonts
- Option 2: Self-hosted fonts (internal networks)

#### 6.3: Changing Background (Lines 584-600)
- Image imports via bundler
- Public directory method

#### 6.4: Adding Logo (Lines 602-633)
- Asset bundling strategies

#### 6.5: Using Tailwind CSS (Lines 635-699)
- Complete 3-step setup
- Geist font integration
- @apply directive for classes

#### 6.6: Dark Mode Persistence (Lines 701-788)
- App → Login theme communication via query params
- Session storage pattern
- React state synchronization
- MUI theme integration example

---

### Section 7: Internationalization (i18n) (Lines 789-1037)

#### 7.1: Basic Setup (Lines 791-895)
- `i18n.ts` configuration
- `.withCustomTranslations()` method
- Adding extra languages

#### 7.2: Accessing Translations (Lines 897-1037)
- In Regular Pages: `msg()` function
- In Template.tsx: `msgStr()` for simple strings
- In User Profile (UPF): `advancedMsg()` + `advancedMsgStr()`
- Message formatting with variables

---

### Section 8: Advanced Features (Lines 1038-1324)

#### 8.1: Theme Variants (Lines 1040-1088)
- Build multiple themes from single codebase
- `themeName: ["light", "dark"]` approach
- Different translations per variant

#### 8.2: Environment Variables (Lines 1090-1165)
- `environmentVariables` config option
- `kcContext.properties` access
- Docker/Helm/Bare Metal setup examples

#### 8.3: Exclude Sensitive Data (kcContextExclusionsFtl) (Lines 1167-1252)
- FreeMarker filtering
- Hide realm attributes
- Use cases: custom plugins, security

#### 8.4: Custom Pages (Lines 1254-1324)
- Styling pages not in base Keycloak
- Custom Java extension integration
- Example: FranceConnect

---

### Section 9: Page-Specific Guides (Lines 1325-1402)

#### 9.1: Registration Page (Lines 1327-1357)
- Video tutorial (8 timestamps)
- User profile customization
- Password policies
- Storybook workflow

#### 9.2: Terms & Conditions Page (Lines 1359-1402)
- Enabling feature in Keycloak
- Defining `termsText` attribute
- Customizing rendering (iframe option)

---

### Section 10: Theme Types (Lines 1403-1577)

#### 10.1: Login Theme (Lines 1405-1467)
- Default theme type
- Most commonly used
- Architecture overview

#### 10.2: Account Theme (Lines 1469-1515)
- **Decision guide**: Do you really need account theme?
- **Single-Page** (account v3): React, i18next, react-router, PatternFly
  - Pros: Latest features, maintained by Keycloak team
  - Cons: Many dependencies, no Storybook, React only
- **Multi-Page** (account v1): Traditional approach
  - Pros: Like login theme, Storybook support, all frameworks
  - Cons: Missing features, dated look

#### 10.3: Email Theme (Lines 1517-1558)
- **keycloakify-emails plugin**: jsx-email approach (Vite only)
- **Native FreeMarker**: Traditional method
- Assets handling with `${url.resourcesUrl}/`

#### 10.4: Admin Theme (Lines 1560-1577)
- Custom Keycloak Admin Console
- `npx keycloakify initialize-admin-theme`
- React only

---

### Section 11: Alternative Starter Themes (Lines 1706-1878)

#### 11.1: Shadcn UI Starter (Lines 1710-1806)
- **8-step detailed setup** (lines 1734-1799):
  1. Install Shadcn CLI
  2. Configure components.json
  3. Init Shadcn components
  4. Update vite.config.ts (path aliases + accountThemeImplementation)
  5. Update TypeScript paths (tsconfig)
  6. **Git init REQUIRED** (Keycloakify tracks file changes)
  7. Key commands
  8. Understanding "Own" command (eject concept)
- Storybook demo & resources

#### 11.2: MUI (Material-UI) Starter (Lines 1808-1835)
- Quick setup
- PatternFly + MUI styling
- Resources

#### 11.3: When to Use Starter Themes (Lines 1837-1878)
- Use case scenarios
- Comparison table

---

### Section 12: FAQ & Troubleshooting (Lines 1879-2226)

#### Q1: How Keycloakify Works (Lines 1883-1908)
- FreeMarker → React compilation
- `kcContext` injection
- Build process

#### Q2: Asset Imports Not Working (Lines 1910-1959)
- **Solution 1**: Import in component (recommended)
- **Solution 2**: Public directory + BASE_URL
- When to use each

#### Q3: Is window.kcContext a Security Concern? (Lines 1961-2018)
- **Answer**: ✅ Safe, no sensitive data
- Architecture explanation (backend → client shift)
- What's included vs excluded
- Custom plugin filtering with `kcContextExclusionsFtl`
- patch-package approach

#### Q4: How to Identify Page to Customize (Lines 2020-2061)
- DevTools method: `window.kcContext.pageId`
- Scenarios: No kcContext, Page not in Storybook

#### Q5: Can I Use react-hook-form? (Lines 2063-2097)
- Why it's complex (client-side validation ≠ Keycloak policies)
- **Better solution**: `useUserProfileForm` hook (similar API)

#### Q6: How to Extend KcContext Types (Lines 2099-2136)
- Adding custom attributes
- `KcContextExtension` pattern
- Type-safe access

#### Q7: Can I Add Extra Pages? (Lines 2138-2187)
- **Answer**: ❌ No (limited by Keycloak)
- **Workaround**: Multi-step forms within single page (React state)
- **Exception**: Custom Java extensions

#### 12.2: Browser Process Management (Lines 2189-2226)
- Safe method to kill automation browsers only
- ❌ Dangerous commands to avoid
- PID identification tips

---

### Appendix: Resources (Lines 1578-1705)

#### Why Design System Not Included (Lines 1580-1640)
- Keycloakify's internal architecture
- How to add your own design system
- Eject page strategy

#### Troubleshooting Common Errors (Lines 1642-1705)
- Missing dependencies
- Port conflicts
- Theme not appearing
- Build errors

---

### Appendix A: Compiler Options Reference (Lines 2227-2342)

**Complete Options Table** (12+ options):
- `themeName`: Theme name in Admin UI / theme variants
- `keycloakVersionTargets`: Customize JAR builds
- `environmentVariables`: Pass env vars to theme
- `kcContextExclusionsFtl`: Hide sensitive data
- `startKeycloakOptions`: Docker testing config
- `accountThemeImplementation`: Single-Page / Multi-Page / none
- Plus: themeVersion, postBuild, XDG_CACHE_HOME, etc.

**startKeycloakOptions Breakdown** (Lines 2312-2337):
- 6 sub-options detailed:
  1. `dockerImage`: Custom Docker image (e.g., Phase Two Keycloak)
  2. `dockerExtraArgs`: Extra docker run args
  3. `keycloakExtraArgs`: Keycloak startup args
  4. `extensionJars`: Load custom extensions (URLs or local paths)
  5. `realmJsonFilePath`: Custom realm config
  6. `port`: Change default port (8080 → custom)
- Common use cases table
- Resulting Docker command example

---

### Next Steps & Resources (Lines 2343-2375)
- Learning roadmap (6 steps)
- Advanced topics links
- Support channels (Discord, GitHub, Docs)

---

## 🔍 Information Lookup Strategy for AI Agents

### ✅ **Covered in KEYCLOAKIFY_COMPLETE_GUIDE.md**

Use line numbers above to jump directly to relevant sections:

| Topic | Section | Lines |
|-------|---------|-------|
| **Installation & Setup** | Section 2 | 57-106 |
| **CSS Methods** | Section 3 | 107-228 |
| **Storybook Testing** | Section 4.1 | 231-293 |
| **Docker Testing** | Section 4.2 | 295-393 |
| **Building JAR** | Section 5 | 394-478 |
| **Component Libraries** | Section 6.1 | 481-510 |
| **Fonts** | Section 6.2 | 512-582 |
| **Tailwind Setup** | Section 6.5 | 635-699 |
| **Dark Mode** | Section 6.6 | 701-788 |
| **i18n Setup** | Section 7.1 | 791-895 |
| **Theme Variants** | Section 8.1 | 1040-1088 |
| **Environment Variables** | Section 8.2 | 1090-1165 |
| **Security (kcContext)** | Section 8.3 | 1167-1252 |
| **Account Theme** | Section 10.2 | 1469-1515 |
| **Email Theme** | Section 10.3 | 1517-1558 |
| **Shadcn UI Setup** | Section 11.1 | 1710-1806 |
| **MUI Starter** | Section 11.2 | 1808-1835 |
| **FAQ (7 questions)** | Section 12 | 1879-2226 |
| **Compiler Options** | Appendix A | 2227-2342 |
| **startKeycloakOptions** | Appendix A | 2312-2337 |

---

### ❌ **NOT Covered - Search Externally**

When topic is NOT in guide, use these resources:

#### 1. **Official Keycloakify Docs** (Primary Source)
- 🔗 URL: https://docs.keycloakify.dev/
- **Use for**:
  - Angular/Svelte implementations
  - Latest API changes (guide is snapshot)
  - Detailed compiler options reference
  - Release notes & migration guides
  
**Example Query**: "How to use Keycloakify with Angular framework?"
→ Search https://docs.keycloakify.dev/ and cite URL

---

#### 2. **Context7 / Web Search** (API Documentation)
- **Use for**:
  - Latest npm package versions
  - Breaking changes in new releases
  - Third-party library integration (MUI, Shadcn updates)
  - Keycloak REST API details

**Example Query**: "What's new in Keycloakify v11.2.0?"
→ Use Context7 search → cite result

---

#### 3. **Keycloak Official Docs** (Server-Side)
- 🔗 URL: https://www.keycloak.org/documentation
- **Use for**:
  - Realm configuration
  - User profile attributes (UPA)
  - Authentication flows
  - Password policies
  - Keycloak REST API reference

**Example Query**: "How to configure password policy in Keycloak?"
→ Search Keycloak docs → cite URL

---

#### 4. **GitHub Repository** (Code Examples)
- 🔗 Main Repo: https://github.com/keycloakify/keycloakify
- 🔗 Starter Repo: https://github.com/keycloakify/keycloakify-starter
- **Use for**:
  - CI/CD pipeline examples (.github/workflows)
  - Bug reports & feature requests (Issues)
  - Source code reference (src/)
  - Advanced customization examples (Discussions)

**Example Query**: "How to setup GitHub Actions for Keycloakify?"
→ Check https://github.com/keycloakify/keycloakify-starter/.github/workflows/

---

#### 5. **Community Support**
- 💬 Discord: https://discord.gg/kYFZG7fQmn (fastest response)
- 🐛 GitHub Issues: For bug reports
- 📺 YouTube: Video tutorials (search "Keycloakify")

---

## 🤖 Recommended Workflow for AI Agents

### Step 1: Check TABLE_OF_CONTENTS.md
```
Question: "How to add custom font?"
↓
TOC Search: "fonts" → Section 6.2 (lines 512-582)
↓
Read KEYCLOAKIFY_COMPLETE_GUIDE.md lines 512-582
↓
Answer with line number reference
```

### Step 2: If Not Found in Guide
```
Question: "How to use Keycloakify with Angular?"
↓
TOC Search: "Angular" → ❌ Not covered
↓
Search https://docs.keycloakify.dev/ (official docs)
↓
Answer with external URL citation
```

### Step 3: Always Cite Sources
```markdown
❌ Bad: "You can add custom fonts by importing them."
✅ Good: "You can add custom fonts using 2 methods (see Section 6.2, lines 512-582):
1. Google Fonts via CDN
2. Self-hosted fonts in src/login/assets/
Full guide: [KEYCLOAKIFY_COMPLETE_GUIDE.md](KEYCLOAKIFY_COMPLETE_GUIDE.md#62-custom-fonts)"
```

---

## 📌 Quick Reference Commands

### Jump to Section
```bash
# Open guide at specific line
code KEYCLOAKIFY_COMPLETE_GUIDE.md:789  # i18n section

# Search for keyword
grep -n "Tailwind" KEYCLOAKIFY_COMPLETE_GUIDE.md
```

### Verify Line Numbers (if guide updated)
```bash
grep -n "^## [0-9]\|^## 🎓\|^## 📚\|^## 📞" KEYCLOAKIFY_COMPLETE_GUIDE.md
```

---

## 🔄 Maintenance Notes

**When to Update TOC**:
- ✅ Major sections added/removed
- ✅ Line numbers shift significantly (>50 lines)
- ✅ New appendices added
- ❌ Minor content edits within sections (no need)

**Last Updated**: February 6, 2026  
**Guide Version**: v11 (2357 lines)  
**Next Review**: When Keycloakify v12 released

---

**📖 Main Guide**: [KEYCLOAKIFY_COMPLETE_GUIDE.md](KEYCLOAKIFY_COMPLETE_GUIDE.md)  
**⚙️ Coding Conventions**: [.github/copilot-instructions.md](../.github/copilot-instructions.md)
