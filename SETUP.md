# 41 Green Drive Expenses — your own website (Supabase + Netlify)

About 1 hour the first time. Menu names in Supabase and Netlify can shift a little over time; look for the closest match.

## What's in this folder
- `index.html` — the website (same app you use in Claude, now with sign-in)
- `config.js` — where you paste your Supabase connection (step 2)
- `setup.sql` — creates your private database and photo storage (step 3)

---

## 1. Create your Supabase project
1. Go to **supabase.com** → sign up (free) → **New project**.
2. Name it `41-green-drive`, pick a strong database password (save it somewhere), choose the region closest to Boston (**East US**), click **Create**.
3. Wait ~2 minutes until the project is ready.

## 2. Connect the website to it
Already done: `config.js` is filled in with your Project URL and publishable key.

## 3. Create the database
1. In Supabase: **SQL Editor → New query**.
2. Open `setup.sql`, copy everything, paste it in, click **Run**. You should see "Success".

## 4. Create your login
1. **Authentication → Users → Add user → Create new user**.
2. Enter your email and a password, tick **Auto Confirm User**, click **Create**.
3. Turn off sign-ups so nobody else can create an account: **Authentication → Sign In / Providers** (or **Settings**) → turn **off** "Allow new users to sign up".

## 5. Turn on bill reading (optional, do this after step 6)
Bill reading runs from the website itself; nothing to set up in Supabase.
1. Get an API key: **console.anthropic.com** → sign up → **Billing** (add a small credit, e.g. $5; each bill costs a few cents) → **API Keys → Create Key**. Copy it (starts with `sk-ant-`).
2. Open your new site → ⚙ **Settings → Bill reading** → paste the key → **Save**.
3. The key is stored **only on that phone or computer**, not on the website. Repeat once on each device you use.
4. Tip: in the Anthropic console, set a monthly **spend limit** (e.g. $10) so there are never surprises.

Skip this if you'd rather type bills in; everything else works without it.

## 6. Put the website online
1. Go to **app.netlify.com/drop** (free account).
2. Drag this whole folder onto the page. In ~30 seconds you get a web address like `something.netlify.app`.
3. Optional: in Netlify, **Site configuration → Change site name** to something like `41greendrive` → `41greendrive.netlify.app`. A custom domain (e.g. 41greendrive.com) can be added later under **Domain management**.

## 7. Bring your data over
1. In the **Claude version**: tap ⚙ **Settings → Export all data**. Save the file.
2. Open your new site, sign in, tap ⚙ **Settings → Import file**, pick that file.
3. Everything appears: bills, payments, accounts, settings, history and all photos/PDFs.

## 8. Put it on your iPhone home screen
Open your site in **Safari** → Share button → **Add to Home Screen**. It opens like an app.

---

## Extra features (optional, per device)
- **Face ID lock:** ⚙ **Settings → Face ID lock → Turn on**. Do it once on each phone or computer. If Face ID ever fails, tap "Sign out instead" and sign in with your password.
- **Budgets:** ⚙ **Settings → Yearly budgets**. The Year page then shows each category against its budget and where the year is heading.
- **Offline:** after the site has been opened once with internet, it opens without a connection and shows your saved copy. Changes made offline sync when you're back online (photos need a connection).
- **House tab:** maintenance reminders, renewals (insurance, property tax), warranties, contacts and meter readings. Only you see it, and it's included in "Export all data".

## Updating the site later
When I send you an updated `index.html`, replace it in this folder and drag the folder onto your Netlify site again (**Deploys → drag and drop**). Keep your `config.js`.

## Backups
Once a month, in your site: ⚙ **Settings → Export all data**. Save the file somewhere safe (email it to yourself or put it in iCloud Drive). You can import it back any time.
