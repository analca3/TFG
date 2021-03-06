DROP TABLE result;
CREATE TABLE result (
		ReplayID INT NOT NULL,
        Duration INT NOT NULL,
		Frame INT NOT NULL,
        Minerals INT NOT NULL,
        Gas INT NOT NULL,
        Supply INT NOT NULL,
        TotalMinerals INT NOT NULL,
        TotalGas INT NOT NULL,
        TotalSupply INT NOT NULL,
        GroundUnitValue INT NOT NULL,
        BuildingValue INT NOT NULL,
        AirUnitValue INT NOT NULL,
        AObservedEnemyGroundUnitValue INT NOT NULL,
        AObservedEnemyBuildingValue INT NOT NULL,
        AObservedEnemyAirUnitValue INT NOT NULL,
        EnemyMinerals INT NOT NULL,
        EnemyGas INT NOT NULL,
        EnemySupply INT NOT NULL,
        EnemyTotalMinerals INT NOT NULL,
        EnemyTotalGas INT NOT NULL,
        EnemyTotalSupply INT NOT NULL,
        EnemyGroundUnitValue INT NOT NULL,
        EnemyBuildingValue INT NOT NULL,
        EnemyAirUnitValue INT NOT NULL,
        BObservedEnemyGroundUnitValue INT NOT NULL,
        BObservedEnemyBuildingValue INT NOT NULL,
        BObservedEnemyAirUnitValue INT NOT NULL,
        AObservedResourceValue INT NOT NULL,
        BObservedResourceValue INT NOT NULL,
        Winner CHAR NOT NULL,

        PRIMARY KEY (ReplayID, Frame)
    );

DROP PROCEDURE extractReplay;

DELIMITER //

CREATE PROCEDURE extractReplay (IN IDReplay INT)

