// ############################################################
// ######################## SETUP #############################
// ############################################################

// Express
const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 8720;

// Database Connector
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars');
app.engine('.hbs', engine({ extname: '.hbs' }));
app.set('view engine', '.hbs');


// ############################################################
// ######################## ROUTES ############################
// ############################################################


// -------------------------------
// HOME
// -------------------------------
app.get('/', async function (req, res) {
    try {
        res.render('home');
    } catch (error) {
        console.error('Error rendering home page:', error);
        res.status(500).send('Error rendering page.');
    }
});


// -------------------------------
// BOWLERS
// -------------------------------
app.get('/bowlers', async function (req, res) {
    try {
        const query = `
            SELECT bowlerID, firstName, lastName, average, handicap
            FROM Bowlers;
        `;
        const [bowlers] = await db.query(query);
        res.render('bowlers', { bowlers });
    } catch (error) {
        console.error('Error loading Bowlers:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/updateBowler', async function (req, res) {
    try {
        const { bowlerID, firstName, lastName, average, handicap } = req.body;

        const query = `
            UPDATE Bowlers
            SET firstName = ?,
                lastName = ?,
                average = ?,
                handicap = ?
            WHERE bowlerID = ?;
        `;

        await db.query(query, [firstName, lastName, average, handicap, bowlerID]);

        res.redirect('/bowlers');

    } catch (error) {
        console.error('Error updating Bowler:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/createBowler', async function (req, res) {
    try {
        const { create_bowler_firstname,
                create_bowler_lastname,
                create_bowler_average,
                create_bowler_handicap } = req.body;

        const query = `
            INSERT INTO Bowlers (firstName, lastName, average, handicap)
            VALUES (?, ?, ?, ?);
        `;

        await db.query(query, [
            create_bowler_firstname,
            create_bowler_lastname || null,
            create_bowler_average || null,
            create_bowler_handicap || null
        ]);

        res.redirect('/bowlers');

    } catch (error) {
        console.error('Error creating Bowler:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/deleteBowler', async function (req, res) {
    try {
        const { bowlerID } = req.body;

        const query = `
            DELETE FROM Bowlers
            WHERE bowlerID = ?;
        `;

        await db.query(query, [bowlerID]);

        res.redirect('/bowlers');

    } catch (error) {
        console.error('Error deleting Bowler:', error);
        res.status(500).send('Database error.');
    }
});



// -------------------------------
// TEAMS
// -------------------------------
app.get('/teams', async function (req, res) {
    try {
        const query = `
            SELECT teamID, teamName
            FROM Teams;
        `;
        const [teams] = await db.query(query);
        res.render('teams', { teams });
    } catch (error) {
        console.error('Error loading Teams:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/createTeam', async function (req, res) {
    try {
        const { teamName } = req.body;

        const query = `
            INSERT INTO Teams (teamName)
            VALUES (?);
        `;

        await db.query(query, [teamName]);
        res.redirect('/teams');

    } catch (error) {
        console.error('Error creating Team:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/deleteTeam', async function (req, res) {
    try {
        const { teamID } = req.body;

        const query = `
            DELETE FROM Teams
            WHERE teamID = ?;
        `;

        await db.query(query, [teamID]);
        res.redirect('/teams');

    } catch (error) {
        console.error('Error deleting Team:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/updateTeam', async function (req, res) {
    try {
        const { teamID, teamName } = req.body;

        const query = `
            UPDATE Teams
            SET teamName = ?
            WHERE teamID = ?;
        `;

        await db.query(query, [teamName, teamID]);

        res.redirect('/teams');

    } catch (error) {
        console.error('Error updating Team:', error);
        res.status(500).send('Database error.');
    }
});


// -------------------------------
// SCORES
// -------------------------------
app.get('/scores', async function (req, res) {
    try {

        const scoresQuery = `
            SELECT 
                s.scoresID,
                s.game1,
                s.game2,
                s.game3,
                DATE_FORMAT(s.scoresDate, '%Y-%m-%d') AS scoresDate,
                CONCAT(b.firstName, ' ', b.lastName) AS bowlerName,
                t.teamName
            FROM Scores s
            JOIN Bowlers b ON s.bowlerID = b.bowlerID
            JOIN Teams t ON s.teamID = t.teamID;
        `;

        const bowlersQuery = `
            SELECT bowlerID, firstName, lastName
            FROM Bowlers;
        `;

        const teamsQuery = `
            SELECT teamID, teamName
            FROM Teams;
        `;

        const [scores] = await db.query(scoresQuery);
        const [bowlers] = await db.query(bowlersQuery);
        const [teams] = await db.query(teamsQuery);

        res.render('scores', { scores, bowlers, teams });

    } catch (error) {
        console.error('Error loading Scores:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/createScore', async function (req, res) {
    try {
        const { game1, game2, game3, scoresDate, bowlerID, teamID } = req.body;

        const query = `
            INSERT INTO Scores
            (game1, game2, game3, scoresDate, bowlerID, teamID)
            VALUES (?, ?, ?, ?, ?, ?);
        `;

        await db.query(query, [
            game1,
            game2,
            game3,
            scoresDate,
            bowlerID,
            teamID
        ]);

        res.redirect('/scores');

    } catch (error) {
        console.error('Error creating Score:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/deleteScore', async function (req, res) {
    try {
        const { scoresID } = req.body;

        const query = `
            DELETE FROM Scores
            WHERE scoresID = ?;
        `;

        await db.query(query, [scoresID]);

        res.redirect('/scores');

    } catch (error) {
        console.error('Error deleting Score:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/updateScore', async function (req, res) {
    try {
        const { scoresID, game1, game2, game3, scoresDate, bowlerID, teamID } = req.body;

        const query = `
            UPDATE Scores
            SET game1 = ?,
                game2 = ?,
                game3 = ?,
                scoresDate = ?,
                bowlerID = ?,
                teamID = ?
            WHERE scoresID = ?;
        `;

        await db.query(query, [
            game1,
            game2,
            game3,
            scoresDate,
            bowlerID,
            teamID,
            scoresID
        ]);

        res.redirect('/scores');

    } catch (error) {
        console.error('Error updating Score:', error);
        res.status(500).send('Database error.');
    }
});


// -------------------------------
// LANE ASSIGNMENTS
// -------------------------------
app.get('/laneAssignments', async function (req, res) {
    try {

        const laneQuery = `
            SELECT 
                la.laneAssignmentID,
                la.laneWeek,
                DATE_FORMAT(la.laneDate, '%Y-%m-%d') AS laneDate,
                la.laneNumber,
                t.teamName
            FROM LaneAssignments la
            JOIN Teams t ON la.teamID = t.teamID;
        `;

        const teamsQuery = `
            SELECT teamID, teamName
            FROM Teams;
        `;

        const [laneAssignments] = await db.query(laneQuery);
        const [teams] = await db.query(teamsQuery);

        res.render('laneAssignments', { laneAssignments, teams });

    } catch (error) {
        console.error('Error loading LaneAssignments:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/createLaneAssignment', async function (req, res) {
    try {
        const { laneWeek, laneDate, laneNumber, teamID } = req.body;

        const query = `
            INSERT INTO LaneAssignments
            (laneWeek, laneDate, laneNumber, teamID)
            VALUES (?, ?, ?, ?);
        `;

        await db.query(query, [
            laneWeek,
            laneDate,
            laneNumber,
            teamID
        ]);

        res.redirect('/laneAssignments');

    } catch (error) {
        console.error('Error creating LaneAssignment:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/deleteLaneAssignment', async function (req, res) {
    try {
        const { laneAssignmentID } = req.body;

        const query = `
            DELETE FROM LaneAssignments
            WHERE laneAssignmentID = ?;
        `;

        await db.query(query, [laneAssignmentID]);

        res.redirect('/laneAssignments');

    } catch (error) {
        console.error('Error deleting LaneAssignment:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/updateLaneAssignment', async function (req, res) {
    try {
        const { laneAssignmentID, laneWeek, laneDate, laneNumber, teamID } = req.body;

        const query = `
            UPDATE LaneAssignments
            SET laneWeek = ?,
                laneDate = ?,
                laneNumber = ?,
                teamID = ?
            WHERE laneAssignmentID = ?;
        `;

        await db.query(query, [
            laneWeek,
            laneDate,
            laneNumber,
            teamID,
            laneAssignmentID
        ]);

        res.redirect('/laneAssignments');

    } catch (error) {
        console.error('Error updating LaneAssignment:', error);
        res.status(500).send('Database error.');
    }
});


// -------------------------------
// TEAMS STANDINGS
// -------------------------------
app.get('/teamsStandings', async function (req, res) {
    try {

        const standingsQuery = `
            SELECT 
                ts.standingID,
                ts.standingWeek,
                ts.rank,
                ts.wins,
                ts.losses,
                t.teamName
            FROM TeamsStandings ts
            JOIN Teams t ON ts.teamID = t.teamID
            ORDER BY ts.standingID ASC;
        `;

        const teamsQuery = `
            SELECT teamID, teamName
            FROM Teams;
        `;

        const [teamsStandings] = await db.query(standingsQuery);
        const [teams] = await db.query(teamsQuery);

        res.render('teamsStandings', { teamsStandings, teams });

    } catch (error) {
        console.error('Error loading TeamsStandings:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/createTeamStanding', async function (req, res) {
    try {
        const { standingWeek, rank, wins, losses, teamID } = req.body;

        const query = `
            INSERT INTO TeamsStandings
            (standingWeek, rank, wins, losses, teamID)
            VALUES (?, ?, ?, ?, ?);
        `;

        await db.query(query, [
            standingWeek,
            rank,
            wins,
            losses,
            teamID
        ]);

        res.redirect('/teamsStandings');

    } catch (error) {
        console.error('Error creating TeamStanding:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/deleteTeamStanding', async function (req, res) {
    try {
        const { standingID } = req.body;

        const query = `
            DELETE FROM TeamsStandings
            WHERE standingID = ?;
        `;

        await db.query(query, [standingID]);

        res.redirect('/teamsStandings');

    } catch (error) {
        console.error('Error deleting TeamStanding:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/updateTeamStanding', async function (req, res) {
    try {
        const { standingID, standingWeek, rank, wins, losses, teamID } = req.body;

        const query = `
            UPDATE TeamsStandings
            SET standingWeek = ?,
                rank = ?,
                wins = ?,
                losses = ?,
                teamID = ?
            WHERE standingID = ?;
        `;

        await db.query(query, [
            standingWeek,
            rank,
            wins,
            losses,
            teamID,
            standingID
        ]);

        res.redirect('/teamsStandings');

    } catch (error) {
        console.error('Error updating TeamStanding:', error);
        res.status(500).send('Database error.');
    }
});

// -------------------------------
// BOWLERS TEAMS
// -------------------------------
app.get('/bowlersTeams', async function (req, res) {
    try {
        const query = `
            SELECT 
                bt.bowlerID,
                CONCAT(b.firstName, ' ', b.lastName) AS bowlerName,
                bt.teamID,
                t.teamName,
                DATE_FORMAT(bt.startDate, '%Y-%m-%d') AS startDate,
                DATE_FORMAT(bt.endDate, '%Y-%m-%d') AS endDate
            FROM BowlersTeams bt
            JOIN Bowlers b ON bt.bowlerID = b.bowlerID
            JOIN Teams t ON bt.teamID = t.teamID;
        `;

        const [bowlersTeams] = await db.query(query);
        res.render('bowlersTeams', { bowlersTeams });

    } catch (error) {
        console.error('Error loading BowlersTeams:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/deleteBowlersTeams', async function (req, res) {
    try {
        const { bowlerID, teamID } = req.body;

        const query = `
            DELETE FROM BowlersTeams
            WHERE bowlerID = ? AND teamID = ?;
        `;

        await db.query(query, [bowlerID, teamID]);

        res.redirect('/bowlersTeams');

    } catch (error) {
        console.error('Error deleting BowlersTeams row:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/createBowlersTeams', async function (req, res) {
    try {
        const { bowlerID, teamID, startDate, endDate } = req.body;

        const query = `
            INSERT INTO BowlersTeams
            (bowlerID, teamID, startDate, endDate)
            VALUES (?, ?, ?, ?);
        `;

        await db.query(query, [bowlerID, teamID, startDate, endDate]);

        res.redirect('/bowlersTeams');

    } catch (error) {
        console.error('Error creating BowlersTeams row:', error);
        res.status(500).send('Database error.');
    }
});

app.post('/updateBowlersTeams', async function (req, res) {
    try {
        const { originalBowlerID, bowlerID, teamID, startDate, endDate } = req.body;

        // Split composite key
        const [oldBowlerID, oldTeamID] = originalBowlerID.split('-');

        const query = `
            UPDATE BowlersTeams
            SET bowlerID = ?,
                teamID = ?,
                startDate = ?,
                endDate = ?
            WHERE bowlerID = ? AND teamID = ?;
        `;

        await db.query(query, [
            bowlerID,
            teamID,
            startDate,
            endDate,
            oldBowlerID,
            oldTeamID
        ]);

        res.redirect('/bowlersTeams');

    } catch (error) {
        console.error('Error updating BowlersTeams row:', error);
        res.status(500).send('Database error.');
    }
});

// -------------------------------
// RESET DATABASE
// -------------------------------
app.post('/resetDatabase', async function (req, res) {
    try {
        await db.query('CALL sp_reset_blms();');
        res.redirect('/');
    } catch (error) {
        console.error('Error resetting database:', error);
        res.status(500).send('Database reset failed.');
    }
});



// ############################################################
// ######################## LISTENER ###########################
// ############################################################

app.listen(PORT, function () {
    console.log(`Express started on http://localhost:${PORT}`);
});
