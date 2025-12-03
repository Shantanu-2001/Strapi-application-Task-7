# Task 1 — Strapi Application Setup & Sample Article

This repository contains a Strapi **v5.x** application prepared for the internship assignment.
It includes a sample collection type `Article`, sample entries, and the minimal project files required to run the app locally.

---

## Overview

What this repo contains:

* A Strapi app scaffolded locally
* An `Article` collection type with fields: `title` (short text), `content` (rich text), `published` (boolean)
* Sample article entries created via the Strapi admin UI
* Files pushed to branch `Shantanu` for PR

---

## Prerequisites

Make sure you have:

* Node.js (LTS recommended) installed
* npm (or yarn)
* Git installed
* (Optional) Docker if you prefer containerized runs

---

## Quick Setup — Commands used

Below are the exact commands used to create, run and push the project. Run these from a terminal in the folder where you want the project.

### 1. Create a new Strapi project (example)

> This is an example used if you want to create a project from scratch. Skip if you already have the project folder.

```bash
# Using npm (Strapi installer approach may vary)
npx create-strapi@latest my-strapi-app --quickstart
# or if you want TypeScript or specific options, configure accordingly
```

> In this assignment we used a standard Strapi project scaffold that results in the project folder: `my-strapi-app/`.

### 2. Start Strapi (developer mode)

Run from the project root:

```bash
# If package.json has the develop script
npm run develop
# or with yarn
yarn develop
```

The admin UI opens at:

```
http://localhost:1337/admin
```

When prompted on first run, register an admin user (email + password) in the admin UI.

### 3. Create content type (via Admin UI)

In the browser admin UI:

1. Go to **Content-Type Builder** → **Create collection type**.
2. Enter display name: `Article`.
3. Add fields:

   * `title` — Text (Short text)
   * `content` — Rich Text (or Long Text / Rich Text)
   * `published` — Boolean
4. Save (Strapi will rebuild admin UI automatically).

### 4. Add sample content (via Admin UI)

* Go to **Content Manager** → **Article** → **Create new entry**
* Fill sample data and click **Publish** (or Save & Publish).

### 5. Test API endpoints

Example GET (public or role-limited depending on permissions):

```bash
# Basic curl while running locally
curl -s http://localhost:1337/api/articles | jq .
```

If `jq` is not installed you will see JSON raw output:

```bash
curl -s http://localhost:1337/api/articles
```

The response should include your sample articles.

---

## Git workflow used for this submission

Commands executed locally to push your changes to the internship repository:

```bash
# inside project root
git init                        # if not already a repo
git remote add origin <repo-url>   # set remote to the organization repo
git fetch origin
git checkout -b Shantanu origin/Shantanu  # create branch tracking remote (or create new local branch)
# stage and commit your project files (exclude node_modules)
git add .
git commit -m "Add Strapi setup and sample article"
git push -u origin Shantanu
```

After `git push`, open the repository on GitHub and click the green **Compare & pull request** button to create the PR from branch `Shantanu` into `main` (or as instructed by the mentor).

> **Important:** Keep `.env` secrets out of Git. `.gitignore` should include `node_modules/`, `.env`, and other local artifacts.

---

## File structure (current — updated)

```
my-strapi-app/
├─ config/
│   └─ ... Strapi config files
├─ database/
│   └─ migrations/
├─ public/
│   └─ static assets (favicon, etc.)
├─ src/
│   ├─ api/
│   │   └─ article/
│   │       ├─ content-types/
│   │       │    └─ article/      # schema JSON for Article
│   │       ├─ controllers/
│   │       ├─ routes/
│   │       └─ services/
│   └─ ... other Strapi source files
├─ types/
│   └─ generated/
│       ├─ contentTypes.d.ts
│       └─ components.d.ts
├─ .env.example
├─ .gitignore
├─ README.md
├─ package.json
├─ package-lock.json
├─ tsconfig.json
└─ favicon.png
```

---

## How to reproduce locally (step-by-step)

1. Clone the repo or copy the project folder to your machine:

```bash
git clone <org-repo-url>
cd The-Monitor-Hub
git checkout -b Shantanu origin/Shantanu   # or git checkout Shantanu if created
```

2. Install dependencies:

```bash
# from project root
npm install
# or
yarn
```

3. Create `.env` (copy `.env.example` to `.env`) and configure DB / ports if required.

4. Run Strapi in dev mode:

```bash
npm run develop
# or
yarn develop
```

5. Visit `http://localhost:1337/admin`, sign in, and you should see your `Article` in Content Manager.

---

## What I verified here

* Admin panel accessible and admin user created.
* `Article` collection type added with fields: title, content, published.
* Sample entries created and visible via API `GET /api/articles`.
* Repo pushed to the `Shantanu` branch and PR created for review.

---