BEGIN
	DECLARE PlayerA INT;
	DECLARE PlayerB INT;
	DECLARE repDuration INT;

  set @minerals = null;
  set @gas = null;
  set @supply = null;
  set @enemyMinerals = null;
  set @enemyGas = null;
  set @enemySupply = null;
  set @totMinerals = null;
  set @totGas = null;
  set @totSupply = null;
  set @winnerA = null;
  set @enemyTotMinerals = null;
  set @enemyTotGas = null;
  set @enemyTotSupply = null;
  set @winnerB = null;
  set @ground = null;
  set @building = null;
  set @air = null;
  set @aObservedEnemyGround = null;
  set @aObservedEnemyBuilding = null;
  set @aObservedEnemyAir = null;
  set @enemyGround = null;
  set @enemyBuilding = null;
  set @enemyAir = null;
  set @bObservedEnemyGround = null;
  set @bObservedEnemyBuilding = null;
  set @bObservedEnemyAir = null;
  set @resourcesA = null;
  set @resourcesB = null;

  set @minerals = 0;
	set @gas = 0;
	set @supply = 0;
	set @enemyMinerals = 0;
	set @enemyGas = 0;
	set @enemySupply = 0;
	set @totMinerals = 0;
	set @totGas = 0;
	set @totSupply = 0;
	set @winnerA = 0;
	set @enemyTotMinerals = 0;
	set @enemyTotGas = 0;
	set @enemyTotSupply = 0;
	set @winnerB = 0;
	set @ground = 0;
	set @building = 0;
	set @air = 0;
	set @aObservedEnemyGround = 0;
	set @aObservedEnemyBuilding = 0;
	set @aObservedEnemyAir = 0;
	set @enemyGround = 0;
	set @enemyBuilding = 0;
	set @enemyAir = 0;
	set @bObservedEnemyGround = 0;
	set @bObservedEnemyBuilding = 0;
	set @bObservedEnemyAir = 0;
	set @resourcesA = 0;
	set @resourcesB = 0;

	SELECT A.PlayerReplayID,
		B.PlayerReplayID
	INTO PlayerA,
		PlayerB
	FROM (
		SELECT PlayerReplayID
		FROM playerreplay pr
		WHERE pr.ReplayID = IDReplay
			AND pr.RaceID != 5
		) AS A
	INNER JOIN (
		SELECT PlayerReplayID
		FROM playerreplay pr
		WHERE pr.ReplayID = IDReplay
			AND pr.RaceID != 5
		) AS B
		ON A.PlayerReplayID < B.PlayerReplayID;

	SELECT Duration
	INTO repDuration
	FROM replay
	WHERE replay.ReplayID = IDReplay;

	-- Extract one replay
	INSERT INTO result (
		ReplayID,
		Duration,
		Frame,
		Minerals,
		Gas,
		Supply,
		TotalMinerals,
		TotalGas,
		TotalSupply,
		GroundUnitValue,
		BuildingValue,
		AirUnitValue,
		AObservedEnemyGroundUnitValue,
		AObservedEnemyBuildingValue,
		AObservedEnemyAirUnitValue,
		AObservedResourceValue,
		EnemyMinerals,
		EnemyGas,
		EnemySupply,
		EnemyTotalMinerals,
		EnemyTotalGas,
		EnemyTotalSupply,
		EnemyGroundUnitValue,
		EnemyBuildingValue,
		EnemyAirUnitValue,
		BObservedEnemyGroundUnitValue,
		BObservedEnemyBuildingValue,
		BObservedEnemyAirUnitValue,
		BObservedResourceValue,
		Winner
		)
	SELECT IDReplay,
		repDuration,
		AB.Frame,
    @minerals := IFNULL(Minerals, @minerals) AS Minerals,
		@gas := IFNULL(Gas, @gas) AS Gas,
		@supply := IFNULL(Supply, @supply) AS Supply,
		@totMinerals := IFNULL(TotalMinerals, @totMinerals) AS TotalMinerals,
		@totGas := IFNULL(TotalGas, @totGas) AS TotalGas,
		@totSupply := IFNULL(TotalSupply, @totSupply) AS TotalSupply,
		@ground := IFNULL(GroundUnitValue, @ground) AS GroundUnitValue,
		@building := IFNULL(BuildingValue, @building) AS BuildingValue,
		@air := IFNULL(AirUnitValue, @air) AS AirUnitValue,
		@aObservedEnemyGround := IFNULL(AObservedEnemyGroundUnitValue, @aObservedEnemyGround) AS AObservedEnemyGroundUnitValue,
		@aObservedEnemyBuilding := IFNULL(AObservedEnemyBuildingValue, @aObservedEnemyBuilding) AS AObservedEnemyBuildingValue,
		@aObservedEnemyAir := IFNULL(AObservedEnemyAirUnitValue, @aObservedEnemyAir) AS AObservedEnemyAirUnitValue,
		@resourcesA := IFNULL(AObservedResourceValue, @resourcesA) AObservedResourceValue,
		@enemyMinerals := IFNULL(EnemyMinerals, @enemyMinerals) AS EnemyMinerals,
		@enemyGas := IFNULL(EnemyGas, @enemyGas) AS EnemyGas,
		@enemySupply := IFNULL(EnemySupply, @enemySupply) AS EnemySupply,
		@enemyTotMinerals := IFNULL(EnemyTotalMinerals, @enemyTotMinerals) AS EnemyTotalMinerals,
		@enemyTotGas := IFNULL(EnemyTotalGas, @enemyTotGas) AS EnemyTotalGas,
		@enemyTotSupply := IFNULL(EnemyTotalSupply, @enemyTotSupply) AS EnemyTotalSupply,
		@enemyGround := IFNULL(EnemyGroundUnitValue, @enemyGround) AS EnemyGroundUnitValue,
		@enemyBuilding := IFNULL(EnemyBuildingValue, @enemyBuilding) AS EnemyBuildingValue,
		@enemyAir := IFNULL(EnemyAirUnitValue, @enemyAir) AS EnemyAirUnitValue,
		@bObservedEnemyGround := IFNULL(BObservedEnemyGroundUnitValue, @bObservedEnemyGround) AS BObservedEnemyGroundUnitValue,
		@bObservedEnemyBuilding := IFNULL(BObservedEnemyBuildingValue, @bObservedEnemyBuilding) AS BObservedEnemyBuildingValue,
		@bObservedEnemyAir := IFNULL(BObservedEnemyAirUnitValue, @bObservedEnemyAir) AS BObservedEnemyAirUnitValue,
		@resourcesB := IFNULL(BObservedResourceValue, @resourcesB) AS BObservedResourceValue,
    @winnerA := IFNULL(WinnerA, @winnerA) AS WinnerA
	FROM (
		SELECT IFNULL(A.Frame, B.Frame) AS Frame,
			A.Minerals,
			A.Gas,
			A.Supply,
			A.TotalMinerals,
			A.TotalGas,
			A.TotalSupply,
			CASE WHEN A.Winner=1 THEN 'A' ELSE 'B' END AS WinnerA,
			B.Minerals AS EnemyMinerals,
			B.Gas AS EnemyGas,
			B.Supply AS EnemySupply,
			B.TotalMinerals AS EnemyTotalMinerals,
			B.TotalGas AS EnemyTotalGas,
			B.TotalSupply AS EnemyTotalSupply,
			B.Winner AS WinnerB
		FROM (
			SELECT rc.Frame,
				pr.PlayerReplayID,
				rc.Minerals,
				rc.Gas,
				rc.Supply,
				rc.TotalMinerals,
				rc.TotalGas,
				rc.TotalSupply,
				pr.Winner
			FROM resourcechange rc
			INNER JOIN playerreplay pr
				ON pr.PlayerReplayID = rc.PlayerReplayID
			INNER JOIN replay r
				ON r.ReplayID = pr.ReplayID
			WHERE r.ReplayID = IDReplay
				AND pr.PlayerReplayID = PlayerA
			-- AND Frame > 0
			ORDER BY rc.Frame ASC
			) AS A
		LEFT JOIN (
			SELECT rc.Frame,
				pr.PlayerReplayID,
				rc.Minerals,
				rc.Gas,
				rc.Supply,
				rc.TotalMinerals,
				rc.TotalGas,
				rc.TotalSupply,
				pr.Winner
			FROM resourcechange rc
			INNER JOIN playerreplay pr
				ON pr.PlayerReplayID = rc.PlayerReplayID
			INNER JOIN replay r
				ON r.ReplayID = pr.ReplayID
			WHERE r.ReplayID = IDReplay
				AND pr.PlayerReplayID = PlayerB
			-- AND Frame > 0
			ORDER BY rc.Frame ASC
			) AS B
			ON A.Frame = B.Frame
				AND A.PlayerReplayID != B.PlayerReplayID

		UNION ALL

		SELECT IFNULL(A.Frame, B.Frame) AS Frame,
			A.Minerals,
			A.Gas,
			A.Supply,
			A.TotalMinerals,
			A.TotalGas,
			A.TotalSupply,
			A.Winner AS WinnerA,
			B.Minerals,
			B.Gas,
			B.Supply,
			B.TotalMinerals AS EnemyTotalMinerals,
			B.TotalGas AS EnemyTotalGas,
			B.TotalSupply AS EnemyTotalSupply,
			B.Winner AS WinnerB
		FROM (
			SELECT rc.Frame,
				pr.PlayerReplayID,
				rc.Minerals,
				rc.Gas,
				rc.Supply,
				rc.TotalMinerals,
				rc.TotalGas,
				rc.TotalSupply,
				pr.Winner
			FROM resourcechange rc
			INNER JOIN playerreplay pr
				ON pr.PlayerReplayID = rc.PlayerReplayID
			INNER JOIN replay r
				ON r.ReplayID = pr.ReplayID
			WHERE r.ReplayID = IDReplay
				AND pr.PlayerReplayID = PlayerA
			-- AND Frame > 0
			ORDER BY rc.Frame ASC
			) AS A
		RIGHT JOIN (
			SELECT rc.Frame,
				pr.PlayerReplayID,
				rc.Minerals,
				rc.Gas,
				rc.Supply,
				rc.TotalMinerals,
				rc.TotalGas,
				rc.TotalSupply,
				pr.Winner
			FROM resourcechange rc
			INNER JOIN playerreplay pr
				ON pr.PlayerReplayID = rc.PlayerReplayID
			INNER JOIN replay r
				ON r.ReplayID = pr.ReplayID
			WHERE r.ReplayID = IDReplay
				AND pr.PlayerReplayID = PlayerB
			-- AND Frame > 0
			ORDER BY rc.Frame ASC
			) AS B
			ON A.Frame = B.Frame
				AND A.PlayerReplayID != B.PlayerReplayID
		WHERE A.Frame IS NULL
		) AS AB
	LEFT JOIN (
		SELECT DISTINCT rc.Frame,
			sum(GroundUnitValue) AS GroundUnitValue,
			sum(BuildingValue) AS BuildingValue,
			sum(AirUnitValue) AS AirUnitValue,
			sum(EnemyGroundUnitValue) AS AObservedEnemyGroundUnitValue,
			sum(EnemyBuildingValue) AS AObservedEnemyBuildingValue,
			sum(EnemyAirUnitValue) AS AObservedEnemyAirUnitValue,
			sum(ResourceValue) AS AObservedResourceValue
		FROM resourcechange rc
		INNER JOIN regionvaluechange AS R1
			ON rc.PlayerReplayID = R1.PlayerReplayID
		WHERE rc.PlayerReplayID = PlayerA
			AND R1.Frame = (
				SELECT max(Frame)
				FROM regionvaluechange
				WHERE PlayerReplayID = PlayerA
					AND RegionID = R1.RegionID
					AND Frame <= rc.Frame
				GROUP BY RegionID
				)
		-- and rc.Frame > 0
		GROUP BY rc.Frame
		ORDER BY rc.Frame
		) AS C
		ON AB.Frame = C.Frame
	LEFT JOIN (
		SELECT DISTINCT rc.Frame,
			sum(GroundUnitValue) AS EnemyGroundUnitValue,
			sum(BuildingValue) AS EnemyBuildingValue,
			sum(AirUnitValue) AS EnemyAirUnitValue,
			sum(EnemyGroundUnitValue) AS BObservedEnemyGroundUnitValue,
			sum(EnemyBuildingValue) AS BObservedEnemyBuildingValue,
			sum(EnemyAirUnitValue) AS BObservedEnemyAirUnitValue,
			sum(ResourceValue) AS BObservedResourceValue
		FROM resourcechange rc
		INNER JOIN regionvaluechange AS R1
			ON rc.PlayerReplayID = R1.PlayerReplayID
		WHERE rc.PlayerReplayID = PlayerB
			AND R1.Frame = (
				SELECT max(Frame)
				FROM regionvaluechange
				WHERE PlayerReplayID = PlayerB
					AND RegionID = R1.RegionID
					AND Frame <= rc.Frame
				GROUP BY RegionID
				)
		-- and rc.Frame > 0
		GROUP BY rc.Frame
		ORDER BY rc.Frame
		) AS D
		ON AB.Frame = D.Frame
	ORDER BY AB.Frame;
END;
//

delete from result
select * from result
call extractReplay(114);

DROP PROCEDURE extractData;
DELIMITER //
CREATE PROCEDURE extractData ()
BEGIN

	DECLARE n_replay INT;

	DECLARE done INT DEFAULT FALSE;
    DECLARE C_Replay CURSOR FOR SELECT ReplayID FROM replay LIMIT 5;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN C_Replay;

    replay_loop: LOOP
		FETCH C_Replay INTO n_replay;

        IF done THEN LEAVE replay_loop; END IF;

        CALL `sc_pvp`.`extractReplay`(n_replay);

    END LOOP replay_loop;
END;
//

DELETE FROM result;
call extractData;
select * from result;
