-- ============================================================
-- CS340 Project Step 4 Draft
-- Team: Agents 47 (Group 47)
-- Members: Balakrishna Thirumavalavan and Juan Gregorio
-- Description: Stored Procedures for BLMS
-- Use of AI: Co-pilot was used to assist in writing stored procedures and for some autocompletion. All code was reviewed and edited by Balakrishna and Juan.
-- ============================================================

DROP PROCEDURE IF EXISTS sp_reset_blms;

DROP PROCEDURE IF EXISTS sp_select_bowlers;
DROP PROCEDURE IF EXISTS sp_select_bowlers_dropdown;
DROP PROCEDURE IF EXISTS sp_insert_bowler;
DROP PROCEDURE IF EXISTS sp_update_bowler;
DROP PROCEDURE IF EXISTS sp_delete_bowler;

DROP PROCEDURE IF EXISTS sp_select_teams;
DROP PROCEDURE IF EXISTS sp_select_teams_dropdown;
DROP PROCEDURE IF EXISTS sp_insert_team;
DROP PROCEDURE IF EXISTS sp_update_team;
DROP PROCEDURE IF EXISTS sp_delete_team;

DROP PROCEDURE IF EXISTS sp_select_bowlersteams;
DROP PROCEDURE IF EXISTS sp_insert_bowlersteam;
DROP PROCEDURE IF EXISTS sp_update_bowlersteam;
DROP PROCEDURE IF EXISTS sp_delete_bowlersteam;

DROP PROCEDURE IF EXISTS sp_select_scores;
DROP PROCEDURE IF EXISTS sp_insert_score;
DROP PROCEDURE IF EXISTS sp_update_score;
DROP PROCEDURE IF EXISTS sp_delete_score;

DROP PROCEDURE IF EXISTS sp_select_laneassignments;
DROP PROCEDURE IF EXISTS sp_insert_laneassignment;
DROP PROCEDURE IF EXISTS sp_update_laneassignment;
DROP PROCEDURE IF EXISTS sp_delete_laneassignment;

DROP PROCEDURE IF EXISTS sp_select_teamsstandings;
DROP PROCEDURE IF EXISTS sp_insert_teamsstanding;
DROP PROCEDURE IF EXISTS sp_update_teamsstanding;
DROP PROCEDURE IF EXISTS sp_delete_teamsstanding;

DELIMITER //

-- ============================================================
-- RESET DATABASE
-- ============================================================

CREATE PROCEDURE sp_reset_blms()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;

    DROP TABLE IF EXISTS BowlersTeams;
    DROP TABLE IF EXISTS Scores;
    DROP TABLE IF EXISTS LaneAssignments;
    DROP TABLE IF EXISTS TeamsStandings;
    DROP TABLE IF EXISTS Bowlers;
    DROP TABLE IF EXISTS Teams;

    -- Recreate Tables

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

    SET FOREIGN_KEY_CHECKS = 1;

    -- SELECT 'BLMS reset complete' AS message;
END //

-- ============================================================
-- SELECT PROCEDURES
-- ============================================================
CREATE PROCEDURE sp_select_bowlers()
BEGIN
    SELECT * FROM Bowlers ORDER BY bowlerID;
END //

CREATE PROCEDURE sp_select_teams()
BEGIN
    SELECT * FROM Teams ORDER BY teamID;
END //

CREATE PROCEDURE sp_select_bowlersteams()
BEGIN
    SELECT * FROM BowlersTeams;
END //

CREATE PROCEDURE sp_select_scores()
BEGIN
    SELECT * FROM Scores ORDER BY scoresID;
END //

CREATE PROCEDURE sp_select_laneassignments()
BEGIN
    SELECT * FROM LaneAssignments ORDER BY laneAssignmentID;
END //

CREATE PROCEDURE sp_select_teamsstandings()
BEGIN
    SELECT * FROM TeamsStandings ORDER BY standingID;
END //

CREATE PROCEDURE sp_select_bowlers_dropdown()
BEGIN
    SELECT bowlerID,
           CONCAT(firstName,' ',lastName) AS name
    FROM Bowlers
    ORDER BY firstName;
