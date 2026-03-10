# Agents47-CS340
This repository contains the source code for the **Bowling League Management System (BLMS)** developed for **CS340 – Introduction to Databases** at Oregon State University. The project serves as a collaborative workspace for managing and updating our group codebase.

---

## Overview

The Bowling League Management System, or BLMS, is an online database specializing in managing a single bowling league. The conception of the database was due to the over reliance on traditional paper based tracking and manual records keeping, as these physical copies can tend to get messy to maintain. This proposed web-based database, on the other hand, would aim to provide a hassle-free centralized platform to manage bowlers, various teams, different lanes and their assignments, weekly scores, and league standings. Thus, by automating crucial processes such as handicap calculation, win/loss tracking, and lane schedules, BLMS enables league organizers to focus on simplifying the administrative overhead.  

Our league operates with 24 teams, each team with four bowlers, totaling to 96 registered participants. This league also runs for a full season of 32 weeks. Every week, each team is assigned one of the bowling center’s 24 lanes, and each bowler completes three games, resulting in nearly 10,000 individual game scores recorded per annum. BLMS will capture this data in real time, would support dynamic lane reassignments, will be capable of calculating handicaps per United States Bowling Congress (USBC) rules, would enable easy updating of team standings, and provide the administrators with an intuitive web interface for all CRUD (Create, Read, Update, Delete) operations, ensuring that the management be accurate and consistent throughout the season.

---

## Live Database Access

The project database is hosted through **Oregon State University's classwork server** using phpMyAdmin.

Access it here:

http://classwork.engr.oregonstate.edu:8720/

This environment stores and manages the league data used by the BLMS application.

---

## Current Implementation Status

The system currently supports full **CRUD functionality** across the database entities.

### Implemented Operations
- **Create** – Add new records for entities such as bowlers, teams, scores, lane assignments, and standings  
- **Read** – Display data from all database tables within the web application  
- **Update** – Modify existing records through the UI  
- **Delete** – Remove records when necessary  

All **Create, Update, and Delete (CUD)** operations have been implemented and tested.

---

## Current Development Focus

With the core functionality now finalized, the project is entering the next phase of development.

The primary focus moving forward is to improve the **user interface and overall visual design** of the application. These enhancements will aim to:

- Improve UI aesthetics
- Make interactions more intuitive
- Refine layout and usability of forms and tables
- Enhance the overall user experience

---

## Repository Purpose

This repository serves as a **collaboration tool for our project group**, allowing team members to:

- Share and update the application codebase
- Track changes throughout development
- Maintain project documentation
- Manage database scripts and application files

---

## Technologies Used

- **Node.js**
- **Express.js**
- **Handlebars (HBS)**
- **MySQL**
- **phpMyAdmin**
- **HTML / CSS / JavaScript**

---

## Authors

CS340 Project Team – *Agents47*
Balakrishna Thirumavalavan
Juan Gregorio
