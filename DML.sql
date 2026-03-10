-- ============================================================
-- CS340 Project Step 4 Draft
-- Team: Agents 47 (Group 47)
-- Members: Balakrishna Thirumavalavan and Juan Gregorio
-- Description: Data Manipulation Queries for BLMS
-- Variables are denoted using @variableName
-- ============================================================

-- ------------------------------------------------------------
-- BOWLERS
-- ------------------------------------------------------------

-- SELECT all Bowlers
SELECT 
  bowlerID AS "Bowler ID",
  firstName AS "First Name",
  lastName AS "Last Name",
  average AS "Average",
  handicap AS "Handicap"
FROM Bowlers;

-- INSERT new Bowler
INSERT INTO Bowlers (firstName, lastName, average, handicap)
VALUES (@firstNameInput, @lastNameInput, @averageInput, @handicapInput);

-- UPDATE Bowler
UPDATE Bowlers
SET firstName = @firstNameInput,
    lastName = @lastNameInput,
    average = @averageInput,
    handicap = @handicapInput
WHERE bowlerID = @bowlerIDInput;

-- DELETE Bowler
DELETE FROM Bowlers
WHERE bowlerID = @bowlerIDInput;

-- PRE-FILL Bowler for Update
SELECT bowlerID, firstName, lastName, average, handicap
FROM Bowlers
WHERE bowlerID = @bowlerIDInput;


-- ------------------------------------------------------------
-- TEAMS
-- ------------------------------------------------------------

-- SELECT all Teams
SELECT 
  teamID AS "Team ID",
  teamName AS "Team Name"
FROM Teams;

-- INSERT new Team
INSERT INTO Teams (teamName)
VALUES (@teamNameInput);

-- UPDATE Team
UPDATE Teams
SET teamName = @teamNameInput
WHERE teamID = @teamIDInput;

-- DELETE Team
DELETE FROM Teams
WHERE teamID = @teamIDInput;

-- PRE-FILL Team for Update
SELECT teamID, teamName
FROM Teams
WHERE teamID = @teamIDInput;


-- ------------------------------------------------------------
-- BOWLERS TEAMS (Intersection Table)
-- ------------------------------------------------------------

-- SELECT all Bowler-Team associations
SELECT 
  bt.bowlerID,
  CONCAT(b.firstName, ' ', b.lastName) AS "Bowler Name",
  bt.teamID,
  t.teamName AS "Team Name",
  bt.startDate AS "Start Date",
  bt.endDate AS "End Date"
FROM BowlersTeams bt
JOIN Bowlers b ON bt.bowlerID = b.bowlerID
JOIN Teams t ON bt.teamID = t.teamID;

-- INSERT Bowler into Team
INSERT INTO BowlersTeams (bowlerID, teamID, startDate, endDate)
VALUES (@bowlerIDInput, @teamIDInput, @startDateInput, @endDateInput);

-- UPDATE Bowler-Team membership (Modify FK values allowed)
UPDATE BowlersTeams
SET bowlerID = @newBowlerIDInput,
    teamID = @newTeamIDInput,
    startDate = @startDateInput,
    endDate = @endDateInput
WHERE bowlerID = @originalBowlerIDInput
AND teamID = @originalTeamIDInput;

-- DELETE Bowler from Team
DELETE FROM BowlersTeams
WHERE bowlerID = @bowlerIDInput
AND teamID = @teamIDInput;

-- PRE-FILL Bowler-Team association
SELECT bowlerID, teamID, startDate, endDate
FROM BowlersTeams
WHERE bowlerID = @bowlerIDInput
AND teamID = @teamIDInput;


-- ------------------------------------------------------------
-- SCORES
-- ------------------------------------------------------------

-- SELECT all Scores with computed total
SELECT 
  s.scoresID AS "Score ID",
  s.game1 AS "Game 1",
  s.game2 AS "Game 2",
  s.game3 AS "Game 3",
  (s.game1 + s.game2 + s.game3) AS "Total",
  s.scoresDate AS "Score Date",
  CONCAT(b.firstName, ' ', b.lastName) AS "Bowler Name",
  t.teamName AS "Team Name"