END //

CREATE PROCEDURE sp_select_teams_dropdown()
BEGIN
    SELECT teamID,
           teamName
    FROM Teams
    ORDER BY teamName;
END //

-- ============================================================
-- CUD PROCEDURES
-- ============================================================

-- ============================================================
-- BOWLERS
-- ============================================================
CREATE PROCEDURE sp_insert_bowler(
    IN p_firstName VARCHAR(45),
    IN p_lastName VARCHAR(45),
    IN p_average INT,
    IN p_handicap INT
)
BEGIN
    INSERT INTO Bowlers (firstName, lastName, average, handicap)
    VALUES (p_firstName, p_lastName, p_average, p_handicap);

    SELECT LAST_INSERT_ID() AS bowlerID;
END //

CREATE PROCEDURE sp_update_bowler(
    IN p_bowlerID INT,
    IN p_firstName VARCHAR(45),
    IN p_lastName VARCHAR(45),
    IN p_average INT,
    IN p_handicap INT
)
BEGIN
    UPDATE Bowlers
    SET firstName = p_firstName,
        lastName = p_lastName,
        average = p_average,
        handicap = p_handicap
    WHERE bowlerID = p_bowlerID;

    SELECT ROW_COUNT() AS rows_affected;
END //

CREATE PROCEDURE sp_delete_bowler(IN p_bowlerID INT)
BEGIN
    DELETE FROM Bowlers
    WHERE bowlerID = p_bowlerID;

    SELECT ROW_COUNT() AS rows_affected;
END //

-- ============================================================
-- TEAMS
-- ============================================================
CREATE PROCEDURE sp_insert_team(
    IN p_teamName VARCHAR(45)
)
BEGIN
    INSERT INTO Teams (teamName)
    VALUES (p_teamName);

    SELECT LAST_INSERT_ID() AS teamID;
END //

CREATE PROCEDURE sp_update_team(
    IN p_teamID INT,
    IN p_teamName VARCHAR(45)
)
BEGIN
    UPDATE Teams
    SET teamName = p_teamName
    WHERE teamID = p_teamID;

    SELECT ROW_COUNT() AS rows_affected;
END //

CREATE PROCEDURE sp_delete_team(
    IN p_teamID INT
)
BEGIN
    DELETE FROM Teams
    WHERE teamID = p_teamID;

    SELECT ROW_COUNT() AS rows_affected;
END //

-- ============================================================
-- BOWLERS TEAMS (Intersection Table)
-- ============================================================
CREATE PROCEDURE sp_insert_bowlersteam(
    IN p_bowlerID INT,
    IN p_teamID INT,
    IN p_startDate DATE,
    IN p_endDate DATE
)
BEGIN
    INSERT INTO BowlersTeams (bowlerID, teamID, startDate, endDate)
    VALUES (p_bowlerID, p_teamID, p_startDate, p_endDate);

    SELECT ROW_COUNT() AS rows_affected;
END //

CREATE PROCEDURE sp_update_bowlersteam(
    IN p_bowlerID INT,
    IN p_teamID INT,
    IN p_startDate DATE,
    IN p_endDate DATE
)
BEGIN
    UPDATE BowlersTeams
    SET startDate = p_startDate,
        endDate = p_endDate
    WHERE bowlerID = p_bowlerID
      AND teamID = p_teamID;

    SELECT ROW_COUNT() AS rows_affected;
END //

CREATE PROCEDURE sp_delete_bowlersteam(
    IN p_bowlerID INT,
    IN p_teamID INT
)
BEGIN
    DELETE FROM BowlersTeams
    WHERE bowlerID = p_bowlerID
      AND teamID = p_teamID;

    SELECT ROW_COUNT() AS rows_affected;
END //

