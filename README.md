#IMPORTANT
Note1: After click on register please find your verification email from spam of your provided email.
Note2: We have hosted the backend on render free version, so sometimes it can take more than 45sec for loading. So, please wait then.
Note3: You can't register as admin, it is built in. But if you want to explore the admin section please provide- 
       email: bsse1531@iit.du.ac.bd 
       password: 123456
Note4: You can register donor account, verify email(check spam please) then make login & explore. On the other hand, if your time is short you want to explore fast then please provide-
 email: fahimshahryersizan2004@gmail.com    password: 123456
It is already registered for testing.
Note5: a)It is our backend hosted API URL: https://aidmatch-backend.onrender.com
b)Hosted backend's github repository: https://github.com/rahat1517/aidmatch-backend 
(We were facing issues while hosting the backend on Render because the original repository contained both the backend and frontend code. For that reason, we decided to keep the hosted backend in a separate repository.)


# Lubdhok

 A smart friction-based donation management android mobile app- built with **Flutter**, **Firebase**, **FastAPI**, and **PostgreSQL**.  
It helps donors make better donation decisions through a **friction-based recommendation system**, reducing oversupply and encouraging need-based giving.

---

## Features

### Donor Side
- User registration and login with Firebase Authentication
- Email verification
- Forgot password support
- Browse active donation campaigns
- View campaign details and needed items
- Friction-based donation suggestions before donating
- Donate items to a campaign
- View donation history

### Admin Side
- Admin login
- Create and manage campaigns
- Add and manage campaign items
- View incoming donations
- Receive donations from donors
- Update used quantity of items
- Track real-time inventory and remaining needs

### Friction-Based Donation System
Lubdhok’s main concept is **friction**.  
Before donating, donors receive a suggestion based on current campaign inventory, such as:
- **Urgent** → this item is highly needed
- **Low Priority** → donate carefully
- **Fulfilled** → target already reached
- **Overflowed** → better to donate another item

This helps reduce unnecessary donations and improves resource distribution.

---

## Tech Stack

### Frontend
- Flutter
- Dart
- Riverpod
- GoRouter

### Authentication
- Firebase Authentication
- Email verification
- Password reset

### Backend
- FastAPI
- Python

### Database
- PostgreSQL
- pgAdmin 4

### Hosting
- Render

---

## Project Structure

```bash
lib/
├── core/
├── data/
├── features/
│   ├── auth/
│   ├── donor/
│   ├── admin/
│   ├── notifications/
│   └── shared/
├── app.dart
├── main.dart
└── firebase_options.dart

## Future Extension

- Push notifications for donors and admins  
- Advanced analytics dashboard   
- Campaign and item image upload  
- Donation tracking and progress updates  
- Improved admin role management  
- Downloadable reports and summaries  
- Better search and filtering system
- Add image upload support for campaigns and donated items
- Enable in-app chat or communication between donors and admins