FROM Scores s
JOIN Bowlers b ON s.bowlerID = b.bowlerID
JOIN Teams t ON s.teamID = t.teamID;

-- INSERT new Score
INSERT INTO Scores (game1, game2, game3, scoresDate, bowlerID, teamID)
VALUES (@game1Input, @game2Input, @game3Input, @scoresDateInput, @bowlerIDInput, @teamIDInput);

-- UPDATE Score
UPDATE Scores
SET game1 = @game1Input,
    game2 = @game2Input,
    game3 = @game3Input,
    scoresDate = @scoresDateInput,
    bowlerID = @bowlerIDInput,
    teamID = @teamIDInput
WHERE scoresID = @scoresIDInput;

-- DELETE Score
DELETE FROM Scores
WHERE scoresID = @scoresIDInput;

-- PRE-FILL Score for Update
SELECT scoresID, game1, game2, game3, scoresDate, bowlerID, teamID
FROM Scores
WHERE scoresID = @scoresIDInput;


-- ------------------------------------------------------------
-- LANE ASSIGNMENTS
-- ------------------------------------------------------------

-- SELECT all Lane Assignments
SELECT 
  la.laneAssignmentID AS "Assignment ID",
  la.laneWeek AS "Week",
  la.laneDate AS "Date",
  la.laneNumber AS "Lane Number",
  t.teamName AS "Team Name"
FROM LaneAssignments la
JOIN Teams t ON la.teamID = t.teamID;

-- INSERT new Lane Assignment
INSERT INTO LaneAssignments (laneWeek, laneDate, laneNumber, teamID)
VALUES (@laneWeekInput, @laneDateInput, @laneNumberInput, @teamIDInput);

-- UPDATE Lane Assignment
UPDATE LaneAssignments
SET laneWeek = @laneWeekInput,
    laneDate = @laneDateInput,
    laneNumber = @laneNumberInput,
    teamID = @teamIDInput
WHERE laneAssignmentID = @laneAssignmentIDInput;

-- DELETE Lane Assignment
DELETE FROM LaneAssignments
WHERE laneAssignmentID = @laneAssignmentIDInput;

-- PRE-FILL Lane Assignment
SELECT laneAssignmentID, laneWeek, laneDate, laneNumber, teamID
FROM LaneAssignments
WHERE laneAssignmentID = @laneAssignmentIDInput;


-- ------------------------------------------------------------
-- TEAMS STANDINGS
-- ------------------------------------------------------------

-- SELECT all Team Standings
SELECT 
  ts.standingID AS "Standing ID",
  ts.standingWeek AS "Week",
  ts.rank AS "Rank",
  ts.wins AS "Wins",
  ts.losses AS "Losses",
  t.teamName AS "Team Name"
FROM TeamsStandings ts
JOIN Teams t ON ts.teamID = t.teamID;

-- INSERT new Team Standing
INSERT INTO TeamsStandings (standingWeek, rank, wins, losses, teamID)
VALUES (@standingWeekInput, @rankInput, @winsInput, @lossesInput, @teamIDInput);

-- UPDATE Team Standing
UPDATE TeamsStandings
SET standingWeek = @standingWeekInput,
    rank = @rankInput,
    wins = @winsInput,
    losses = @lossesInput,
    teamID = @teamIDInput
WHERE standingID = @standingIDInput;

-- DELETE Team Standing
DELETE FROM TeamsStandings
WHERE standingID = @standingIDInput;

-- PRE-FILL Team Standing
SELECT standingID, standingWeek, rank, wins, losses, teamID
FROM TeamsStandings
WHERE standingID = @standingIDInput;


-- ------------------------------------------------------------
-- DROPDOWN QUERIES
-- ------------------------------------------------------------

-- Dropdown for Bowlers
SELECT bowlerID,
       CONCAT(firstName, ' ', lastName) AS bowlerName
FROM Bowlers;

-- Dropdown for Teams
SELECT teamID, teamName
FROM Teams;

-- Dropdown for Scores
SELECT scoresID
FROM Scores;

-- Dropdown for Lane Assignments
SELECT laneAssignmentID, laneWeek
FROM LaneAssignments;

-- Dropdown for Team Standings
SELECT standingID, standingWeek
FROM TeamsStandings;