-- ============================================================
-- SCORES
-- ============================================================
CREATE PROCEDURE sp_insert_score(
    IN p_game1 INT,
    IN p_game2 INT,
    IN p_game3 INT,
    IN p_scoresDate DATE,
    IN p_bowlerID INT,
    IN p_teamID INT
)
BEGIN
    INSERT INTO Scores (game1, game2, game3, scoresDate, bowlerID, teamID)
    VALUES (p_game1, p_game2, p_game3, p_scoresDate, p_bowlerID, p_teamID);

    SELECT LAST_INSERT_ID() AS scoresID;
END //

CREATE PROCEDURE sp_update_score(
    IN p_scoresID INT,
    IN p_game1 INT,
    IN p_game2 INT,
    IN p_game3 INT,
    IN p_scoresDate DATE,
    IN p_bowlerID INT,
    IN p_teamID INT
)
BEGIN
    UPDATE Scores
    SET game1 = p_game1,
        game2 = p_game2,
        game3 = p_game3,
        scoresDate = p_scoresDate,
        bowlerID = p_bowlerID,
        teamID = p_teamID
    WHERE scoresID = p_scoresID;

    SELECT ROW_COUNT() AS rows_affected;
END //

CREATE PROCEDURE sp_delete_score(IN p_scoresID INT)
BEGIN
    DELETE FROM Scores
    WHERE scoresID = p_scoresID;

    SELECT ROW_COUNT() AS rows_affected;
END //

-- ============================================================
-- LANE ASSIGNMENTS
-- ============================================================
CREATE PROCEDURE sp_insert_laneassignment(
    IN p_laneWeek INT,
    IN p_laneDate DATE,
    IN p_laneNumber INT,
    IN p_teamID INT
)
BEGIN
    INSERT INTO LaneAssignments (laneWeek, laneDate, laneNumber, teamID)
    VALUES (p_laneWeek, p_laneDate, p_laneNumber, p_teamID);

    SELECT LAST_INSERT_ID() AS laneAssignmentID;
END //

CREATE PROCEDURE sp_update_laneassignment(
    IN p_laneAssignmentID INT,
    IN p_laneWeek INT,
    IN p_laneDate DATE,
    IN p_laneNumber INT,
    IN p_teamID INT
)
BEGIN
    UPDATE LaneAssignments
    SET laneWeek = p_laneWeek,
        laneDate = p_laneDate,
        laneNumber = p_laneNumber,
        teamID = p_teamID
    WHERE laneAssignmentID = p_laneAssignmentID;

    SELECT ROW_COUNT() AS rows_affected;
END //

CREATE PROCEDURE sp_delete_laneassignment(IN p_laneAssignmentID INT)
BEGIN
    DELETE FROM LaneAssignments
    WHERE laneAssignmentID = p_laneAssignmentID;

    SELECT ROW_COUNT() AS rows_affected;
END //

-- ============================================================
-- TEAMS STANDINGS
-- ============================================================
CREATE PROCEDURE sp_insert_teamsstanding(
    IN p_standingWeek INT,
    IN p_rank INT,
    IN p_wins INT,
    IN p_losses INT,
    IN p_teamID INT
)
BEGIN
    INSERT INTO TeamsStandings (standingWeek, rank, wins, losses, teamID)
    VALUES (p_standingWeek, p_rank, p_wins, p_losses, p_teamID);

    SELECT LAST_INSERT_ID() AS standingID;
END //

CREATE PROCEDURE sp_update_teamsstanding(
    IN p_standingID INT,
    IN p_standingWeek INT,
    IN p_rank INT,
    IN p_wins INT,
    IN p_losses INT,
    IN p_teamID INT
)
BEGIN
    UPDATE TeamsStandings
    SET standingWeek = p_standingWeek,
        rank = p_rank,
        wins = p_wins,
        losses = p_losses,
        teamID = p_teamID
    WHERE standingID = p_standingID;

    SELECT ROW_COUNT() AS rows_affected;
END //

CREATE PROCEDURE sp_delete_teamsstanding(IN p_standingID INT)
BEGIN
    DELETE FROM TeamsStandings
    WHERE standingID = p_standingID;

    SELECT ROW_COUNT() AS rows_affected;
END //

DELIMITER ;
