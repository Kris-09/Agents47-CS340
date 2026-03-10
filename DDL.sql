-- ============================================================
-- CS340 Project Step 4 Draft
-- Team: Agents 47 (Group 47)
-- Members: Balakrishna Thirumavalavan and Juan Gregorio
-- Description: DDL for BLMS (Bowling League Management System)
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- ------------------------------------------------------------
-- Drop tables
-- ------------------------------------------------------------
DROP TABLE IF EXISTS BowlersTeams;
DROP TABLE IF EXISTS Scores;
DROP TABLE IF EXISTS LaneAssignments;
DROP TABLE IF EXISTS TeamsStandings;
DROP TABLE IF EXISTS Bowlers;
DROP TABLE IF EXISTS Teams;

-- ------------------------------------------------------------
-- Table: Bowlers
-- ------------------------------------------------------------
CREATE TABLE Bowlers (
  bowlerID INT NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(45) NOT NULL,
  lastName VARCHAR(45) NOT NULL,
  average INT NULL,
  handicap INT NULL,
  PRIMARY KEY (bowlerID)
) ENGINE = InnoDB;

-- ------------------------------------------------------------
-- Sample Data: Bowlers
-- ------------------------------------------------------------
INSERT INTO Bowlers (firstName, lastName, average, handicap) VALUES
('Zhong', 'Kui', 165, 32),
('Jesse', 'Faden', 150, 45),
('Sun', 'Wukong', 195, 5),
('Emily', 'Pope', 170, 25),
('Robert', 'Nightingale', 160, 15),
('Alan', 'Wake', 158, 40),
('Alice', 'Wake', 198, 12),
('Tim', 'Breaker', 110, 49),
('Saga', 'Anderson', 164, 30);

-- ------------------------------------------------------------
-- Table: Teams
-- ------------------------------------------------------------
CREATE TABLE Teams (
  teamID INT NOT NULL AUTO_INCREMENT,
  teamName VARCHAR(45) NOT NULL,
  PRIMARY KEY (teamID)
) ENGINE = InnoDB;

-- ------------------------------------------------------------
-- Sample Data: Teams
-- ------------------------------------------------------------
INSERT INTO Teams (teamName) VALUES
('Ghost Pins'),
('Control Bureau'),
('Peace Makers');

-- ------------------------------------------------------------
-- Table: BowlersTeams (Intersection Table)
-- ------------------------------------------------------------
CREATE TABLE BowlersTeams (
  bowlerID INT NOT NULL,
  teamID INT NOT NULL,
  startDate DATE NOT NULL,
  endDate DATE NULL,
  PRIMARY KEY (bowlerID, teamID),

  INDEX fk_BowlersTeams_Teams_idx (teamID),
  INDEX fk_BowlersTeams_Bowlers_idx (bowlerID),

  CONSTRAINT fk_BowlersTeams_Bowlers
    FOREIGN KEY (bowlerID)
    REFERENCES Bowlers (bowlerID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT fk_BowlersTeams_Teams
    FOREIGN KEY (teamID)
    REFERENCES Teams (teamID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- ------------------------------------------------------------
-- Sample Data: BowlersTeams
-- ------------------------------------------------------------
INSERT INTO BowlersTeams (bowlerID, teamID, startDate, endDate) VALUES

-- Team 1
(1, 1, '2025-01-04', '2025-03-20'),
(2, 1, '2025-01-04', '2025-03-20'),
(3, 1, '2025-01-04', '2025-03-20'),

-- Team 2
(4, 2, '2025-01-04', '2025-03-20'),
(5, 2, '2025-01-04', '2025-03-20'),
(6, 2, '2025-01-04', '2025-03-20'),

-- Team 3
(7, 3, '2025-01-04', '2025-03-20'),
(8, 3, '2025-01-04', '2025-03-20'),
(9, 3, '2025-01-04', '2025-03-20');

-- ------------------------------------------------------------
-- Table: Scores
-- ------------------------------------------------------------
CREATE TABLE Scores (
  scoresID INT NOT NULL AUTO_INCREMENT,
  game1 INT NOT NULL,
  game2 INT NOT NULL,
  game3 INT NOT NULL,
  scoresDate DATE NOT NULL,
  bowlerID INT NOT NULL,
  teamID INT NOT NULL,
  PRIMARY KEY (scoresID),

  INDEX fk_Scores_Bowlers_idx (bowlerID),
  INDEX fk_Scores_Teams_idx (teamID),

  CONSTRAINT fk_Scores_Bowlers
    FOREIGN KEY (bowlerID)
    REFERENCES Bowlers (bowlerID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT fk_Scores_Teams
    FOREIGN KEY (teamID)
    REFERENCES Teams (teamID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- ------------------------------------------------------------
-- Sample Data: Scores
-- ------------------------------------------------------------
INSERT INTO Scores (game1, game2, game3, scoresDate, bowlerID, teamID) VALUES

-- Team 1
(150, 160, 170, '2025-02-01', 1, 1),
(180, 190, 200, '2025-02-01', 2, 1),
(140, 155, 165, '2025-02-01', 3, 1),

-- Team 2
(200, 210, 220, '2025-02-01', 4, 2),
(160, 170, 180, '2025-02-01', 5, 2),
(155, 165, 175, '2025-02-01', 6, 2),

-- Team 3
(175, 185, 195, '2025-02-01', 7, 3),
(145, 155, 165, '2025-02-01', 8, 3),
(190, 200, 210, '2025-02-01', 9, 3);

-- ------------------------------------------------------------
-- Table: LaneAssignments
-- ------------------------------------------------------------
CREATE TABLE LaneAssignments (
  laneAssignmentID INT NOT NULL AUTO_INCREMENT,
  laneWeek INT NOT NULL,
  laneDate DATE NOT NULL,
  laneNumber INT NOT NULL,
  teamID INT NOT NULL,
  PRIMARY KEY (laneAssignmentID),

  INDEX fk_LaneAssignments_Teams_idx (teamID),

  CONSTRAINT fk_LaneAssignments_Teams
    FOREIGN KEY (teamID)
    REFERENCES Teams (teamID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- ------------------------------------------------------------
-- Sample Data: LaneAssignments
-- ------------------------------------------------------------
INSERT INTO LaneAssignments (laneWeek, laneDate, laneNumber, teamID) VALUES
(1, '2025-02-01', 5, 1),
(1, '2025-02-01', 6, 2),
(1, '2025-02-01', 7, 3);

-- ------------------------------------------------------------
-- Table: TeamsStandings
-- ------------------------------------------------------------
CREATE TABLE TeamsStandings (
  standingID INT NOT NULL AUTO_INCREMENT,
  standingWeek INT NOT NULL,
  rank INT NOT NULL,
  wins INT NOT NULL,
  losses INT NOT NULL,
  teamID INT NOT NULL,
  PRIMARY KEY (standingID),

  INDEX fk_TeamsStandings_Teams_idx (teamID),

  CONSTRAINT fk_TeamsStandings_Teams
    FOREIGN KEY (teamID)
    REFERENCES Teams (teamID)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- ------------------------------------------------------------
-- Sample Data: TeamsStandings
-- ------------------------------------------------------------
INSERT INTO TeamsStandings (standingWeek, rank, wins, losses, teamID) VALUES
(1, 1, 3, 0, 3),
(1, 2, 2, 1, 1),
(1, 3, 1, 2, 2);

COMMIT;
SET AUTOCOMMIT = 1;
SET FOREIGN_KEY_CHECKS = 1;
