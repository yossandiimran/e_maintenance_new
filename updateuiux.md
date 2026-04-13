# 🎨 Update UI/UX — Linear Design System

> **Scope:** Pembaruan tampilan dan pengalaman pengguna secara menyeluruh mengikuti `DESIGN.md`.
> **⚠️ Tidak menyentuh logika bisnis** — semua perubahan murni pada layer presentasi: styling, layout, animasi, dan interaksi visual.
> **Referensi:** [`DESIGN.md`](./DESIGN.md) — *Linear-inspired dark design system*

---

## 📋 Daftar Isi

1. [Design Tokens & CSS Variables](#1-design-tokens--css-variables)
2. [Typography](#2-typography)
3. [Warna & Surface](#3-warna--surface)
4. [Spacing & Layout](#4-spacing--layout)
5. [Depth & Elevation](#5-depth--elevation)
6. [Komponen — Button](#6-komponen--button)
7. [Komponen — Card & Container](#7-komponen--card--container)
8. [Komponen — Badge & Pill](#8-komponen--badge--pill)
9. [Komponen — Input & Form](#9-komponen--input--form)
10. [Navigasi — Header & Sidebar](#10-navigasi--header--sidebar)
11. [Navigasi — Breadcrumb & Tabs](#11-navigasi--breadcrumb--tabs)
12. [Tabel & Data Display](#12-tabel--data-display)
13. [Modal, Dialog & Overlay](#13-modal-dialog--overlay)
14. [Notifikasi & Feedback](#14-notifikasi--feedback)
15. [Loading & Empty State](#15-loading--empty-state)
16. [Animasi & Transisi](#16-animasi--transisi)
17. [Responsivitas & Breakpoint](#17-responsivitas--breakpoint)
18. [Aksesibilitas (a11y)](#18-aksesibilitas-a11y)
19. [Do's & Don'ts — Linear Rules](#19-dos--donts--linear-rules)
20. [Checklist Implementasi](#20-checklist-implementasi)

---

## 1. Design Tokens & CSS Variables

Semua nilai visual **wajib** berasal dari token ini. Tidak ada nilai warna, ukuran, atau jarak yang ditulis langsung (hardcoded) di komponen.

```css
/* ============================================================
   tokens.css — Linear-inspired Design System
   Referensi: DESIGN.md
   ============================================================ */

:root {

  /* FONT */
  --font-sans: 'Inter Variable', 'SF Pro Display', -apple-system,
               system-ui, 'Segoe UI', Roboto, sans-serif;
  --font-mono: 'Berkeley Mono', ui-monospace, 'SF Mono', Menlo, monospace;

  /* OpenType features — WAJIB pada semua elemen teks Inter */
  --font-features: "cv01", "ss03";

  /* BACKGROUND SURFACES */
  --color-bg-marketing:   #08090a;   /* Deepest canvas, hero section */
  --color-bg-page:        #010102;   /* Page root (flat canvas) */
  --color-bg-panel:       #0f1011;   /* Sidebar, panel background */
  --color-bg-surface:     #191a1b;   /* Cards, dropdowns, elevated */
  --color-bg-surface-2:   #28282c;   /* Hover state, slightly raised */

  /* Translucent surfaces — gunakan ini, bukan solid */
  --color-surface-l1:     rgba(255,255,255,0.02);  /* Flat cards */
  --color-surface-l2:     rgba(255,255,255,0.04);  /* Subtle buttons */
  --color-surface-l3:     rgba(255,255,255,0.05);  /* Hover/elevated */

  /* TEXT */
  --color-text-primary:   #f7f8f8;   /* Heading — near-white, bukan pure white */
  --color-text-secondary: #d0d6e0;   /* Body — silver-gray */
  --color-text-tertiary:  #8a8f98;   /* Placeholder, muted */
  --color-text-quaternary:#62666d;   /* Timestamp, disabled */
  --color-text-button:    #e2e4e7;   /* Ghost button text */

  /* BRAND & ACCENT */
  --color-brand:          #5e6ad2;   /* Primary CTA background */
  --color-accent:         #7170ff;   /* Interactive accent, links */
  --color-accent-hover:   #828fff;   /* Hover pada elemen accent */
  --color-security:       #7a7fad;   /* Security-related UI only */

  /* STATUS */
  --color-success:        #27a644;   /* Active / in-progress */
  --color-success-pill:   #10b981;   /* Pill badge, completion */

  /* BORDER */
  --color-border-subtle:  rgba(255,255,255,0.05);  /* Default border */
  --color-border-standard:rgba(255,255,255,0.08);  /* Cards, inputs */
  --color-border-solid-1: #23252a;   /* Prominent separator */
  --color-border-solid-2: #34343a;   /* Slightly lighter solid */
  --color-border-solid-3: #3e3e44;   /* Lightest solid border */
  --color-border-ghost:   rgb(36,40,44);            /* Ghost button */
  --color-border-pill:    rgb(35,37,42);             /* Pill border */
  --color-line-tint:      #141516;   /* Nearly invisible divider */
  --color-line-tertiary:  #18191a;   /* Slightly visible divider */

  /* OVERLAY */
  --color-overlay:        rgba(0,0,0,0.85);

  /* BORDER RADIUS */
  --radius-micro:    2px;       /* Inline badge, toolbar button */
  --radius-sm:       4px;       /* Small containers, list items */
  --radius-md:       6px;       /* Buttons, inputs */
  --radius-card:     8px;       /* Cards, dropdowns, popovers */
  --radius-panel:    12px;      /* Panels, featured cards */
  --radius-large:    22px;      /* Large panel elements */
  --radius-pill:     9999px;    /* Chips, filter pills */
  --radius-circle:   50%;       /* Icon buttons, avatars */

  /* SPACING (8px grid) */
  --space-px:   1px;
  --space-1:    4px;
  --space-1-5:  7px;
  --space-2:    8px;
  --space-2-5:  11px;
  --space-3:    12px;
  --space-4:    16px;
  --space-5:    20px;
  --space-6:    24px;
  --space-7:    28px;
  --space-8:    32px;
  --space-10:   40px;
  --space-12:   48px;
  --space-16:   64px;
  --space-20:   80px;

  /* SHADOW / ELEVATION */
  --shadow-flat:    none;
  --shadow-micro:   rgba(0,0,0,0.03) 0px 1.2px 0px 0px;
  --shadow-inset:   rgba(0,0,0,0.2) 0px 0px 12px 0px inset;
  --shadow-ring:    rgba(0,0,0,0.2) 0px 0px 0px 1px;
  --shadow-elevated:rgba(0,0,0,0.4) 0px 2px 4px;
  --shadow-focus:   rgba(0,0,0,0.1) 0px 4px 12px;
  --shadow-dialog:
    rgba(0,0,0,0) 0px 8px 2px,
    rgba(0,0,0,0.01) 0px 5px 2px,
    rgba(0,0,0,0.04) 0px 3px 2px,
    rgba(0,0,0,0.07) 0px 1px 1px,
    rgba(0,0,0,0.08) 0px 0px 1px;

  /* ANIMATION */
  --duration-instant: 80ms;
  --duration-fast:    120ms;
  --duration-normal:  200ms;
  --duration-slow:    300ms;
  --ease-out:   cubic-bezier(0, 0, 0.2, 1);
  --ease-spring:cubic-bezier(0.16, 1, 0.3, 1);
  --ease-in-out:cubic-bezier(0.4, 0, 0.2, 1);

  /* Z-INDEX */
  --z-base:     0;
  --z-raised:   10;
  --z-dropdown: 100;
  --z-sticky:   200;
  --z-overlay:  300;
  --z-modal:    400;
  --z-toast:    500;
  --z-tooltip:  600;
}
```

### Base Global
```css
*, *::before, *::after { box-sizing: border-box; }

body {
  font-family: var(--font-sans);
  font-feature-settings: var(--font-features);  /* WAJIB */
  background-color: var(--color-bg-page);
  color: var(--color-text-secondary);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code, pre, .mono {
  font-family: var(--font-mono);
}
```

---

## 2. Typography

> **Aturan Linear:** Inter Variable wajib dengan `"cv01","ss03"`. Tiga weight: **400** (baca), **510** (navigasi/emphasis — signature Linear), **590** (announce). Maksimum 590, jangan gunakan 700/bold.

### CSS Variables Tipografi
```css
:root {
  /* Font Size */
  --text-display-xl: 4.5rem;    /* 72px — Hero headline */
  --text-display-lg: 4rem;      /* 64px — Secondary hero */
  --text-display:    3rem;      /* 48px — Section headline */
  --text-h1:         2rem;      /* 32px — Major section title */
  --text-h2:         1.5rem;    /* 24px — Sub-section heading */
  --text-h3:         1.25rem;   /* 20px — Feature title, card header */
  --text-body-lg:    1.125rem;  /* 18px — Intro / feature desc */
  --text-body-em:    1.0625rem; /* 17px — Emphasized body */
  --text-body:       1rem;      /* 16px — Standard body */
  --text-small:      0.9375rem; /* 15px — Secondary body */
  --text-caption-lg: 0.875rem;  /* 14px — Sub-labels */
  --text-caption:    0.8125rem; /* 13px — Metadata, nav links */
  --text-label:      0.75rem;   /* 12px — Button, small label */
  --text-micro:      0.6875rem; /* 11px — Tiny label */
  --text-tiny:       0.625rem;  /* 10px — Overline, badge */

  /* Font Weight */
  --weight-light:    300;
  --weight-regular:  400;
  --weight-ui:       510;    /* Linear signature weight */
  --weight-semibold: 590;

  /* Letter Spacing — semakin besar ukuran, semakin negatif */
  --tracking-display-xl: -1.584px;
  --tracking-display-lg: -1.408px;
  --tracking-display:    -1.056px;
  --tracking-h1:         -0.704px;
  --tracking-h2:         -0.288px;
  --tracking-h3:         -0.24px;
  --tracking-body-lg:    -0.165px;
  --tracking-small:      -0.165px;
  --tracking-caption-lg: -0.182px;
  --tracking-caption:    -0.13px;
  --tracking-normal:      0em;
}
```

### Kelas Tipografi
```css
/* Display */
.text-display-xl {
  font-size: var(--text-display-xl);
  font-weight: var(--weight-ui);           /* 510 */
  line-height: 1.00;
  letter-spacing: var(--tracking-display-xl);
  color: var(--color-text-primary);
}

.text-display {
  font-size: var(--text-display);
  font-weight: var(--weight-ui);
  line-height: 1.00;
  letter-spacing: var(--tracking-display);
  color: var(--color-text-primary);
}

/* Headings */
.text-h1 {
  font-size: var(--text-h1);
  font-weight: var(--weight-regular);      /* 400 — H1 pakai regular! */
  line-height: 1.13;
  letter-spacing: var(--tracking-h1);
  color: var(--color-text-primary);
}

.text-h2 {
  font-size: var(--text-h2);
  font-weight: var(--weight-regular);
  line-height: 1.33;
  letter-spacing: var(--tracking-h2);
  color: var(--color-text-primary);
}

.text-h3 {
  font-size: var(--text-h3);
  font-weight: var(--weight-semibold);     /* 590 */
  line-height: 1.33;
  letter-spacing: var(--tracking-h3);
  color: var(--color-text-primary);
}

/* Body */
.text-body-lg {
  font-size: var(--text-body-lg);
  font-weight: var(--weight-regular);
  line-height: 1.60;
  letter-spacing: var(--tracking-body-lg);
  color: var(--color-text-secondary);
}

.text-body {
  font-size: var(--text-body);
  font-weight: var(--weight-regular);
  line-height: 1.50;
  color: var(--color-text-secondary);
}

.text-body-ui {
  font-size: var(--text-body);
  font-weight: var(--weight-ui);           /* 510 — nav, label */
  line-height: 1.50;
  color: var(--color-text-secondary);
}

/* Small */
.text-small {
  font-size: var(--text-small);
  font-weight: var(--weight-regular);
  line-height: 1.60;
  letter-spacing: var(--tracking-small);
  color: var(--color-text-tertiary);
}

/* Caption & Label */
.text-caption {
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  line-height: 1.50;
  letter-spacing: var(--tracking-caption);
  color: var(--color-text-quaternary);
}

.text-label {
  font-size: var(--text-label);
  font-weight: var(--weight-ui);
  line-height: 1.40;
  color: var(--color-text-secondary);
}

/* Monospace */
.text-mono {
  font-family: var(--font-mono);
  font-size: var(--text-caption-lg);
  font-weight: var(--weight-regular);
  line-height: 1.50;
  color: var(--color-text-secondary);
}
```

---

## 3. Warna & Surface

> **Prinsip Linear:** Dark-mode adalah native medium. Background menggunakan translucent `rgba` putih, bukan solid. Elevasi dikomunikasikan lewat **luminance stepping**.

### Hierarki Surface (dari paling dalam ke paling terang)
```
  Level 3 — rgba(255,255,255,0.05)  ← Hover, toolbar active
  Level 2 — rgba(255,255,255,0.04)  ← Subtle button bg
  Level 1 — rgba(255,255,255,0.02)  ← Card flat, container

  #28282c  ← Secondary surface (lightest solid dark)
  #191a1b  ← Surface (card solid bg, dropdowns)
  #0f1011  ← Panel dark (sidebar, panel)
  #08090a  ← Marketing black (hero bg)
  #010102  ← Page root (deepest canvas)
```

### Penggunaan Warna
```css
/* BENAR — gunakan token */
.card    { background: var(--color-surface-l1); }
.sidebar { background: var(--color-bg-panel); }
.btn-cta { background: var(--color-brand); }
.card    { border: 1px solid var(--color-border-standard); }

/* SALAH — hardcode & solid border gelap */
.card    { background: rgba(255,255,255,0.02); }   /* jangan */
.card    { border: 1px solid #333; }               /* jangan */
```

---

## 4. Spacing & Layout

### Grid & Container
```css
.container {
  width: 100%;
  max-width: 1200px;
  margin-inline: auto;
  padding-inline: var(--space-4);
}

@media (min-width: 768px)  { .container { padding-inline: var(--space-6); } }
@media (min-width: 1024px) { .container { padding-inline: var(--space-8); } }

/* Layout utama */
.app-layout {
  display: grid;
  grid-template-columns: 240px 1fr;
  grid-template-rows: 48px 1fr;
  min-height: 100vh;
  background: var(--color-bg-page);
}

/* Section spacing */
.section        { padding-block: var(--space-20); }   /* 80px */
@media (max-width: 768px) {
  .section      { padding-block: var(--space-12); }   /* 48px */
}
```

### Struktur Halaman
```
┌────────────────────────────────────────────┐  bg: #0f1011
│  TOPBAR                     height: 48px  │  border: rgba(255,255,255,0.05)
├──────────┬─────────────────────────────────┤
│          │  PAGE TITLE + BREADCRUMB        │  padding: 24px 32px
│ SIDEBAR  ├─────────────────────────────────┤
│          │                                 │
│ 240px    │       MAIN CONTENT              │  bg: #010102
│ #0f1011  │                                 │  padding: 24px 32px
│          │                                 │
└──────────┴─────────────────────────────────┘
```

---

## 5. Depth & Elevation

> Linear tidak pakai drop-shadow untuk elevasi. Elevasi menggunakan luminance stepping (background makin terang) dan semi-transparent white border.

| Level | CSS Treatment | Penggunaan |
|-------|--------------|-----------|
| **Flat (0)** | `bg: #010102; no shadow` | Page canvas |
| **Micro (1)** | `box-shadow: var(--shadow-micro)` | Toolbar button |
| **Surface (2)** | `bg: var(--color-surface-l1)` + `border: standard` | Card, input |
| **Inset (2b)** | `box-shadow: var(--shadow-inset)` | Recessed panel |
| **Ring (3)** | `box-shadow: var(--shadow-ring)` | Border-as-shadow |
| **Elevated (4)** | `box-shadow: var(--shadow-elevated)` | Dropdown, floating |
| **Dialog (5)** | `box-shadow: var(--shadow-dialog)` | Modal, command palette |
| **Focus** | `box-shadow: var(--shadow-focus)` | Keyboard focus |

```css
/* Card — Level 2 */
.card {
  background: var(--color-surface-l1);
  border: 1px solid var(--color-border-standard);
  box-shadow: var(--shadow-ring);
}
.card:hover { background: var(--color-surface-l2); }

/* Dropdown — Level 4 */
.dropdown__menu {
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border-standard);
  box-shadow: var(--shadow-elevated);
}

/* Modal — Level 5 */
.modal__panel {
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border-standard);
  box-shadow: var(--shadow-dialog);
}
```

---

## 6. Komponen — Button

```html
<!-- Primary Brand — CTA utama -->
<button class="btn btn--brand">Start Building</button>

<!-- Ghost — aksi sekunder -->
<button class="btn btn--ghost">Lihat Detail</button>

<!-- Subtle — toolbar, kontekstual -->
<button class="btn btn--subtle">Filter</button>

<!-- Pill — tag, filter chip -->
<button class="btn btn--pill">All Issues</button>

<!-- Icon circle -->
<button class="btn btn--icon" aria-label="Tutup">
  <svg width="16" height="16" aria-hidden="true"><!-- X --></svg>
</button>

<!-- Toolbar small -->
<button class="btn btn--toolbar">
  <svg width="12" height="12" aria-hidden="true"><!-- icon --></svg>
  Edit
</button>

<!-- Loading state -->
<button class="btn btn--brand" disabled aria-busy="true">
  <span class="btn__spinner" aria-hidden="true"></span>
  Menyimpan...
</button>
```

```css
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-1);
  border: 1px solid transparent;
  cursor: pointer;
  font-family: var(--font-sans);
  font-feature-settings: var(--font-features);
  font-size: var(--text-small);
  font-weight: var(--weight-ui);             /* 510 */
  line-height: 1.50;
  white-space: nowrap;
  user-select: none;
  text-decoration: none;
  transition:
    background var(--duration-fast) var(--ease-out),
    border-color var(--duration-fast) var(--ease-out),
    color var(--duration-fast) var(--ease-out),
    box-shadow var(--duration-fast) var(--ease-out),
    transform var(--duration-instant) var(--ease-out);
}

.btn:focus-visible {
  outline: none;
  box-shadow: var(--shadow-focus), 0 0 0 2px var(--color-bg-panel),
              0 0 0 4px var(--color-accent);
}

.btn:active:not(:disabled) { transform: scale(0.97); }
.btn:disabled { opacity: 0.4; cursor: not-allowed; pointer-events: none; }

/* Brand */
.btn--brand {
  background: var(--color-brand);
  color: #ffffff;
  padding: 8px 16px;
  border-radius: var(--radius-md);
  border-color: var(--color-brand);
}
.btn--brand:hover:not(:disabled) {
  background: var(--color-accent-hover);
  border-color: var(--color-accent-hover);
}

/* Ghost */
.btn--ghost {
  background: var(--color-surface-l1);
  color: var(--color-text-button);
  padding: 8px 14px;
  border-radius: var(--radius-md);
  border-color: var(--color-border-ghost);
  box-shadow: var(--shadow-focus);
}
.btn--ghost:hover:not(:disabled) { background: var(--color-surface-l2); }

/* Subtle */
.btn--subtle {
  background: var(--color-surface-l2);
  color: var(--color-text-secondary);
  padding: 4px 6px;
  border-radius: var(--radius-md);
}
.btn--subtle:hover:not(:disabled) { background: var(--color-surface-l3); }

/* Pill */
.btn--pill {
  background: transparent;
  color: var(--color-text-secondary);
  padding: 0 10px 0 5px;
  border-radius: var(--radius-pill);
  border-color: var(--color-border-pill);
  font-size: var(--text-label);
}
.btn--pill:hover:not(:disabled) { background: var(--color-surface-l1); }

/* Icon circle */
.btn--icon {
  background: var(--color-surface-l2);
  color: var(--color-text-primary);
  width: 32px; height: 32px;
  padding: 0;
  border-radius: var(--radius-circle);
  border-color: var(--color-border-subtle);
}
.btn--icon:hover:not(:disabled) { background: var(--color-surface-l3); }

/* Toolbar */
.btn--toolbar {
  background: var(--color-surface-l3);
  color: var(--color-text-quaternary);
  padding: 3px 8px;
  border-radius: var(--radius-micro);
  border-color: var(--color-border-subtle);
  box-shadow: var(--shadow-micro);
  font-size: var(--text-label);
}

/* Spinner */
@keyframes btn-spin { to { transform: rotate(360deg); } }
.btn__spinner {
  width: 14px; height: 14px;
  border: 1.5px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: btn-spin 600ms linear infinite;
  flex-shrink: 0;
}
```

---

## 7. Komponen — Card & Container

```html
<!-- Card standar -->
<div class="card">
  <div class="card__header">
    <h3 class="card__title">Issue Title</h3>
    <button class="btn btn--icon" aria-label="Options"><!-- icon --></button>
  </div>
  <div class="card__body">
    <p class="text-small">Deskripsi konten.</p>
  </div>
</div>

<!-- Featured card (radius 12px) -->
<div class="card card--featured">...</div>

<!-- Inset panel (sunken/recessed) -->
<div class="card card--inset">...</div>

<!-- Stat card -->
<div class="card card--stat">
  <p class="card__stat-label">Total Issues</p>
  <p class="card__stat-value">1,247</p>
  <p class="card__stat-change card__stat-change--up">+8% dari minggu lalu</p>
</div>
```

```css
.card {
  background: var(--color-surface-l1);
  border: 1px solid var(--color-border-standard);
  border-radius: var(--radius-card);
  box-shadow: var(--shadow-ring);
  overflow: hidden;
  transition:
    background var(--duration-fast) var(--ease-out),
    border-color var(--duration-fast) var(--ease-out);
}
.card:hover { background: var(--color-surface-l2); }

.card--featured  { border-radius: var(--radius-panel); }
.card--inset     { background: transparent; box-shadow: var(--shadow-inset); border-color: var(--color-border-subtle); }

.card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--space-4) var(--space-5);
  border-bottom: 1px solid var(--color-border-subtle);
}

.card__title {
  font-size: var(--text-h3);
  font-weight: var(--weight-semibold);
  letter-spacing: var(--tracking-h3);
  color: var(--color-text-primary);
}

.card__body   { padding: var(--space-5); }
.card__footer {
  padding: var(--space-3) var(--space-5);
  border-top: 1px solid var(--color-border-subtle);
  background: rgba(0,0,0,0.1);
}

.card--stat .card__stat-value {
  font-size: var(--text-h1);
  font-weight: var(--weight-ui);
  letter-spacing: var(--tracking-h1);
  color: var(--color-text-primary);
  line-height: 1.13;
}

.card--stat .card__stat-label {
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-quaternary);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}

.card__stat-change { font-size: var(--text-caption); font-weight: var(--weight-ui); }
.card__stat-change--up   { color: var(--color-success-pill); }
.card__stat-change--down { color: #ef4444; }
```

---

## 8. Komponen — Badge & Pill

```html
<!-- Success dot (status aktif) -->
<span class="badge badge--dot" aria-label="Aktif"></span>

<!-- Success pill -->
<span class="badge badge--success">In Progress</span>

<!-- Neutral pill -->
<span class="badge badge--neutral">
  <svg width="12" height="12" aria-hidden="true"><!-- icon --></svg>
  Design
</span>

<!-- Subtle badge (inline tag, versi) -->
<span class="badge badge--subtle">v2.1</span>

<!-- Accent badge -->
<span class="badge badge--accent">Urgent</span>
```

```css
.badge {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  font-family: var(--font-sans);
  font-feature-settings: var(--font-features);
  font-weight: var(--weight-ui);
  white-space: nowrap;
}

.badge--dot {
  width: 8px; height: 8px;
  border-radius: var(--radius-circle);
  background: var(--color-success-pill);
  flex-shrink: 0;
}

.badge--success {
  background: var(--color-success-pill);
  color: var(--color-text-primary);
  padding: 1px 8px;
  border-radius: var(--radius-pill);
  font-size: var(--text-tiny);
}

.badge--neutral {
  background: transparent;
  color: var(--color-text-secondary);
  padding: 0 10px 0 5px;
  border-radius: var(--radius-pill);
  border: 1px solid var(--color-border-pill);
  font-size: var(--text-label);
}

.badge--subtle {
  background: var(--color-surface-l3);
  color: var(--color-text-primary);
  padding: 0 8px 0 2px;
  border-radius: var(--radius-micro);
  border: 1px solid var(--color-border-subtle);
  font-size: var(--text-tiny);
}

.badge--accent {
  background: rgba(94,106,210,0.2);
  color: var(--color-accent-hover);
  padding: 2px 8px;
  border-radius: var(--radius-micro);
  border: 1px solid rgba(113,112,255,0.3);
  font-size: var(--text-label);
}
```

---

## 9. Komponen — Input & Form

```html
<!-- Text Input -->
<div class="form-field">
  <label class="form-field__label" for="issue-title">Issue Title</label>
  <input id="issue-title" type="text" class="input"
         placeholder="Issue title..." aria-describedby="issue-title-hint">
  <p class="form-field__hint" id="issue-title-hint">Minimal 3 karakter</p>
</div>

<!-- Search Input -->
<div class="input-search-wrapper">
  <svg class="input-search-icon" aria-hidden="true"><!-- search --></svg>
  <input type="search" class="input input--search" placeholder="Search issues...">
  <kbd class="input-search-shortcut">⌘K</kbd>
</div>

<!-- Select -->
<div class="form-field">
  <label class="form-field__label" for="priority">Priority</label>
  <div class="select-wrapper">
    <select id="priority" class="input select">
      <option value="">Select priority...</option>
      <option value="urgent">Urgent</option>
      <option value="high">High</option>
    </select>
    <svg class="select__chevron" aria-hidden="true"><!-- chevron --></svg>
  </div>
</div>

<!-- Textarea -->
<div class="form-field">
  <label class="form-field__label" for="desc">Description</label>
  <textarea id="desc" class="input textarea" rows="4"
            placeholder="Add description..."></textarea>
</div>

<!-- Error state -->
<div class="form-field form-field--error">
  <label class="form-field__label" for="email">Email</label>
  <input id="email" type="email" class="input input--error"
         aria-invalid="true" aria-describedby="email-err">
  <p class="form-field__error" id="email-err" role="alert">
    Format email tidak valid
  </p>
</div>
```

```css
.input {
  width: 100%;
  background: var(--color-surface-l1);
  border: 1px solid var(--color-border-standard);
  border-radius: var(--radius-md);
  padding: 12px 14px;
  font-family: var(--font-sans);
  font-feature-settings: var(--font-features);
  font-size: var(--text-body);
  font-weight: var(--weight-regular);
  color: var(--color-text-secondary);
  line-height: 1.50;
  outline: none;
  transition:
    border-color var(--duration-fast) var(--ease-out),
    background var(--duration-fast) var(--ease-out),
    box-shadow var(--duration-fast) var(--ease-out);
  -webkit-appearance: none;
}

.input::placeholder       { color: var(--color-text-tertiary); }
.input:hover:not(:disabled):not(.input--error) {
  border-color: var(--color-border-solid-2);
}
.input:focus:not(.input--error) {
  background: var(--color-surface-l2);
  border-color: var(--color-accent);
  box-shadow: 0 0 0 3px rgba(113,112,255,0.15), var(--shadow-focus);
}
.input:disabled { opacity: 0.4; cursor: not-allowed; }

.input--error {
  border-color: #ef4444;
  background: rgba(239,68,68,0.05);
}
.input--error:focus { box-shadow: 0 0 0 3px rgba(239,68,68,0.15); }

/* Search */
.input-search-wrapper { position: relative; display: flex; align-items: center; }
.input--search {
  padding-left: 36px;
  padding-right: 56px;
  background: transparent;
  border-color: transparent;
  color: var(--color-text-primary);
}
.input--search:focus {
  background: var(--color-surface-l1);
  border-color: var(--color-border-subtle);
}
.input-search-icon {
  position: absolute; left: 10px;
  color: var(--color-text-tertiary); pointer-events: none;
}
.input-search-shortcut {
  position: absolute; right: 10px;
  font-family: var(--font-mono);
  font-size: var(--text-label);
  color: var(--color-text-quaternary);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-sm);
  padding: 1px 6px;
  pointer-events: none;
}

/* Form anatomy */
.form-field { display: flex; flex-direction: column; gap: var(--space-1); }

.form-field__label {
  font-size: var(--text-caption-lg);
  font-weight: var(--weight-ui);
  color: var(--color-text-secondary);
  letter-spacing: var(--tracking-caption-lg);
}

.form-field__hint {
  font-size: var(--text-caption);
  color: var(--color-text-quaternary);
}

.form-field__error {
  font-size: var(--text-caption);
  color: #ef4444;
  display: flex;
  align-items: center;
  gap: var(--space-1);
}

.textarea { min-height: 100px; resize: vertical; line-height: 1.60; }
```

---

## 10. Navigasi — Header & Sidebar

### Topbar
```html
<header class="topbar" role="banner">
  <div class="topbar__brand">
    <svg class="topbar__logo" aria-label="Logo"><!-- logo --></svg>
    <span class="topbar__brand-name">AppName</span>
  </div>

  <button class="topbar__search btn btn--ghost" aria-label="Search (⌘K)">
    <svg width="14" height="14" aria-hidden="true"><!-- search --></svg>
    <span>Search...</span>
    <kbd class="topbar__kbd">⌘K</kbd>
  </button>

  <div class="topbar__actions">
    <button class="btn btn--icon" aria-label="Notifikasi">
      <svg width="16" height="16" aria-hidden="true"><!-- bell --></svg>
    </button>
    <div class="avatar avatar--sm" aria-label="Profil">AB</div>
  </div>
</header>
```

```css
.topbar {
  height: 48px;
  background: var(--color-bg-panel);
  border-bottom: 1px solid var(--color-border-subtle);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-inline: var(--space-4);
  position: sticky;
  top: 0;
  z-index: var(--z-sticky);
  gap: var(--space-4);
}

.topbar__brand-name {
  font-size: var(--text-body);
  font-weight: var(--weight-ui);
  color: var(--color-text-primary);
}

.topbar__search {
  flex: 1; max-width: 360px;
  justify-content: space-between;
  padding: 6px 10px;
  color: var(--color-text-tertiary);
  font-size: var(--text-small);
  font-weight: var(--weight-regular);
}

.topbar__kbd {
  font-family: var(--font-mono);
  font-size: var(--text-label);
  color: var(--color-text-quaternary);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-sm);
  padding: 1px 5px;
}

.topbar__actions {
  display: flex; align-items: center; gap: var(--space-2); flex-shrink: 0;
}
```

### Sidebar
```html
<aside class="sidebar" role="complementary" aria-label="Navigasi utama">
  <nav class="sidebar__nav">
    <div class="sidebar__section">
      <span class="sidebar__section-label">Workspace</span>

      <a href="/dashboard" class="sidebar__item sidebar__item--active" aria-current="page">
        <svg class="sidebar__icon" aria-hidden="true"><!-- icon --></svg>
        <span>Dashboard</span>
      </a>

      <a href="/issues" class="sidebar__item">
        <svg class="sidebar__icon" aria-hidden="true"><!-- icon --></svg>
        <span>Issues</span>
        <span class="badge badge--subtle" aria-label="12 issues">12</span>
      </a>

      <div class="sidebar__group">
        <button class="sidebar__item sidebar__item--parent"
                aria-expanded="false" aria-controls="nav-projects">
          <svg class="sidebar__icon" aria-hidden="true"><!-- icon --></svg>
          <span>Projects</span>
          <svg class="sidebar__chevron" aria-hidden="true"><!-- chevron --></svg>
        </button>
        <ul class="sidebar__submenu" id="nav-projects" hidden>
          <li><a href="/projects/web" class="sidebar__subitem">Web App</a></li>
          <li><a href="/projects/mobile" class="sidebar__subitem">Mobile</a></li>
        </ul>
      </div>
    </div>

    <div class="sidebar__divider" role="separator"></div>

    <div class="sidebar__section">
      <span class="sidebar__section-label">Settings</span>
      <a href="/settings" class="sidebar__item">
        <svg class="sidebar__icon" aria-hidden="true"><!-- icon --></svg>
        <span>Pengaturan</span>
      </a>
    </div>
  </nav>

  <div class="sidebar__footer">
    <div class="avatar avatar--sm" aria-hidden="true">AB</div>
    <div class="sidebar__user">
      <p class="sidebar__username">Andi Budi</p>
      <p class="sidebar__user-role">Admin</p>
    </div>
  </div>
</aside>
```

```css
.sidebar {
  width: 240px;
  height: 100vh;
  position: sticky;
  top: 0;
  background: var(--color-bg-panel);
  border-right: 1px solid var(--color-border-subtle);
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  overflow-x: hidden;
  scrollbar-width: thin;
  scrollbar-color: var(--color-bg-surface-2) transparent;
}

.sidebar__section { padding: var(--space-3); }

.sidebar__section-label {
  display: block;
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-quaternary);
  letter-spacing: 0.06em;
  text-transform: uppercase;
  padding: 0 var(--space-2) var(--space-1);
}

.sidebar__item {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: 6px var(--space-2);
  border-radius: var(--radius-sm);
  font-size: var(--text-small);
  font-weight: var(--weight-ui);
  color: var(--color-text-tertiary);
  text-decoration: none;
  cursor: pointer;
  transition:
    background var(--duration-fast) var(--ease-out),
    color var(--duration-fast) var(--ease-out);
  width: 100%;
  border: none;
  background: transparent;
  margin-bottom: 1px;
}

.sidebar__item:hover:not(.sidebar__item--active) {
  background: var(--color-surface-l1);
  color: var(--color-text-secondary);
}

.sidebar__item--active {
  background: var(--color-surface-l2);
  color: var(--color-text-primary);
}

.sidebar__icon {
  width: 16px; height: 16px;
  flex-shrink: 0; color: currentColor; opacity: 0.7;
}
.sidebar__item--active .sidebar__icon { opacity: 1; }

.sidebar__divider {
  height: 1px;
  background: var(--color-line-tint);
  margin: var(--space-2) var(--space-3);
}

.sidebar__footer {
  margin-top: auto;
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-3) var(--space-4);
  border-top: 1px solid var(--color-border-subtle);
}

.sidebar__username {
  font-size: var(--text-small);
  font-weight: var(--weight-ui);
  color: var(--color-text-secondary);
  line-height: 1.3;
}

.sidebar__user-role {
  font-size: var(--text-caption);
  color: var(--color-text-quaternary);
  line-height: 1.3;
}

/* Avatar */
.avatar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-circle);
  border: 1px solid var(--color-border-subtle);
  flex-shrink: 0;
  font-family: var(--font-sans);
  font-feature-settings: var(--font-features);
  font-weight: var(--weight-ui);
  color: var(--color-text-primary);
  background: var(--color-bg-surface);
  overflow: hidden;
}
.avatar--sm { width: 28px; height: 28px; font-size: var(--text-tiny); }
.avatar--md { width: 36px; height: 36px; font-size: var(--text-label); }
.avatar--lg { width: 48px; height: 48px; font-size: var(--text-small); }
```

---

## 11. Navigasi — Breadcrumb & Tabs

### Breadcrumb
```html
<nav class="breadcrumb" aria-label="Breadcrumb">
  <ol class="breadcrumb__list">
    <li><a href="/" class="breadcrumb__link">Workspace</a></li>
    <li class="breadcrumb__sep" aria-hidden="true">/</li>
    <li><a href="/projects" class="breadcrumb__link">Projects</a></li>
    <li class="breadcrumb__sep" aria-hidden="true">/</li>
    <li><span class="breadcrumb__current" aria-current="page">Web App</span></li>
  </ol>
</nav>
```

```css
.breadcrumb__list {
  display: flex; align-items: center; gap: 4px;
  list-style: none; flex-wrap: wrap;
}
.breadcrumb__link {
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-quaternary);
  text-decoration: none;
  border-radius: var(--radius-sm);
  padding: 1px 4px;
  transition: color var(--duration-fast);
}
.breadcrumb__link:hover { color: var(--color-text-secondary); }
.breadcrumb__current {
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-secondary);
  padding: 1px 4px;
}
.breadcrumb__sep {
  font-size: var(--text-caption);
  color: var(--color-text-quaternary); opacity: 0.5;
}
```

### Tabs
```html
<div class="tabs" role="tablist" aria-label="Filter issues">
  <button class="tabs__item tabs__item--active" role="tab" aria-selected="true">
    All <span class="tabs__count">147</span>
  </button>
  <button class="tabs__item" role="tab" aria-selected="false">In Progress</button>
  <button class="tabs__item" role="tab" aria-selected="false">Done</button>
</div>
```

```css
.tabs {
  display: flex;
  border-bottom: 1px solid var(--color-border-subtle);
}

.tabs__item {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  padding: var(--space-2) var(--space-4);
  font-size: var(--text-small);
  font-weight: var(--weight-ui);
  color: var(--color-text-tertiary);
  border-bottom: 1.5px solid transparent;
  margin-bottom: -1px;
  cursor: pointer;
  background: transparent;
  border-top: none; border-left: none; border-right: none;
  transition: color var(--duration-fast), border-color var(--duration-fast);
}
.tabs__item:hover { color: var(--color-text-secondary); }
.tabs__item--active { color: var(--color-text-primary); border-bottom-color: var(--color-accent); }

.tabs__count {
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-quaternary);
  background: var(--color-surface-l2);
  border-radius: var(--radius-pill);
  padding: 0 6px; min-width: 20px; text-align: center;
}
```

---

## 12. Tabel & Data Display

```html
<div class="table-wrapper">
  <div class="table-toolbar">
    <div class="table-toolbar__left">
      <div class="input-search-wrapper">
        <svg class="input-search-icon" aria-hidden="true"><!-- search --></svg>
        <input type="search" class="input input--search" placeholder="Filter issues...">
      </div>
      <button class="btn btn--subtle">Filter</button>
    </div>
    <div class="table-toolbar__right">
      <button class="btn btn--toolbar">Export</button>
      <button class="btn btn--brand">
        <svg width="14" height="14" aria-hidden="true"><!-- plus --></svg>
        New Issue
      </button>
    </div>
  </div>

  <div class="table-scroll" role="region" aria-label="Tabel issues" tabindex="0">
    <table class="table">
      <thead>
        <tr>
          <th class="table__th" scope="col">
            <input type="checkbox" aria-label="Pilih semua">
          </th>
          <th class="table__th table__th--sortable" scope="col" aria-sort="ascending">
            Issue <svg class="table__sort-icon" aria-hidden="true"><!-- sort --></svg>
          </th>
          <th class="table__th" scope="col">Status</th>
          <th class="table__th" scope="col">Priority</th>
          <th class="table__th table__th--num" scope="col">Points</th>
          <th class="table__th" scope="col">Assignee</th>
          <th class="table__th table__th--muted" scope="col">Updated</th>
          <th class="table__th table__th--action" scope="col">
            <span class="sr-only">Actions</span>
          </th>
        </tr>
      </thead>
      <tbody>
        <tr class="table__row">
          <td class="table__td" data-label="">
            <input type="checkbox" aria-label="Pilih baris ini">
          </td>
          <td class="table__td" data-label="Issue">
            <div class="table__issue">
              <span class="table__issue-id">ENG-142</span>
              <span class="table__issue-title">Fix login redirect bug</span>
            </div>
          </td>
          <td class="table__td" data-label="Status">
            <span class="badge badge--success">
              <span class="badge badge--dot"></span>
              In Progress
            </span>
          </td>
          <td class="table__td" data-label="Priority">
            <span class="badge badge--accent">Urgent</span>
          </td>
          <td class="table__td table__td--num" data-label="Points">3</td>
          <td class="table__td" data-label="Assignee">
            <div class="avatar avatar--sm">AB</div>
          </td>
          <td class="table__td table__td--muted" data-label="Updated">2h ago</td>
          <td class="table__td table__td--action">
            <button class="btn btn--icon btn--sm" aria-label="Opsi untuk baris ini">
              <svg width="14" height="14" aria-hidden="true"><!-- dots --></svg>
            </button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="table-pagination">
    <p class="table-pagination__info">Showing 1–25 of 143 issues</p>
    <div class="table-pagination__controls">
      <button class="btn btn--ghost btn--sm" disabled>← Prev</button>
      <button class="pagination__page pagination__page--active">1</button>
      <button class="pagination__page">2</button>
      <button class="pagination__page">3</button>
      <span class="pagination__ellipsis" aria-hidden="true">…</span>
      <button class="pagination__page">6</button>
      <button class="btn btn--ghost btn--sm">Next →</button>
    </div>
  </div>
</div>
```

```css
.table-wrapper {
  background: var(--color-surface-l1);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-panel);
  overflow: hidden;
}

.table-toolbar {
  display: flex; align-items: center; justify-content: space-between;
  padding: var(--space-3) var(--space-4);
  border-bottom: 1px solid var(--color-border-subtle);
  gap: var(--space-3);
}
.table-toolbar__left, .table-toolbar__right {
  display: flex; align-items: center; gap: var(--space-2);
}

.table-scroll { overflow-x: auto; }

.table { width: 100%; border-collapse: collapse; font-size: var(--text-small); }

.table__th {
  padding: var(--space-2) var(--space-4);
  text-align: left;
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-quaternary);
  border-bottom: 1px solid var(--color-border-subtle);
  white-space: nowrap;
}

.table__th--sortable { cursor: pointer; user-select: none; }
.table__th--sortable:hover { color: var(--color-text-secondary); }
.table__sort-icon { width: 12px; height: 12px; opacity: 0.5; }

.table__row { transition: background var(--duration-instant) var(--ease-out); }
.table__row:hover { background: var(--color-surface-l1); }

.table__td {
  padding: var(--space-3) var(--space-4);
  border-bottom: 1px solid var(--color-line-tint);
  color: var(--color-text-secondary);
  vertical-align: middle;
}
.table__row:last-child .table__td { border-bottom: none; }

.table__td--muted { font-size: var(--text-caption); color: var(--color-text-quaternary); }
.table__td--num   { text-align: right; font-variant-numeric: tabular-nums; font-family: var(--font-mono); }

.table__issue { display: flex; align-items: center; gap: var(--space-2); }
.table__issue-id {
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-quaternary);
  font-family: var(--font-mono);
  flex-shrink: 0;
}
.table__issue-title { font-weight: var(--weight-ui); color: var(--color-text-secondary); }

/* Pagination */
.table-pagination {
  display: flex; align-items: center; justify-content: space-between;
  padding: var(--space-3) var(--space-4);
  border-top: 1px solid var(--color-border-subtle);
}
.table-pagination__info {
  font-size: var(--text-caption); color: var(--color-text-quaternary);
}
.table-pagination__controls { display: flex; align-items: center; gap: var(--space-1); }

.pagination__page {
  width: 28px; height: 28px;
  display: flex; align-items: center; justify-content: center;
  border-radius: var(--radius-sm);
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-tertiary);
  cursor: pointer;
  background: transparent;
  border: 1px solid transparent;
  transition: background var(--duration-fast), color var(--duration-fast);
}
.pagination__page:hover { background: var(--color-surface-l2); color: var(--color-text-secondary); }
.pagination__page--active {
  background: var(--color-surface-l3);
  color: var(--color-text-primary);
  border-color: var(--color-border-subtle);
}

.pagination__ellipsis {
  font-size: var(--text-caption); color: var(--color-text-quaternary); padding: 0 4px;
}
```

---

## 13. Modal, Dialog & Overlay

```html
<!-- Backdrop -->
<div class="modal-backdrop" aria-hidden="true"></div>

<!-- Dialog -->
<div class="modal" role="dialog" aria-modal="true" aria-labelledby="dlg-title">
  <div class="modal__panel">
    <div class="modal__header">
      <h2 class="modal__title" id="dlg-title">Delete Issue</h2>
      <button class="btn btn--icon modal__close" aria-label="Tutup">
        <svg width="16" height="16" aria-hidden="true"><!-- X --></svg>
      </button>
    </div>
    <div class="modal__body">
      <p class="text-small">Tindakan ini tidak dapat dibatalkan.</p>
    </div>
    <div class="modal__footer">
      <button class="btn btn--ghost">Cancel</button>
      <button class="btn btn--brand" style="--c:#ef4444;background:var(--c);border-color:var(--c)">
        Delete Issue
      </button>
    </div>
  </div>
</div>

<!-- Command Palette -->
<div class="command-palette" role="dialog" aria-label="Command palette" aria-modal="true">
  <div class="command-palette__panel">
    <div class="command-palette__input-wrap">
      <svg width="16" height="16" class="command-palette__icon" aria-hidden="true"><!-- search --></svg>
      <input type="text" class="command-palette__input"
             placeholder="Type a command or search..."
             role="combobox" aria-expanded="true" aria-haspopup="listbox">
    </div>
    <ul class="command-palette__results" role="listbox">
      <li class="command-palette__group" role="presentation">Recent</li>
      <li class="command-palette__item command-palette__item--active"
          role="option" aria-selected="true">
        <svg width="14" height="14" aria-hidden="true"><!-- icon --></svg>
        <span class="command-palette__item-label">New Issue</span>
        <kbd class="command-palette__shortcut">⌘N</kbd>
      </li>
    </ul>
  </div>
</div>
```

```css
/* Backdrop */
.modal-backdrop {
  position: fixed; inset: 0;
  background: var(--color-overlay);
  z-index: var(--z-overlay);
  animation: backdrop-in var(--duration-normal) var(--ease-out) forwards;
}
@keyframes backdrop-in { from { opacity: 0; } to { opacity: 1; } }

/* Modal */
.modal {
  position: fixed; inset: 0;
  display: flex; align-items: center; justify-content: center;
  z-index: var(--z-modal);
  padding: var(--space-4);
}

.modal__panel {
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border-standard);
  border-radius: var(--radius-panel);
  box-shadow: var(--shadow-dialog);
  width: 100%; max-width: 480px;
  max-height: calc(100vh - var(--space-8));
  overflow-y: auto;
  animation: modal-in var(--duration-slow) var(--ease-spring) forwards;
}

@keyframes modal-in {
  from { opacity: 0; transform: scale(0.95) translateY(8px); }
  to   { opacity: 1; transform: scale(1) translateY(0); }
}

.modal__header {
  display: flex; align-items: center; justify-content: space-between;
  padding: var(--space-5);
  border-bottom: 1px solid var(--color-border-subtle);
}

.modal__title {
  font-size: var(--text-h3);
  font-weight: var(--weight-semibold);
  letter-spacing: var(--tracking-h3);
  color: var(--color-text-primary);
}

.modal__body { padding: var(--space-5); }
.modal__footer {
  display: flex; justify-content: flex-end; gap: var(--space-3);
  padding: var(--space-4) var(--space-5);
  border-top: 1px solid var(--color-border-subtle);
  background: rgba(0,0,0,0.1);
}

/* Command Palette */
.command-palette {
  position: fixed; inset: 0;
  display: flex; align-items: flex-start; justify-content: center;
  padding-top: 15vh;
  z-index: var(--z-modal);
}

.command-palette__panel {
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border-standard);
  border-radius: var(--radius-panel);
  box-shadow: var(--shadow-dialog);
  width: 100%; max-width: 560px;
  overflow: hidden;
  animation: modal-in var(--duration-slow) var(--ease-spring) forwards;
}

.command-palette__input-wrap {
  display: flex; align-items: center; gap: var(--space-2);
  padding: var(--space-3) var(--space-4);
  border-bottom: 1px solid var(--color-border-subtle);
}

.command-palette__icon { color: var(--color-text-tertiary); flex-shrink: 0; }

.command-palette__input {
  flex: 1;
  background: transparent; border: none; outline: none;
  font-family: var(--font-sans);
  font-feature-settings: var(--font-features);
  font-size: var(--text-body);
  font-weight: var(--weight-regular);
  color: var(--color-text-primary);
}
.command-palette__input::placeholder { color: var(--color-text-tertiary); }

.command-palette__results {
  list-style: none; padding: var(--space-1);
  max-height: 360px; overflow-y: auto;
}

.command-palette__group {
  font-size: var(--text-caption);
  font-weight: var(--weight-ui);
  color: var(--color-text-quaternary);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  padding: var(--space-2) var(--space-3) var(--space-1);
}

.command-palette__item {
  display: flex; align-items: center; gap: var(--space-2);
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: background var(--duration-instant);
}
.command-palette__item:hover,
.command-palette__item--active { background: var(--color-surface-l2); }

.command-palette__item-label {
  flex: 1;
  font-size: var(--text-small);
  font-weight: var(--weight-ui);
  color: var(--color-text-secondary);
}

.command-palette__shortcut {
  font-family: var(--font-mono);
  font-size: var(--text-caption);
  color: var(--color-text-quaternary);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-sm);
  padding: 1px 6px;
}
```

---

## 14. Notifikasi & Feedback

### Toast
```html
<div class="toast-container" aria-live="polite" aria-atomic="true">
  <div class="toast toast--success" role="alert">
    <svg class="toast__icon" aria-hidden="true"><!-- check --></svg>
    <div class="toast__content">
      <p class="toast__title">Issue created</p>
      <p class="toast__desc">ENG-143 has been added to In Progress.</p>
    </div>
    <button class="btn btn--icon toast__close" aria-label="Dismiss">×</button>
  </div>
</div>
```

```css
.toast-container {
  position: fixed;
  bottom: var(--space-6); right: var(--space-6);
  display: flex; flex-direction: column; gap: var(--space-2);
  z-index: var(--z-toast);
  max-width: 360px; width: 100%;
}

.toast {
  display: flex; align-items: flex-start; gap: var(--space-3);
  padding: var(--space-3) var(--space-4);
  background: var(--color-bg-surface);
  border: 1px solid var(--color-border-standard);
  border-left: 3px solid;
  border-radius: var(--radius-card);
  box-shadow: var(--shadow-dialog);
  animation: toast-in var(--duration-slow) var(--ease-spring) forwards;
}

@keyframes toast-in {
  from { opacity: 0; transform: translateX(60px) scale(0.95); }
  to   { opacity: 1; transform: translateX(0) scale(1); }
}

.toast--success { border-left-color: var(--color-success-pill); }
.toast--warning { border-left-color: #f59e0b; }
.toast--danger  { border-left-color: #ef4444; }
.toast--info    { border-left-color: var(--color-accent); }

.toast__title {
  font-size: var(--text-small);
  font-weight: var(--weight-ui);
  color: var(--color-text-primary);
  line-height: 1.4;
}
.toast__desc {
  font-size: var(--text-caption);
  color: var(--color-text-tertiary);
  margin-top: 2px; line-height: 1.5;
}
```

### Alert Banner
```html
<div class="alert alert--info" role="alert">
  <svg class="alert__icon" aria-hidden="true"><!-- info --></svg>
  <p class="alert__text">
    New version available.
    <a href="#" class="alert__link">Upgrade to v2.1 →</a>
  </p>
  <button class="btn btn--icon alert__close" aria-label="Dismiss">×</button>
</div>
```

```css
.alert {
  display: flex; align-items: center; gap: var(--space-3);
  padding: var(--space-3) var(--space-4);
  border-bottom: 1px solid var(--color-border-subtle);
  background: var(--color-surface-l1);
}
.alert--info    { border-bottom-color: var(--color-accent); }
.alert--warning { border-bottom-color: #f59e0b; }
.alert--success { border-bottom-color: var(--color-success-pill); }
.alert--danger  { border-bottom-color: #ef4444; }

.alert__icon { flex-shrink: 0; color: var(--color-text-tertiary); }
.alert__text {
  flex: 1;
  font-size: var(--text-small);
  font-weight: var(--weight-ui);
  color: var(--color-text-secondary);
}
.alert__link { color: var(--color-accent); text-decoration: none; }
.alert__link:hover { color: var(--color-accent-hover); }
```

---

## 15. Loading & Empty State

### Skeleton Loader
```html
<!-- Skeleton table row -->
<tr class="table__row" aria-hidden="true">
  <td class="table__td"><div class="skeleton skeleton--check"></div></td>
  <td class="table__td">
    <div style="display:flex;gap:8px;align-items:center">
      <div class="skeleton skeleton--id"></div>
      <div class="skeleton skeleton--text" style="width:55%"></div>
    </div>
  </td>
  <td class="table__td"><div class="skeleton skeleton--badge"></div></td>
  <td class="table__td"><div class="skeleton skeleton--badge" style="width:60px"></div></td>
</tr>
```

```css
/* Shimmer untuk dark surface */
@keyframes skeleton-shimmer {
  0%   { background-position: -400px 0; }
  100% { background-position:  400px 0; }
}

.skeleton {
  border-radius: var(--radius-sm);
  background: linear-gradient(
    90deg,
    var(--color-bg-surface)   0%,
    var(--color-bg-surface-2) 40%,
    var(--color-bg-surface)   80%
  );
  background-size: 800px 100%;
  animation: skeleton-shimmer 1.8s ease-in-out infinite;
  flex-shrink: 0;
}

.skeleton--text   { height: 13px; width: 100%; }
.skeleton--badge  { height: 20px; width: 56px; border-radius: var(--radius-pill); }
.skeleton--id     { height: 13px; width: 52px; }
.skeleton--avatar { width: 28px; height: 28px; border-radius: var(--radius-circle); }
.skeleton--check  { width: 14px; height: 14px; border-radius: var(--radius-micro); }
.skeleton--block  { height: 80px; border-radius: var(--radius-card); }
```

### Empty State
```html
<div class="empty-state">
  <div class="empty-state__icon" aria-hidden="true">
    <svg width="28" height="28"><!-- icon --></svg>
  </div>
  <h3 class="empty-state__title">No issues found</h3>
  <p class="empty-state__desc">Create your first issue to start tracking work.</p>
  <button class="btn btn--brand">
    <svg width="14" height="14" aria-hidden="true"><!-- plus --></svg>
    Create Issue
  </button>
</div>
```

```css
.empty-state {
  display: flex; flex-direction: column; align-items: center;
  text-align: center;
  padding: var(--space-20) var(--space-8);
  gap: var(--space-4);
}

.empty-state__icon {
  width: 56px; height: 56px;
  background: var(--color-surface-l2);
  border: 1px solid var(--color-border-subtle);
  border-radius: var(--radius-panel);
  display: flex; align-items: center; justify-content: center;
  color: var(--color-text-quaternary);
}

.empty-state__title {
  font-size: var(--text-h3);
  font-weight: var(--weight-semibold);
  letter-spacing: var(--tracking-h3);
  color: var(--color-text-primary);
}

.empty-state__desc {
  font-size: var(--text-small);
  color: var(--color-text-tertiary);
  max-width: 280px; line-height: 1.60;
}
```

### Page Loader
```html
<div class="page-loader" role="status" aria-label="Memuat...">
  <div class="page-loader__spinner" aria-hidden="true"></div>
</div>
```

```css
.page-loader {
  position: fixed; inset: 0;
  display: flex; align-items: center; justify-content: center;
  background: var(--color-bg-page);
  z-index: var(--z-overlay);
}

@keyframes spin { to { transform: rotate(360deg); } }

.page-loader__spinner {
  width: 28px; height: 28px;
  border: 2px solid var(--color-border-subtle);
  border-top-color: var(--color-accent);
  border-radius: 50%;
  animation: spin 700ms linear infinite;
}
```

---

## 16. Animasi & Transisi

```css
/* Page enter */
@keyframes page-enter {
  from { opacity: 0; transform: translateY(6px); }
  to   { opacity: 1; transform: translateY(0); }
}
.page-content {
  animation: page-enter var(--duration-slow) var(--ease-out) forwards;
}

/* Dropdown */
@keyframes dropdown-enter {
  from { opacity: 0; transform: translateY(-6px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}
.dropdown__menu {
  animation: dropdown-enter var(--duration-slow) var(--ease-spring) forwards;
}

/* Modal exit */
.modal.is-closing .modal__panel {
  animation: modal-out var(--duration-normal) var(--ease-in-out) forwards;
}
@keyframes modal-out {
  from { opacity: 1; transform: scale(1); }
  to   { opacity: 0; transform: scale(0.97); }
}

/* Respek prefers-reduced-motion */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 17. Responsivitas & Breakpoint

| Nama | Width | Perubahan Utama |
|------|-------|----------------|
| Mobile Small | < 600px | Single column, compact padding |
| Mobile | 600–640px | Standard mobile layout |
| Tablet | 640–768px | Two-column grid mulai |
| Desktop Small | 768–1024px | Sidebar & card grid muncul |
| Desktop | 1024–1280px | Full navigation |
| Large Desktop | > 1280px | Full layout, generous margins |

```css
/* Mobile — sidebar jadi drawer */
.sidebar {
  display: none;
  position: fixed; left: -100%; top: 0; bottom: 0;
  z-index: var(--z-modal);
  transition: left var(--duration-slow) var(--ease-spring);
}
.sidebar--open { display: flex; left: 0; }

/* Overlay saat sidebar mobile terbuka */
.sidebar-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.6);
  z-index: calc(var(--z-modal) - 1);
}

/* >= 768px — sidebar muncul permanent */
@media (min-width: 768px) {
  .app-layout { display: grid; grid-template-columns: 240px 1fr; }
  .sidebar { display: flex; position: sticky; left: auto; }
  .topbar__hamburger { display: none; }
  .sidebar-overlay { display: none; }
}

/* Responsive display text */
.text-display-xl {
  font-size: clamp(2rem, 5vw + 1rem, 4.5rem);
}
.text-display {
  font-size: clamp(2rem, 4vw, 3rem);
}

/* Tabel mobile — card list */
@media (max-width: 639px) {
  .table, .table thead, .table tbody,
  .table__th, .table__td, .table__row { display: block; }
  .table thead { display: none; }
  .table__row {
    background: var(--color-surface-l1);
    border: 1px solid var(--color-border-subtle);
    border-radius: var(--radius-card);
    margin-bottom: var(--space-2);
    padding: var(--space-3);
  }
  .table__td::before {
    content: attr(data-label);
    display: block;
    font-size: var(--text-tiny);
    font-weight: var(--weight-ui);
    color: var(--color-text-quaternary);
    text-transform: uppercase;
    letter-spacing: 0.06em;
    margin-bottom: 4px;
  }
}

/* Touch targets */
@media (hover: none) {
  .btn           { min-height: 44px; }
  .sidebar__item { min-height: 44px; }
  .tabs__item    { min-height: 44px; }
}
```

---

## 18. Aksesibilitas (a11y)

### Skip Link
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

```css
.skip-link {
  position: absolute; top: -100%; left: var(--space-4);
  padding: var(--space-2) var(--space-4);
  background: var(--color-brand);
  color: #fff;
  border-radius: 0 0 var(--radius-md) var(--radius-md);
  font-size: var(--text-small);
  font-weight: var(--weight-ui);
  z-index: calc(var(--z-toast) + 1);
  text-decoration: none;
  transition: top var(--duration-fast);
}
.skip-link:focus { top: 0; }
```

### Focus Ring (Linear style)
```css
*:focus { outline: none; }
*:focus-visible {
  outline: none;
  box-shadow: var(--shadow-focus),
              0 0 0 2px var(--color-bg-panel),
              0 0 0 4px var(--color-accent);
  border-radius: var(--radius-sm);
}
```

### Screen Reader Only
```css
.sr-only {
  position: absolute;
  width: 1px; height: 1px;
  padding: 0; margin: -1px;
  overflow: hidden;
  clip: rect(0,0,0,0);
  white-space: nowrap;
  border: 0;
}
```

### Landmarks & ARIA
```html
<header role="banner">...</header>
<nav role="navigation" aria-label="Navigasi utama">...</nav>
<main id="main-content" role="main" tabindex="-1">...</main>
<aside role="complementary" aria-label="Sidebar">...</aside>
<div aria-live="polite" aria-atomic="true" class="sr-only" id="live-region"></div>
```

### Checklist a11y
- [ ] Semua gambar punya `alt` (`alt=""` untuk dekoratif)
- [ ] Semua form field punya `label` yang terhubung
- [ ] Tombol icon-only punya `aria-label`
- [ ] Dialog punya `aria-modal="true"` dan `aria-labelledby`
- [ ] `aria-live` digunakan untuk toast dan update status
- [ ] Focus trap aktif saat modal terbuka
- [ ] Urutan tab logis dan konsisten
- [ ] Status tidak hanya menggunakan warna (tambahkan ikon/teks)

---

## 19. Do's & Don'ts — Linear Rules

> Diambil langsung dari `DESIGN.md` Section 7.

### ✅ Do

| Aturan | Implementasi |
|--------|-------------|
| `"cv01","ss03"` di **semua** teks Inter | `font-feature-settings: var(--font-features)` di body |
| Weight 510 sebagai default emphasis/UI | `font-weight: var(--weight-ui)` untuk nav, label, button |
| Negative letter-spacing di ukuran besar | `-1.056px` pada 48px, `-0.704px` pada 32px |
| Background near-black | `#08090a` hero, `#0f1011` panel, `#191a1b` card |
| Border semi-transparent white | `rgba(255,255,255,0.08)` untuk card & input |
| Button background hampir transparan | `rgba(255,255,255,0.02–0.05)` |
| Brand indigo hanya untuk CTA & interactive | `#5e6ad2` hanya pada tombol utama dan link aktif |
| Primary text `#f7f8f8`, bukan `#ffffff` | Hindari pure white untuk teks |
| Luminance stepping untuk elevasi | Surface makin terang sedikit seiring elevasi naik |

### ❌ Don't

| Larangan | Contoh Salah |
|----------|-------------|
| Jangan `#ffffff` sebagai primary text | `color: white` atau `color: #ffffff` |
| Jangan solid color untuk background button | `background: #1e1e1e` |
| Jangan brand indigo secara dekoratif | Border indigo di card biasa, heading dekoratif |
| Jangan positive letter-spacing di display text | `letter-spacing: 0.05em` pada 48px |
| Jangan solid border gelap di dark bg | `border: 1px solid #333` |
| Jangan skip OpenType features | Inter tanpa `"cv01","ss03"` |
| Jangan `font-weight: 700` | Maksimum 590 (`--weight-semibold`) |
| Jangan warna warm ke UI chrome | Background kecoklatan, hijau dekoratif |
| Jangan drop-shadow untuk elevasi | `box-shadow: 0 4px 8px #000` sebagai depth indicator |

---

## 20. Checklist Implementasi

### Fase 1 — Fondasi
- [ ] Buat `tokens.css` dengan semua CSS variables dari Section 1
- [ ] Install **Inter Variable** (Google Fonts / self-hosted) dan **Berkeley Mono**
- [ ] Terapkan `font-feature-settings: "cv01","ss03"` di `body`
- [ ] Set `background: var(--color-bg-page)` dan `color: var(--color-text-secondary)` di `body`
- [ ] Tambahkan `-webkit-font-smoothing: antialiased`
- [ ] Hapus semua nilai warna hardcoded dari stylesheet yang ada

### Fase 2 — Komponen Inti
- [ ] **Button** — 6 varian: brand, ghost, subtle, pill, icon, toolbar + loading state
- [ ] **Card** — standard, featured, inset, stat card
- [ ] **Badge** — dot, success pill, neutral pill, subtle, accent
- [ ] **Input** — text, search, select, textarea + error + disabled
- [ ] **Avatar** — sm, md, lg + initials fallback

### Fase 3 — Navigasi
- [ ] **Topbar** — brand, search trigger (⌘K), actions, sticky
- [ ] **Sidebar** — items, section labels, submenu, footer, active state
- [ ] **Breadcrumb** — separator dan current page
- [ ] **Tabs** — active underline accent, count badge
- [ ] **Command Palette** — input, group label, results, keyboard nav

### Fase 4 — Data & Konten
- [ ] **Table** — toolbar, sort, checkbox, pagination + mobile card view
- [ ] **Dropdown menu** — spring animation masuk
- [ ] **Modal/Dialog** — backdrop blur, spring animation, focus trap
- [ ] **Toast** — 4 varian + auto-dismiss (3–5 detik)

### Fase 5 — Feedback & States
- [ ] **Skeleton** — dark shimmer untuk table row dan card
- [ ] **Empty state** — icon, title, desc, CTA
- [ ] **Page loader** — spinner minimal
- [ ] **Alert banner** — accent border kiri

### Fase 6 — Quality Assurance
- [ ] Semua teks lolos kontras **WCAG AA** (4.5:1 normal, 3:1 large)
- [ ] Semua interaksi dapat dilakukan via keyboard
- [ ] Skip link berfungsi
- [ ] ARIA landmarks lengkap
- [ ] Responsif di: 375px, 640px, 768px, 1024px, 1280px
- [ ] `prefers-reduced-motion` mematikan semua animasi
- [ ] Tidak ada light-mode override yang muncul tidak sengaja
- [ ] Review final dengan screen reader (VoiceOver / NVDA)
- [ ] Animasi hanya pakai `opacity` dan `transform` (tidak trigger layout reflow)

---

> **⚠️ Reminder Final:** Semua perubahan di atas adalah **pure UI layer** — tidak ada modifikasi pada business logic, handler, kalkulasi, API call, atau state management. Jika ada keraguan apakah perubahan menyentuh logika, **jangan lakukan**.
>
> Referensi desain penuh: **[`DESIGN.md`](./DESIGN.md)** — *Linear-inspired dark design system.*
